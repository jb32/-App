//
//  ContactModel.swift
//  SocialProject
//
//  Created by 薛 靖博 on 2018/8/10.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import Foundation
import SwiftyJSON

enum ContactModel: String {
    case id = "id"
    case data = "data"
    case list = "list"
    case name = "name"
    case headImg = "head_img"
    case mobile = "mobile"
    case count = "count"
    case friends = "friends"
}

extension ContactModel: JSONSubscriptType {
    var jsonKey: JSONKey {
        return JSONKey.key(rawValue)
    }
}





