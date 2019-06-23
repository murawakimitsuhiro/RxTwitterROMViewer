//
//  TimelineUseCase.swift
//  RxTwitterROMViewer
//
//  Created by 村脇光洋 on 2019/06/22.
//  Copyright © 2019 murawaki. All rights reserved.
//

import RxCocoa
import RxSwift

final class TimelineUseCase {
    private let tweetsRepository: TweetsRepository
    
    init(tweetsRepository: TweetsRepository) {
        self.tweetsRepository = tweetsRepository
    }
    
    public func getLatestTimeline() -> Single<[TweetEntity]> {
        return tweetsRepository.getTimeline(maxId: nil)
    }
}
