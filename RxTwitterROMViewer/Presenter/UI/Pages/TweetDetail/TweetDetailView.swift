//
//  TweetDetailView.swift
//  RxTwitterROMViewer
//
//  Created by 村脇光洋 on 2019/06/26.
//  Copyright © 2019 murawaki. All rights reserved.
//

import UIKit

import PinLayout

final class TweetDetailView: UIView {
    
    private let iconImageView = UIImageView()

    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
