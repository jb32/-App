//
//  DynamicModel.swift
//  SocialProject
//
//  Created by Mac on 2018/7/24.
//  Copyright © 2018年 ZYY. All rights reserved.
//
import Foundation
import SwiftyJSON

struct DynamicModel: JSONParsable {
    let id: String
    let userid: String
    let type: String
    let content: String
    let image: String
    let video: String
    let prase: String
    let forward: String
    let comment: String
    let collection: String
    let createtime: String
    var praselen: String
    var forwardlen: String
    var collectionlen: String
    let nickname: String
    let headImg: String
    
    init(json: JSON) {
        self.id = json["id"].stringValue
        self.userid = json["userid"].stringValue
        self.type = json["type"].stringValue
        self.content = json["content"].stringValue
        self.image = json["image"].stringValue
        self.video = json["video"].stringValue
        self.prase = json["prase"].stringValue
        self.forward = json["forward"].stringValue
        self.comment = json["comment"].stringValue
        self.collection = json["collection"].stringValue
        self.createtime = json["createtime"].stringValue
        self.praselen = json["praselen"].stringValue
        self.forwardlen = json["forwardlen"].stringValue
        self.collectionlen = json["collectionlen"].stringValue
        self.nickname = json["nickname"].stringValue
        self.headImg = json["headImg"].stringValue
    }
    
    static func parse(_ json: JSON) -> DynamicModel? {
        return DynamicModel(json: json)
    }
}
