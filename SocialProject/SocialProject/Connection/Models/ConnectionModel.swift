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
    let id: Int
    let name: String
    let mobile: String
    let type: String
    let sex: String
    let sexStr: String
    let address: String
    let designType: String
    let registerTime: String
    let activeTime: String
    let headImg: String
    let longitude: String
    let latitude: String
    let registerTimeStr: String
    let activeTimeStr: String
    let album: String
    let industry: String
    let age: String
    let dateOfBirth: String
    let autograph: String
    let distance: String
    let userAddress: String
    let concernNumber: String
    let newDynamic: String
    let followState: Bool
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.mobile = json["mobile"].stringValue
        self.type = json["type"].stringValue
        self.sex = json["sex"].stringValue
        self.sexStr = json["sexStr"].stringValue
        self.address = json["address"].stringValue
        self.designType = json["designType"].stringValue
        self.registerTime = json["registerTime"].stringValue
        self.activeTime = json["activeTime"].stringValue
        self.headImg = json["headImg"].stringValue
        self.longitude = json["longitude"].stringValue
        self.latitude = json["latitude"].stringValue
        self.registerTimeStr = json["registerTimeStr"].stringValue
        self.activeTimeStr = json["activeTimeStr"].stringValue
        self.album = json["album"].stringValue
        self.industry = json["industry"].stringValue
        self.age = json["age"].stringValue
        self.dateOfBirth = json["dateOfBirth"].stringValue
        self.autograph = json["autograph"].stringValue
        self.distance = json["distance"].stringValue
        self.userAddress = json["userAddress"].stringValue
        self.concernNumber = json["concernNumber"].stringValue
        self.newDynamic = json["newDynamic"].stringValue
        self.followState = json["followState"].boolValue
    }
    
    static func parse(_ json: JSON) -> ConnectionModel? {
        return ConnectionModel(json: json)
    }
}
