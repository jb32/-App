//
//  CircleModel.swift
//  SocialProject
//
//  Created by Mac on 2018/8/8.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import Foundation
import SwiftyJSON

struct CircleModel: JSONParsable {
    let id: Int
    let type: String
    var selected: Bool = false
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.type = json["type"].stringValue
    }
    
    static func parse(_ json: JSON) -> CircleModel? {
        return CircleModel(json: json)
    }
}
