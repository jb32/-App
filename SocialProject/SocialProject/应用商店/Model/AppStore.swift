//
//  AppStore.swift
//  SocialProject
//
//  Created by 薛 靖博 on 2018/8/15.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import Foundation
import SwiftyJSON

enum AppStore: String {
    case classId = "class_id"
    case classType = "class_type"
    case appId = "application_id"
    case title = "title" //"名称",
    case content = "content" //"简介",
    case author = "author" //"作者",
    case authorEmail = "author_email" //"邮箱",
    case keywords = "keywords" //"下载量",
    case appType = "application_type" //"大小",
    case isOpen = "is_open" //"",
    case addTime = "add_time" //"创建时间",
    case fileUrl = "file_url" //"图片地址",
    case link = "link" //"链接地址"
    case id = "id" //1,
    case advUrl = "adv_url" //"图片地址",
    case advName = "adv_name" //"广告名称",
    case advContent = "adv_content" //"软件链接"
}

extension AppStore: JSONSubscriptType {
    var jsonKey: JSONKey {
        return JSONKey.key(rawValue)
    }
}












