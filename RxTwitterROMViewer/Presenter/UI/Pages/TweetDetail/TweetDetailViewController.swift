//
//  TweetDetailViewController.swift
//  RxTwitterROMViewer
//
//  Created by 村脇光洋 on 2019/06/26.
//  Copyright © 2019 murawaki. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import ReactorKit

final class TweetDetailViewController: UIViewController, ReactorKit.View {
    
    var disposeBag = DisposeBag()
   
    var mainView: TweetDetailView { return self.view as! TweetDetailView }
    
    init(reactor: TweetDetailReactor) {
        defer { self.reactor = reactor }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        self.view = TweetDetailView()
    }
    
    func bind(reactor: TweetDetailReactor) {
    
    }
}
