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
    
    public func mediaUrls(size: TwitterMedia.Size) -> [URL?] {
        if let medias = entities.media {
            return medias.map{ $0.mediaUrl(size: size) }
        }
        
        return [URL]()
    }
}
