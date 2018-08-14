//
//  ConnectionModel.swift
//  SocialProject
//
//  Created by Mac on 2018/7/24.
//  Copyright © 2018年 ZYY. All rights reserved.
//
import Foundation
import SwiftyJSON

struct ConnectionModel: JSONParsable {
    let userAccount: ConnectionSubModel?
    let introduce: String
    
    init(json: JSON) {
        self.userAccount = ConnectionSubModel.parse(json["userAccount"])
        self.introduce = json["introduce"].stringValue
    }
    
    static func parse(_ json: JSON) -> ConnectionModel? {
        return ConnectionModel(json: json)
    }
}

struct ConnectionSubModel: JSONParsable {
    let id: String
    let name: String
    let mobile: String
    let type: String
    let sex: String
    let address: String
    let designType: String
    let registerTime: String
    let activeTime: String
    let headImg: String
    let longitude: String
    let latitude: String
    let album: String
    
    init(json: JSON) {
        self.id = json["id"].stringValue
        self.name = json["name"].stringValue
        self.mobile = json["mobile"].stringValue
        self.type = json["type"].stringValue
        self.sex = json["sex"].stringValue
        self.address = json["address"].stringValue
        self.designType = json["designType"].stringValue
        self.registerTime = json["registerTime"].stringValue
        self.activeTime = json["activeTime"].stringValue
        self.headImg = json["headImg"].stringValue
        self.longitude = json["longitude"].stringValue
        self.latitude = json["latitude"].stringValue
        self.album = json["album"].stringValue
    }
    
    static func parse(_ json: JSON) -> ConnectionSubModel? {
        return ConnectionSubModel(json: json)
    }
}
