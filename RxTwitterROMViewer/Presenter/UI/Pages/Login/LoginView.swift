//
//  LoginView.swift
//  RxTwitterROMViewer
//
//  Created by 村脇光洋 on 2019/06/19.
//  Copyright © 2019 murawaki. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

import PinLayout

extension Reactive where Base : LoginView {
    var touchUpInsideLoginButton: ControlEvent<Void> {
        return base.loginButton.rx.tap
    }
}

final class LoginView: UIView {
    
    private enum Const {
        static let loginButtonCornerRadius: CGFloat = 16
        static let loginButtonSize = CGSize(width: 180, height: 50)
    }
    
    fileprivate let loginButton = UIButton()
    
    init() {
        super.init(frame: .zero)
        
        loginButton.setTitle("Login Twitter", for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        loginButton.backgroundColor = Color.twitterBlue
        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = Const.loginButtonCornerRadius
        
        backgroundColor = .white
        addSubview(loginButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        loginButton.pin
            .size(Const.loginButtonSize)
            .center()
    }
}
