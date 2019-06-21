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
        defer { self.reactor = LoginReactor() }
        super.init(nibName: nil, bundle: nil)
        
        title = "Login.."
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func bind(reactor: LoginReactor) {
    }
}
