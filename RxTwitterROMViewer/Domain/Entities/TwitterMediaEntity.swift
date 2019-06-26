//
//  TwitterMediaEntity.swift
//  RxTwitterROMViewer
//
//  Created by 村脇光洋 on 2019/06/26.
//  Copyright © 2019 murawaki. All rights reserved.
//

import Foundation

struct TwitterMedia: Codable {
    let mediaUrlHttps: String
    
    enum Size: String {
        case medium, thumb, small, large
    }
    
    public func mediaUrl(size: Size) -> URL? {
        return URL(string: "\(mediaUrlHttps):\(size.rawValue)")
    }
}
