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
    
    func bind(reactor: TimelineReactor) {
        
    }
}
