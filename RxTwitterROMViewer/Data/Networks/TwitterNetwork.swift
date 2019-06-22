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
import TwitterCore

final class TwitterNetwork: TwitterAuthRepository, TweetsRepository {
    
    enum ErrorType: Error {
        case unknownSession
    }
    
    private enum Const {
        static let baseUrl = URL(string: "https://api.twitter.com/1.1/statuses/")
    }
    
    private let client: TWTRAPIClient
    
    init() {
        client = TWTRAPIClient()
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
    
    func getTimeline(maxId: Int?) -> Single<[TweetEntity]> {
        guard let url = URL(string: "home_timeline.json", relativeTo: Const.baseUrl) else {
            fatalError("can not init url")
        }
        
        let param: [String: Any] = [:]
        
        return client.rx.request(url: url,
                          method: .get,
                          params: param)
            .map { data in
                print(data)
                
                // Todo
                
                return []
            }
    }
}
