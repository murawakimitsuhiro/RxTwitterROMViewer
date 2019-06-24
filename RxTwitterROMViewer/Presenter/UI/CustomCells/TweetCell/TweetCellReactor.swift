//
//  TweetCellReactor.swift
//  RxTwitterROMViewer
//
//  Created by 村脇光洋 on 2019/06/23.
//  Copyright © 2019 murawaki. All rights reserved.
//

import ReactorKit

final class TweetCellReactor: Reactor {
    
    enum Action {}
    
    struct State {
        let tweet: TweetEntity
    }
    
    let initialState: TweetCellReactor.State
    
    var tweetId: Int64 {
        return currentState.tweet.id
    }
    
    init(_ tweet: TweetEntity) {
        initialState = State(tweet: tweet)
    }
}
