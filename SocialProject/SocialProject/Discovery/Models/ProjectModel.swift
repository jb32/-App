//
//  ProjectModel.swift
//  SocialProject
//
//  Created by Mac on 2018/7/23.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ParentModel: JSONParsable {
    let id: String
    let typeName: String
    let file_url: String
    
    init(json: JSON) {
        self.id = json["id"].stringValue
        self.typeName = json["typeName"].stringValue
        self.file_url = json["file_url"].stringValue
    }
    
    static func parse(_ json: JSON) -> ParentModel? {
        return ParentModel(json: json)
    }
}

struct ProjectModel: JSONParsable {
    let id: Int
    let add_time: String
    let typeName: String
    let title: String
    let author: String
    let synopsis: String
    let content: String
    let file_url: String
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.add_time = json["add_time"].stringValue
        self.typeName = json["typeName"].stringValue
        self.title = json["title"].stringValue
        self.author = json["author"].stringValue
        self.synopsis = json["synopsis"].stringValue
        self.content = json["content"].stringValue
        self.file_url = json["file_url"].stringValue
    }
    
    static func parse(_ json: JSON) -> ProjectModel? {
        return ProjectModel(json: json)
    }
}
