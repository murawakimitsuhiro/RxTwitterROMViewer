//
//  TimelineReactor.swift
//  RxTwitterROMViewer
//
//  Created by 村脇光洋 on 2019/06/19.
//  Copyright © 2019 murawaki. All rights reserved.
//

import RxCocoa
import RxSwift
import ReactorKit

final class TimelineReactor: Reactor {
    
    enum Action {
        case reflseshTweets
    }
    
    enum Mutation {
        case setLatestTweets([TweetEntity])
    }
    
    let initialState = State()
    
    struct State {
        var tweetEntities: [TweetEntity] = []
    }
    
    let timelineUseCase: TimelineUseCase
    
    init(timelineUseCase: TimelineUseCase) {
        self.timelineUseCase = timelineUseCase
    }
    
    func mutate(action: TimelineReactor.Action) -> Observable<TimelineReactor.Mutation> {
        switch action {
        case .reflseshTweets:
            return timelineUseCase
                .getLatestTimeline()
                .asObservable()
                .map{ Mutation.setLatestTweets($0) }
        }
    }
    
    func reduce(state: TimelineReactor.State, mutation: TimelineReactor.Mutation) -> TimelineReactor.State {
        var state = state
        
        switch mutation {
        case let .setLatestTweets(tweetEntities):
            state.tweetEntities = tweetEntities
            return state
        }
    }
}
