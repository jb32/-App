//
//  TradeModel.swift
//  SocialProject
//
//  Created by Mac on 2018/8/23.
//  Copyright © 2018年 ZYY. All rights reserved.
//
import Foundation
import SwiftyJSON

struct TradeModel: JSONParsable {
    let ID: Int
    let dataStr: String
    let money: Double
    let type: Int
    let typeStr: String
    
    init(json: JSON) {
        self.ID = json["id"].intValue
        self.dataStr = json["dataStr"].string!
        self.money = json["money"].doubleValue
        self.type = json["type"].intValue
        self.typeStr = json["typeStr"].string!
    }
    
    static func parse(_ json: JSON) -> TradeModel? {
        return TradeModel(json: json)
    }
}
