//
//  TwitterNavigationBar.swift
//  RxTwitterROMViewer
//
//  Created by 村脇光洋 on 2019/06/22.
//  Copyright © 2019 murawaki. All rights reserved.
//

import UIKit

final class TwitterNavigationBar: UINavigationBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupViews()
    }
    
    private func setupViews() {
        isTranslucent = false
        barTintColor = Color.twitterBlue
        tintColor = .white
        titleTextAttributes = [.foregroundColor: UIColor.white]
        setBackgroundImage(UIImage(), for: .default)
        shadowImage = UIImage()
    }
}
