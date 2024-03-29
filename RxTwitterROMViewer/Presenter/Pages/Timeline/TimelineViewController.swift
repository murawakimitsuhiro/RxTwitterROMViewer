//
//  TimelineViewController.swift
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
            self.reactor = TimelineReactor()
        }
        super.init(nibName: nil, bundle: nil)
        
        title = "タイムライン"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func bind(reactor: TimelineReactor) {
        // LyfeCycle
        rx.viewWillAppear
            .map { _ in Reactor.Action.reflseshTweets }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // Action
        mainView.rx.pullToReflesh
            .map { Reactor.Action.reflseshTweets }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mainView.rx.loadMore
            .map { Reactor.Action.loadMoreTweets }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mainView.rx.tableCellSelected
            .map { reactor.currentState.tweetCellReactors[$0.row].currentState.tweet }
            .subscribe(onNext: { [weak self] tweet in
                let reactor = TweetDetailReactor(tweet)
                let tweetViewController = TweetDetailViewController(reactor: reactor)
                self?.navigationController?.pushViewController(tweetViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        // State
        mainView.rx.setTweetDataSource(reactor.state.map { $0.tweetCellReactors })
            .disposed(by: disposeBag)
//        mainView.rx.setTweetDataSource(reactor.tweetCellReactors)
//            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isRefleshing }
            .distinctUntilChanged()
            .filter { !$0 }
            .bind(to: mainView.rx.isPullToRefleshing)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .filter { !$0 }
            .bind(to: mainView.rx.isLoadingMore)
            .disposed(by: disposeBag)
    }
}
