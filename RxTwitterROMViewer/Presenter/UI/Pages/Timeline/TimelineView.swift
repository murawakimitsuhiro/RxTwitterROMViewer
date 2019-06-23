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
    var pullToReflesh: Observable<Void> {
        return base.pullToRefleshSubject.asObserver()
    }
    
    var pullToRefleshing: Binder<Bool> {
        return Binder(self.base) { view, refleshing in
            if !refleshing {
                view.tableView.es.stopPullToRefresh()
            }
        }
    }

}

final class TimelineView: UIView {
    
    public let tableView = UITableView()

    fileprivate let pullToRefleshSubject = PublishSubject<Void>()
    
    init() {
        super.init(frame: .zero)
        
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = Color.blakcHaze
        
        tableView.es.addPullToRefresh { [weak self] in
            self?.pullToRefleshSubject.onNext(())
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
