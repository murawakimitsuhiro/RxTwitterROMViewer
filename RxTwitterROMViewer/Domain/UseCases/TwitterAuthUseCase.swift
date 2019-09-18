//
//  AuthUseCase.swift
//  RxTwitterROMViewer
//
//  Created by 村脇光洋 on 2019/06/21.
//  Copyright © 2019 murawaki. All rights reserved.
//

import RxCocoa
import RxSwift

extension TwitterAuthUseCase {
    public static let shared: TwitterAuthUseCase = TwitterAuthUseCase()
}

final class TwitterAuthUseCase {
    
    fileprivate init() {}
    
    public var hasLoginUser: Bool {
        return TwitterBaseNetwork.hasLoggedInUser()
    }
    
    public func loginTwitter() -> Single<Void> {
        return TwitterAuthNetwork.auth().map { _ in }
    }
}

