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
    
    var tweetCellReactors: ConnectableObservable<[TweetCellReactor]> {
        return TwitterTimelineUseCase.shared.mainTimelineTweets
            .map { $0.map { TweetCellReactor($0) } }
            .replay(1)
    }
    
    func mutate(action: TimelineReactor.Action) -> Observable<TimelineReactor.Mutation> {
        switch action {
            
        case .reflseshTweets:
            guard !currentState.isRefleshing else { return .empty() }
            
            let startReflesh = Observable<Mutation>.just(Mutation.setRefleshing(true))
            let loadLatestTweets = TwitterTimelineUseCase.shared.getLatestTimeline()
                .asObservable()
                .map { _ in Mutation.setRefleshing(false) }

            return .concat([startReflesh, loadLatestTweets])
            
        case .loadMoreTweets:
            guard !currentState.isLoading else { return .empty() }
            
            let startLoading = Observable.just(Mutation.setLoading(true))
            let loadOldTweets = TwitterTimelineUseCase.shared.getOldTimeline()
                .asObservable()
                .map { _ in Mutation.setLoading(false) }
            
            return .concat([startLoading, loadOldTweets])
        }
    }
    
    func transform(mutation: Observable<TimelineReactor.Mutation>) -> Observable<TimelineReactor.Mutation> {
        let timelineObservable = TwitterTimelineUseCase.shared.mainTimelineTweets
            .map { Mutation.setTweetReactors($0.map { TweetCellReactor($0) }) }
        
        return Observable.merge(mutation,
                                timelineObservable)
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
