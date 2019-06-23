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
        case setRefleshing(Bool)
        case setLoading(Bool)
    }
    
    let initialState = State()
    
    struct State {
        var tweetCellReactors: [TweetCellReactor] = []
        var isRefleshing: Bool = false
        var isLoading: Bool = false
    }
    
    let timelineUseCase: TimelineUseCase
    
    init(timelineUseCase: TimelineUseCase) {
        self.timelineUseCase = timelineUseCase
    }
    
    func mutate(action: TimelineReactor.Action) -> Observable<TimelineReactor.Mutation> {
        switch action {
            
        case .reflseshTweets:
            let startReflesh = Observable<Mutation>.just(Mutation.setRefleshing(true))
            let endReflesh = Observable<Mutation>.just(Mutation.setRefleshing(false))
            let loadLatestTweet = timelineUseCase.getLatestTimeline()
                .asObservable()
                .map{ Mutation.setLatestTweets($0) }
            return .concat([startReflesh, loadLatestTweet, endReflesh])
        }
    }
    
    func reduce(state: TimelineReactor.State, mutation: TimelineReactor.Mutation) -> TimelineReactor.State {
        var state = state
        
        switch mutation {
            
        case let .setLatestTweets(tweetEntities):
            state.tweetCellReactors = tweetEntities.map { TweetCellReactor($0) }
            return state
            
        case let .setRefleshing(refleshing):
            state.isRefleshing = refleshing
            
            print("reflesh state ", refleshing)
            
            return state
            
        case let .setLoading(loading):
            state.isLoading = loading
            return state
        }
    }
}
