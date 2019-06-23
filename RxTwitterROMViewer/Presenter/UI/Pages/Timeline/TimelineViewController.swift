//
//  TimelineViewController.swift
//  RxTwitterROMViewer
//
//  Created by 村脇光洋 on 2019/06/19.
//  Copyright © 2019 murawaki. All rights reserved.
//

import UIKit

import RxSwift
import RxViewController
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
        defer {
            let tlUseCase = TimelineUseCase(tweetsRepository: TwitterNetwork())
            self.reactor = TimelineReactor(timelineUseCase: tlUseCase)
        }
        super.init(nibName: nil, bundle: nil)
        
        title = "タイムライン"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func bind(reactor: TimelineReactor) {
        // Action
        rx.viewWillAppear
            .map { _ in Reactor.Action.reflseshTweets }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        // State
        reactor.state.map { $0.tweetEntities }
            .subscribe(onNext: { tweets in
                print("geted tweets")
                print(tweets)
            })
            .disposed(by: disposeBag)
    }
}
