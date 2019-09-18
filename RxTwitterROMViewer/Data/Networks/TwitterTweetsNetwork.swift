//
//  TwitterTweetsNetwork.swift
//  RxTwitterROMViewer
//
//  Created by 村脇光洋 on 2019/09/18.
//  Copyright © 2019 murawaki. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

final class TwitterTweetsNetwork: TwitterBaseNetwork {
    public static func getTimeline(maxId: Int64?, sinceId: Int64?) -> Single<[TweetEntity]> {
        var param: [String: String] = [
            "count": String(100),
            "exclude_replies": String(true),
        ]
        
        if let maxId = maxId {
            param["max_id"] = String(maxId - 1)
        }
        
        if let sinceId = sinceId {
            param["since_id"] = String(sinceId)
        }

        return self.request(endPoint: "statuses/home_timeline.json", param: param)
    }
}
