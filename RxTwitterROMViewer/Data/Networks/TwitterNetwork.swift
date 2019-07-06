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

final class TwitterNetwork: TwitterAuthRepository, TweetsRepository {    
    
    enum ErrorType: Error {
        case unknownSession
        case notLoggedIn
        case responseDataEmpty
    }
    
    private enum Const {
        static let baseUrl = URL(string: "https://api.twitter.com/1.1/")
    }
    
    private var loggedInClient: TWTRAPIClient? {
        if let userID = TWTRTwitter.sharedInstance().sessionStore.session()?.userID {
            return TWTRAPIClient(userID: userID)
        }
        
        return nil
    }
    
    private let decoder: JSONDecoder
    
    init() {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        self.decoder = decoder
    }

    public func hasLoggedInUser() -> Bool {
        return TWTRTwitter.sharedInstance().sessionStore.hasLoggedInUsers()
    }
    
    public func auth() -> Single<String> {
        return Single<String>.create { observer in
            TWTRTwitter.sharedInstance().logIn { (session, error) in
                if let error = error {
                    observer(.error(error))
                    return
                }
                
                guard let authToken = session?.authToken else {
                    observer(.error(ErrorType.unknownSession))
                    return
                }
                
                observer(.success(authToken))
            }
            
            return Disposables.create()
        }
    }
    
    func getTimeline(maxId: Int64?, sinceId: Int64?) -> Single<[TweetEntity]> {
        let url = URL(string: "statuses/home_timeline.json", relativeTo: Const.baseUrl)!
        var param: [String: String] = [
            "count": String(100),
            "exclude_replies": String(true),
        ]
        
        if let maxId = maxId {
            param["max_id"] = String(maxId - 1)
        }
        
        if let sinceId = sinceId {
            param["since_id"] = String(sinceId)
        }
        
        guard let client = loggedInClient else {
            return Single.error(ErrorType.notLoggedIn)
        }
        
        return client.rx.request(url: url,
                          method: .get,
                          params: param)
            .catchError({ error in
                print("Error TwitterNetwork", error)
                
                throw error
            })
            .map { data in                
                if let data = data,
                    let tweets = try? self.decoder.decode([TweetEntity].self, from: data) {
                    return tweets
                }
                
                throw ErrorType.responseDataEmpty
            }
    }
}
