//
//  TweetEntity.swift
//  RxTwitterROMViewer
//
//  Created by 村脇光洋 on 2019/06/22.
//  Copyright © 2019 murawaki. All rights reserved.
//

struct TweetEntity: Codable {
    let id: Int64
    let text: String
    let createdAt: Date
    let user: TwitterUserEntity
    let entities: Entities
    
    struct Entities: Codable {
        let media: [TwitterMedia]?
    }
    
    public func medias() -> [TwitterMedia] {
        if let medias = entities.media {
            return medias
        }
        
        return [TwitterMedia]()
    }
}
