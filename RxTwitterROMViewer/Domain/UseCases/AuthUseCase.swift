//
//  AuthUseCase.swift
//  RxTwitterROMViewer
//
//  Created by 村脇光洋 on 2019/06/21.
//  Copyright © 2019 murawaki. All rights reserved.
//

import RxCocoa
import RxSwift

final class AuthUseCase {
    private let twitterAuthRepository: TwitterAuthRepository
    
    init(twitterAuthRepository: TwitterAuthRepository) {
        self.twitterAuthRepository = twitterAuthRepository
    }
    
    public var hasLoginUser: Bool {
        return twitterAuthRepository.hasLoggedInUser()
    }
    
    public func loginTwitter() -> Single<Void> {
        return twitterAuthRepository.auth().map{ _ in }
    }
}

