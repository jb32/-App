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
//let ROOT_API_HOST: String = "http://192.168.71.7:8080/shejiaoappserver"
let ROOT_API_HOST: String = "http://192.168.1.184:8080/shejiaoappserver"

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

// 支持的年份
let YEARS: [Int] = [2017]

let UPLOAD_IMAGE_SCALE: CGFloat = 0.5
let SERVICE_PHONE: String = "400-8888-8888"

let userID: String = UserDefaults.standard.string(forKey: "ID") ?? ""
let token: String = UserDefaults.standard.string(forKey: "token") ?? ""

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
		
