//
//  TwitterNetwork.swift
//  RxTwitterROMViewer
//
//  Created by 村脇光洋 on 2019/06/21.
//  Copyright © 2019 murawaki. All rights reserved.
//

import RxCocoa
import RxSwift

import TwitterKit

class TwitterBaseNetwork {
    
    public enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    public enum ErrorType: Error {
        case unknownSession
        case notLoggedIn
        case responseDataEmpty
    }
    
    private enum Const {
        static let baseUrl = URL(string: "https://api.twitter.com/1.1/")
        static let maxRetryCount = 3
    }

    
    private static var loggedInClient: TWTRAPIClient? {
        if let userID = TWTRTwitter.sharedInstance().sessionStore.session()?.userID {
            return TWTRAPIClient(userID: userID)
        }
        
        return nil
    }
    
    private static let decoder: JSONDecoder = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(formatter)
        return decoder
    }()

    public static func hasLoggedInUser() -> Bool {
        return TWTRTwitter.sharedInstance().sessionStore.hasLoggedInUsers()
    }
    
    public static func request<T: Decodable>(endPoint: String, param: [String: String], method: HTTPMethod = .get) -> Single<T> {
        
        guard let client = loggedInClient else {
            return Single.error(ErrorType.notLoggedIn)
        }
        
        let url = URL(string: endPoint, relativeTo: Const.baseUrl)!
        
        return client.rx.request(url: url,
                                 method: HTTPMethod.get.rawValue,
                                 params: param)
            .retryWhen({ errorObserver in
                return errorObserver.enumerated()
                    .flatMap { retryCount, error -> Single<Void> in
                        guard retryCount < Const.maxRetryCount else {
                            return .error(error)
                        }
                        
                        print("retry....\(retryCount),,,")
                        dump(error)
                        
                        return Single.just(())
                }
            })
            .catchError({ error in
                print("Error TwitterNetwork", error)
                
                throw error
            })
            .map { data in
                if let data = data,
                    let models = try? self.decoder.decode(T.self, from: data) {
                    return models
                }
                
                throw ErrorType.responseDataEmpty
        }
    }
}
