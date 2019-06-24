//
//  TweetsRepository.swift
//  RxTwitterROMViewer
//
//  Created by 村脇光洋 on 2019/06/22.
//  Copyright © 2019 murawaki. All rights reserved.
//

import RxCocoa
import RxSwift

protocol TweetsRepository: class {
    func getTimeline(maxId: Int64?, sinceId: Int64?) -> Single<[TweetEntity]>
}
