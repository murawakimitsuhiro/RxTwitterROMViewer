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
        case loadMoreTweets
    }
    
    enum Mutation {
        case setTweetReactors([TweetCellReactor])
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
            guard !currentState.isRefleshing else { return .empty() }
            
            let startReflesh = Observable<Mutation>.just(Mutation.setRefleshing(true))
            let endReflesh = Observable<Mutation>.just(Mutation.setRefleshing(false))
            
            let currentTweetReactors = currentState.tweetCellReactors
            let loadLatestTweets = timelineUseCase.getLatestTimeline(sinceId: currentTweetReactors.first?.tweetId)
                .asObservable()
                .map { tweetEntities in tweetEntities.map { TweetCellReactor($0) } }
                .map { Mutation.setTweetReactors($0 + currentTweetReactors)}
            return .concat([startReflesh, loadLatestTweets, endReflesh])
            
        case .loadMoreTweets:
            guard !currentState.isLoading else { return .empty() }
            
            let startLoading = Observable.just(Mutation.setLoading(true))
            let endLoading = Observable.just(Mutation.setLoading(false))
            
            let currentTweetReactors = currentState.tweetCellReactors
            let loadOldTweets = timelineUseCase.getOldTimeline(olderTweetId: currentTweetReactors.last?.tweetId)
                .asObservable()
                .map { tweetEntities in tweetEntities.map { TweetCellReactor($0) } }
                .map { Mutation.setTweetReactors(currentTweetReactors + $0) }
            return .concat([startLoading, loadOldTweets, endLoading])
        }
    }
    
    func reduce(state: TimelineReactor.State, mutation: TimelineReactor.Mutation) -> TimelineReactor.State {
        var state = state
        
        switch mutation {
            
        case let .setTweetReactors(tweetCellReactors):
            state.tweetCellReactors = tweetCellReactors
            return state
            
        case let .setRefleshing(refleshing):
            state.isRefleshing = refleshing
            
            return state
            
        case let .setLoading(loading):
            state.isLoading = loading
            return state
        }
    }
}
