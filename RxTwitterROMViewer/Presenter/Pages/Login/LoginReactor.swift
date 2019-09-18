//
//  LoginReactor.swift
//  RxTwitterROMViewer
//
//  Created by 村脇光洋 on 2019/06/19.
//  Copyright © 2019 murawaki. All rights reserved.
//

import RxCocoa
import RxSwift
import ReactorKit

final class LoginReactor: Reactor {
    
    enum Action {
        case login
    }
    
    enum Mutation {
        case setLoggedIn(Bool)
    }
    
    let initialState = State(isLoggedIn: false)
    
    struct State {
        var isLoggedIn: Bool
    }
    
    func mutate(action: LoginReactor.Action) -> Observable<LoginReactor.Mutation> {
        switch action {
        case .login:
            return TwitterAuthUseCase.shared.loginTwitter()
                .asObservable()
                .map { true }
                .catchErrorJustReturn(false)
                .map(Mutation.setLoggedIn)
        }
    }
    
    func reduce(state: LoginReactor.State, mutation: LoginReactor.Mutation) -> LoginReactor.State {
        var state = state
        
        switch mutation {
        case let .setLoggedIn(isLoggedIn):
            state.isLoggedIn = isLoggedIn
            return state
        }
    }
}
