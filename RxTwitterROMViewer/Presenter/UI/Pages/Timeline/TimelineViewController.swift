//
//  TimelineViewController.swift
//  RxTwitterROMViewer
//
//  Created by 村脇光洋 on 2019/06/19.
//  Copyright © 2019 murawaki. All rights reserved.
//

import UIKit

import RxSwift
import ReactorKit

final class TimelineViewController: UIViewController , ReactorKit.View {
    
    var disposeBag = DisposeBag()
    
    private var mainView: TimelineView {
        return self.view as! TimelineView
    }
    
    override func loadView() {
        self.view = TimelineView()
    }
    
    init() {
        defer { self.reactor = TimelineReactor() }
        super.init(nibName: nil, bundle: nil)
        
        title = "タイムライン"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func bind(reactor: TimelineReactor) {
        
        // Todo testt
        let network = TwitterNetwork()
        network.getTimeline(maxId: nil)
            .subscribe(onSuccess: { tweets in
                print("success")
                print(tweets)
            }, onError: { (error) in
                print("error")
                print(error)
            })
            .disposed(by: disposeBag)
    }
}
