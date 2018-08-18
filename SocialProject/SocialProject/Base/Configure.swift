//
//  ZYYConfigure.swift
//  TyreProject
//
//  Created by ZYY on 2017/7/12.
//  Copyright © 2017年 ZYY. All rights reserved.
//

import Foundation
import UIKit

// 网络接口
#if DEBUG // 调试环境

let ROOT_API_HOST: String = "http://192.168.1.184:8080/shejiaoappserver"
//let ROOT_API_HOST: String = "http://47.92.101.248:8080/shejiaoappserver"

#else // 正式环境
let ROOT_API_HOST: String = "http://192.168.71.10:8080/shejiaoappserver"

#endif

let DES_KEY: String = ""

let Image_Path: String = "http://oss-shejiao.oss-cn-beijing.aliyuncs.com/"

let RONGCLOUD_IM_APPKEY: String = "x4vkb1qpxfiok"

// MARK: - UI常量
let DEVICE_ID: String = UIDevice.current.identifierForVendor!.uuidString // 设备uuid
let DEVICE_WIDTH: CGFloat = UIScreen.main.bounds.width // 设备宽
let DEVICE_HEIGHT: CGFloat = UIScreen.main.bounds.height // 设备高
let userID: String = UserDefaults.standard.string(forKey: "ID") ?? ""
let token: String = UserDefaults.standard.string(forKey: "token") ?? ""
//配图视图外侧的间距
let PictureOutMargin = CGFloat(10)
//配图视图内侧的间距
let PictureInMargin = CGFloat(3)
//视图的宽度
let PictureViewWidth = DEVICE_WIDTH - 75
//每个item的width
let PicWidth = (PictureViewWidth - 2 * PictureInMargin) / 3

///cell浏览照片的通知
let StautsCellBrowserPhotoNotification = "StautsCellBrowserPhotoNotification"
///选中索引的key
let StatusCellBrowserPhotoSelectedIndexKey = "StatusCellBrowserPhotoSelectedIndexKey"
///浏览照片 URL字符串数组的key
let StatusCellBrowserPhotoURLsKey = "StatusCellBrowserPhotoURLsKey"
///父视图的图像视图数组的key
let StatusCellBrowserPhotoImageViewsKey = "StatusCellBrowserPhotoImageViewsKey"

let UPLOAD_IMAGE_SCALE: CGFloat = 0.5


var IS_LOGIN: Bool {
    return false
}

// 字体
extension UIFont {
    class var headFont: UIFont {
        return UIFont.systemFont(ofSize: 18)
    }
    
    class var subHeadFont: UIFont {
        return UIFont.systemFont(ofSize: 15)
    }
    
    class var body: UIFont {
        return UIFont.systemFont(ofSize: 14)
    }
}

// 颜色
extension UIColor {
    class var themOneColor: UIColor {
        return UIColor.colorWithHex("ff5175") 
    }
    
    class var themTwoColor: UIColor {
        return UIColor.colorWithHex("222222") // 黑
    }
    
    class var fontColor: UIColor {
        return UIColor.colorWithHex("606060")
    }
    
    class var backgroundColor: UIColor {
        return UIColor.colorWithHex("f5f5f5")
    }
}
		
