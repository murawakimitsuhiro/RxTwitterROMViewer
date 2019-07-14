//
//  TimelineView.swift
//  RxTwitterROMViewer
//
//  Created by 村脇光洋 on 2019/06/19.
//  Copyright © 2019 murawaki. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

import ReusableKit
import ESPullToRefresh
import PinLayout

extension Reactive where Base: TimelineView {
    // Observable
    var pullToReflesh: Observable<Void> {
        return base.pullToRefleshSubject.asObserver()
    }
    
    var loadMore: Observable<Void> {
        return base.loadMoreSubject.asObservable()
    }
    
    var tableCellSelected: Observable<IndexPath> {
        return base.tableView.rx.itemSelected.asObservable()
    }
    
    // Binder
    var isPullToRefleshing: Binder<Bool> {
        return Binder(self.base) { view, refleshing in
            if !refleshing {
                view.tableView.es.stopPullToRefresh()
            }
        }
    }

    var isLoadingMore: Binder<Bool> {
        return Binder(self.base) { view, loading in
            if !loading {
                view.tableView.es.stopLoadingMore()
            }
        }
    }
    
    // Disposable
    func setTweetDataSource(_ source: Observable<[TweetCellReactor]>) -> Disposable {
        return source.bind(to: base.tableView.rx.items(Base.Reusable.tweetCell)) { _, reactor, cell in
                cell.reactor = reactor
        }
    }
}

final class TimelineView: UIView {
    
    fileprivate let tableView = UITableView()

    fileprivate let pullToRefleshSubject = PublishSubject<Void>()
    fileprivate let loadMoreSubject = PublishSubject<Void>()
    
    enum Reusable {
        static let tweetCell = ReusableCell<TweetCell>()
    }
    
    init() {
        super.init(frame: .zero)
        
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = Color.blakcHaze
        tableView.register(Reusable.tweetCell)
        
        tableView.es.addPullToRefresh { [weak self] in
            self?.pullToRefleshSubject.onNext(())
        }
        
        tableView.es.addInfiniteScrolling { [weak self] in
            self?.loadMoreSubject.onNext(())
        }
        
        addSubview(tableView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tableView.pin.all()
    }
}
