//
//  TimelineUseCase.swift
//  RxTwitterROMViewer
//
//  Created by 村脇光洋 on 2019/06/22.
//  Copyright © 2019 murawaki. All rights reserved.
//

import RxCocoa
import RxSwift

extension TwitterTimelineUseCase {
    public static let shared = TwitterTimelineUseCase()
}

final class TwitterTimelineUseCase {
    
    fileprivate init() {}
    
    public var mainTimelineTweets: BehaviorRelay<[TweetEntity]> = BehaviorRelay(value: [])
    
    public func getLatestTimeline() -> Single<[TweetEntity]> {
        let latestTweetId = mainTimelineTweets.value.first?.id
        
        return TwitterTweetsNetwork.getTimeline(maxId: nil, sinceId: latestTweetId)
            .do(onSuccess: { [weak self] tweets in
                guard let self = self else { return }
                self.mainTimelineTweets.accept(tweets + self.mainTimelineTweets.value)
            })
    }
    
    public func getOldTimeline() -> Single<[TweetEntity]> {
        let maxTweetId = mainTimelineTweets.value.last?.id
        
        return TwitterTweetsNetwork.getTimeline(maxId: maxTweetId, sinceId: nil)
            .do(onSuccess: { [weak self] tweets in
                guard let self = self else { return }
                self.mainTimelineTweets.accept( self.mainTimelineTweets.value + tweets )
            })
    }
}
