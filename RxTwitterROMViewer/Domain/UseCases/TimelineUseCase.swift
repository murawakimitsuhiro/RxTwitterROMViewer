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
    
    public func getLatestTimeline(sinceId: Int64? = nil) -> Single<[TweetEntity]> {
        return tweetsRepository.getTimeline(maxId: nil, sinceId: sinceId)
    }
    
    public func getOldTimeline(olderTweetId maxId: Int64?) -> Single<[TweetEntity]> {
        return tweetsRepository.getTimeline(maxId: maxId, sinceId: nil)
    }
}
