//
//  BrandModel.swift
//  SocialProject
//
//  Created by Mac on 2018/7/20.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import Foundation
import SwiftyJSON

struct BrandModel: JSONParsable {
    let id: Int
    let file_url: String
    let synopsis: String
    let add_time: String
    let author: String
    let content: String
    let img: String
    let title: String
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.file_url = json["file_url"].stringValue
        self.synopsis = json["synopsis"].stringValue
        self.add_time = json["add_time"].stringValue
        self.author = json["author"].stringValue
        self.content = json["content"].stringValue
        self.img = json["img"].stringValue
        self.title = json["title"].stringValue
    }
    
    static func parse(_ json: JSON) -> BrandModel? {
        return BrandModel(json: json)
    }
}
