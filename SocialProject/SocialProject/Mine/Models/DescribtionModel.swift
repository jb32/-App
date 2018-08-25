//
//  DescribtionModel.swift
//  SocialProject
//
//  Created by Mac on 2018/8/24.
//  Copyright © 2018年 ZYY. All rights reserved.
//
import Foundation
import SwiftyJSON

struct DescribtionModel: JSONParsable {
    let ID: Int
    let images: String
    let account_id: String
    let show: Int
    let content: String
    
    init(json: JSON) {
        self.ID = json["id"].intValue
        self.images = json["images"].stringValue
        self.account_id = json["account_id"].stringValue
        self.show = json["show"].intValue
        self.content = json["content"].stringValue
    }
    
    static func parse(_ json: JSON) -> DescribtionModel? {
        return DescribtionModel(json: json)
    }
}

