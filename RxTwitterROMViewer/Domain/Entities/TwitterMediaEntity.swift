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
    let sizes: Sizes
    
    var aspectRatio: Float { return sizes.small?.aspectRatio ?? 1 }
    
    public func mediaUrl(size: SizeType) -> URL? {
        return URL(string: "\(mediaUrlHttps):\(size.rawValue)")
    }
    
    struct Sizes: Codable {
        let medium: Size?
        let thumb: Size?
        let small: Size?
        let large: Size?
        
        public func size(_ type: SizeType) -> Size? {
            switch type {
            case .medium: return medium
            case .thumb: return thumb
            case .small: return small
            case .large: return large
            }
        }
    }
    
    struct Size: Codable {
        let w: Int
        let h: Int
        let resize: String
        
        public var aspectRatio: Float { return Float(w)/Float(h)  }
    }
    
    enum SizeType: String {
        case medium, thumb, small, large
    }
}
