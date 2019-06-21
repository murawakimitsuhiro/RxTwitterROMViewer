//
//  LoginViewController.swift
//  RxTwitterROMViewer
//
//  Created by 村脇光洋 on 2019/06/19.
//  Copyright © 2019 murawaki. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import RxViewController
import ReactorKit

final class LoginViewController: UIViewController , ReactorKit.View {
    
    var disposeBag = DisposeBag()
    
    private var mainView: LoginView {
        return self.view as! LoginView
    }
    
    override func loadView() {
        self.view = LoginView()
    }
    
    init() {
        defer {
            let authUseCase = AuthUseCase(twitterAuthRepository: TwitterNetwork())
            self.reactor = LoginReactor(authUseCase: authUseCase)
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func bind(reactor: LoginReactor) {
        // Action
        mainView.rx.tapLoginButton
            .map { Reactor.Action.login }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        // State
        reactor.state.map { $0.isLoggedIn }
            .distinctUntilChanged()
            .filter { $0 }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.presentTimelineViewController()
            })
            .disposed(by: disposeBag)
    }
    
    private func presentTimelineViewController() {
        let timelineVC = TimelineViewController()
        let navC = UINavigationController(rootViewController: timelineVC)
        present(navC, animated: true, completion: nil)
    }
}
