//
//  UserModel.swift
//  SocialProject
//
//  Created by Mac on 2018/7/23.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import Foundation
import SwiftyJSON

struct UserModel: JSONParsable {
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
    let tsMemberInfo: MemeberModel?
    let industry: String
    let age: String
    let dateOfBirth: String
    let autograph: String
    let distance: String
    let userAddress: String
    let concernNumber: String
    let newDynamic: String
    
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
        self.tsMemberInfo = MemeberModel.parse(json["tsMemberInfo"])
        self.industry = json["industry"].stringValue
        self.age = json["age"].stringValue
        self.dateOfBirth = json["dateOfBirth"].stringValue
        self.autograph = json["autograph"].stringValue
        self.distance = json["distance"].stringValue
        self.userAddress = json["userAddress"].stringValue
        self.concernNumber = json["concernNumber"].stringValue
        self.newDynamic = json["newDynamic"].stringValue
    }
    
    static func parse(_ json: JSON) -> UserModel? {
        return UserModel(json: json)
    }
}

struct MemeberModel: JSONParsable {
    let id: Int
    let endTime: String
    let endTimeStr: String
    let endTimeNum: String
    let directReturn: String
    let memeberType: String
    let monthlyKnot: String
    let friendsSum: String
    let friendsLimit: String
    let groupNum: String
    let groupPeopleNum: String
    let trumpet: String
    let accountId: String
    let refereeId: String
    let adminCost: String
    let memeberTypeStr: String
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.endTime = json["endTime"].stringValue
        self.endTimeStr = json["endTimeStr"].stringValue
        self.endTimeNum = json["endTimeNum"].stringValue
        self.directReturn = json["directReturn"].stringValue
        self.memeberType = json["memeberType"].stringValue
        self.monthlyKnot = json["monthlyKnot"].stringValue
        self.friendsSum = json["friendsSum"].stringValue
        self.friendsLimit = json["friendsLimit"].stringValue
        self.groupNum = json["groupNum"].stringValue
        self.groupPeopleNum = json["groupPeopleNum"].stringValue
        self.trumpet = json["trumpet"].stringValue
        self.accountId = json["accountId"].stringValue
        self.refereeId = json["refereeId"].stringValue
        self.adminCost = json["adminCost"].stringValue
        self.memeberTypeStr = json["memeberTypeStr"].stringValue
    }
    
    static func parse(_ json: JSON) -> MemeberModel? {
        return MemeberModel(json: json)
    }
}
