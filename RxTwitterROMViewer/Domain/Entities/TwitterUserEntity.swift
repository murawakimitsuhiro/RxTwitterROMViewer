//
//  TwitterUserEntity.swift
//  RxTwitterROMViewer
//
//  Created by 村脇光洋 on 2019/06/23.
//  Copyright © 2019 murawaki. All rights reserved.
//

import Foundation

struct TwitterUserEntity: Codable {
    let id: Int64
    let name: String
    let screenName: String
    let description: String
    let profileBackgroundImageUrlHttps: String
    let profileImageUrlHttps: String
}
