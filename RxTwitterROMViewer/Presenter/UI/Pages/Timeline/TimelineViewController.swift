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
import ReusableKit

final class TimelineViewController: UIViewController , ReactorKit.View {
    
    var disposeBag = DisposeBag()
    
    enum Reusable {
        static let tweetCell = ReusableCell<TweetCell>()
    }
    
    private var mainView: TimelineView {
        return self.view as! TimelineView
    }
    
    override func loadView() {
        self.view = TimelineView()
        
        mainView.tableView.register(Reusable.tweetCell)
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
        Observable
            .merge(
                rx.viewWillAppear.map { _ in } ,
                mainView.rx.pullToReflesh.map {}
            )
            .map { _ in Reactor.Action.reflseshTweets }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mainView.rx.loadMore
            .map { Reactor.Action.loadMoreTweets }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        // State
        reactor.state.map { $0.tweetCellReactors }
            .bind(to: mainView.tableView.rx.items(Reusable.tweetCell)) { _, reactor, cell in
                cell.reactor = reactor
            }
            .disposed(by: disposeBag)
        
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
