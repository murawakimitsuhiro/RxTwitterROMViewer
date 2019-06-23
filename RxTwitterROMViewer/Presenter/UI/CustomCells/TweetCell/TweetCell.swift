//
//  TweetCell.swift
//  RxTwitterROMViewer
//
//  Created by 村脇光洋 on 2019/06/23.
//  Copyright © 2019 murawaki. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import ReactorKit

final class TweetCell: UITableViewCell, ReactorKit.View {
    
    var disposeBag = DisposeBag()
    
    func bind(reactor: TweetCellReactor) {
        // State
        reactor.state.map { $0.tweet }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (tweet) in
                self.textLabel?.text = tweet.user.name
            })
            .disposed(by: disposeBag)
    }
}
