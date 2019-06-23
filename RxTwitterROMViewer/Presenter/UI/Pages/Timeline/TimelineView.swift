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
import PinLayout

final class TimelineView: UIView {
    
    public let tableView = UITableView()
    
    init() {
        super.init(frame: .zero)
        
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
