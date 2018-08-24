//
//  CommentModel.swift
//  SocialProject
//
//  Created by Mac on 2018/8/15.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import Foundation
import SwiftyJSON

struct CommentModel: JSONParsable {
    let id: String
    let movementid: String
    let commentid: String
    let comment: String
    let commenttime: String
    let commentNickname: String
    let commentImg: String
    
    init(json: JSON) {
        self.id = json["id"].stringValue
        self.movementid = json["movementid"].stringValue
        self.commentid = json["commentid"].stringValue
        self.comment = json["comment"].stringValue
        self.commenttime = json["commenttime"].stringValue
        self.commentNickname = json["commentNickname"].stringValue
        self.commentImg = json["commentImg"].stringValue
    }
    
    static func parse(_ json: JSON) -> CommentModel? {
        return CommentModel(json: json)
    }
}
