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

final class TwitterNetwork: TwitterAuthRepository {
    
    enum ErrorType: Error {
        case unknownSession
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
}
