//
//  MemberModel.swift
//  SocialProject
//
//  Created by Mac on 2018/7/25.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import Foundation
import SwiftyJSON

struct MemberModel: JSONParsable {
    let id: Int
    let projectAnnouncement: String
    let dues: String
    let oneKeyConcern: String
    let vipIdentification: String
    let recomAddNum: String
    let type: String
    let adminRatio: String
    let groupNum: String
    let memberSearch: String
    let directReturnRatio: String
    let messageEveryDay: String
    let typeStr: String
    let batchAddFriends: String
    let monthlyKnotRatio: String
    let friendsGroup: String
    let onList: String
    let priority: String
    let friendsEveryDay: String
    let groupPeopleNum: String
    let redName: String
    let time: String
    let startFriendsNum: String
    let trumpetNum: String
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.projectAnnouncement = json["projectAnnouncement"].stringValue
        self.dues = json["dues"].stringValue
        self.oneKeyConcern = json["oneKeyConcern"].stringValue
        self.vipIdentification = json["vipIdentification"].stringValue
        self.recomAddNum = json["recomAddNum"].stringValue
        self.type = json["type"].stringValue
        self.adminRatio = json["adminRatio"].stringValue
        self.groupNum = json["groupNum"].stringValue
        self.memberSearch = json["memberSearch"].stringValue
        self.directReturnRatio = json["directReturnRatio"].stringValue
        self.messageEveryDay = json["messageEveryDay"].stringValue
        self.typeStr = json["typeStr"].stringValue
        self.batchAddFriends = json["batchAddFriends"].stringValue
        self.monthlyKnotRatio = json["monthlyKnotRatio"].stringValue
        self.friendsGroup = json["friendsGroup"].stringValue
        self.onList = json["onList"].stringValue
        self.priority = json["priority"].stringValue
        self.friendsEveryDay = json["friendsEveryDay"].stringValue
        self.groupPeopleNum = json["groupPeopleNum"].stringValue
        self.redName = json["redName"].stringValue
        self.time = json["time"].stringValue
        self.startFriendsNum = json["startFriendsNum"].stringValue
        self.trumpetNum = json["trumpetNum"].stringValue
    }
    
    static func parse(_ json: JSON) -> MemberModel? {
        return MemberModel(json: json)
    }
}
