//
//  TwitterAuthRepository.swift
//  RxTwitterROMViewer
//
//  Created by 村脇光洋 on 2019/06/21.
//  Copyright © 2019 murawaki. All rights reserved.
//

import RxCocoa
import RxSwift

protocol TwitterAuthRepository: class {
    /// Twitter Login, get AuthToken
    func auth() -> Single<String>
    func hasLoggedInUser() -> Bool
}
