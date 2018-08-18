//
//  RankModel.swift
//  SocialProject
//
//  Created by Mac on 2018/8/18.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import Foundation
import SwiftyJSON

struct RankModel: JSONParsable {
    let id: Int
    let head_img: String
    let name: String
    let mobile: String
    let end_time: String
    let memeber_type: String
    let register_time: String
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.head_img = json["head_img"].stringValue
        self.name = json["name"].stringValue
        self.mobile = json["mobile"].stringValue
        self.end_time = json["end_time"].stringValue
        self.memeber_type = json["memeber_type"].stringValue
        self.register_time = json["register_time"].stringValue
    }
    
    static func parse(_ json: JSON) -> RankModel? {
        return RankModel(json: json)
    }
}
