//
//  DirectPushModel.swift
//  SocialProject
//
//  Created by Mac on 2018/7/25.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import Foundation
import SwiftyJSON

struct DirectPushModel: JSONParsable {
    let first: [SubModel]
    let second: [SubModel]
    
    init(json: JSON) {
        self.first = json["first"].arrayValue.map({ (eachJson: JSON) -> SubModel in
            SubModel.parse(eachJson)!
        })
        self.second = json["second"].arrayValue.map({ (eachJson: JSON) -> SubModel in
            SubModel.parse(eachJson)!
        })
    }
    
    static func parse(_ json: JSON) -> DirectPushModel? {
        return DirectPushModel(json: json)
    }
}

struct SubModel: JSONParsable {
    let name: String
    let id: String
    let mobile: String
    let admin_cost: String
    let direct_return: String
    let head_img: String
    let monthly_knot: String
    let direct_return_month: String
    let monthly_knot_month: String
    let admin_cost_month: String
    
    init(json: JSON) {
        self.name = json["name"].stringValue
        self.id = json["id"].stringValue
        self.mobile = json["mobile"].stringValue
        self.admin_cost = json["admin_cost"].stringValue
        self.direct_return = json["direct_return"].stringValue
        self.head_img = json["head_img"].stringValue
        self.monthly_knot = json["monthly_knot"].stringValue
        self.direct_return_month = json["direct_return_month"].stringValue
        self.monthly_knot_month = json["monthly_knot_month"].stringValue
        self.admin_cost_month = json["admin_cost_month"].stringValue
    }
    
    static func parse(_ json: JSON) -> SubModel? {
        return SubModel(json: json)
    }
}
