//
//  AppDelegate.swift
//  SocialProject
//
//  Created by Mac on 2018/7/12.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit
import Alamofire
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    lazy var reachabilityManager: NetworkReachabilityManager = {
        let manager: NetworkReachabilityManager = NetworkReachabilityManager()!
        manager.listener = { (status) -> Void in
            switch status {
            case .reachable(let type):
                switch type {
                case .ethernetOrWiFi:
                    break
                case .wwan:
                    let alert = LYAlertView(title: "提示：", message: "当前为非WiFi网络，请注意会消耗手机流量")
                    alert.addAlertAction(with: "确定", style: .cancel)
                    alert.show()
                }
            default:
                let alert = LYAlertView(title: "提示：", message: "无网络连接，请检查您的网络设")
                alert.addAlertAction(with: "确定", style: .cancel)
                alert.show()
            }
        }
        return manager
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.reachabilityManager.startListening()
        
        let navBar = UINavigationBar.appearance()
        navBar.isTranslucent = false
        //.设置导航栏标题颜色
        navBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18.0)]
        //.设置导航栏按钮颜色
        navBar.tintColor = UIColor.white
        //.设置导航栏背景颜色
        navBar.barTintColor = UIColor.themOneColor
        //.状态栏文字风格
        UIApplication.shared.statusBarStyle = .default
        
        //IQKeyboardManager
        _ = {
            let keyboardManager = IQKeyboardManager.shared
            keyboardManager.enable = true
            keyboardManager.enableAutoToolbar = false
            keyboardManager.shouldToolbarUsesTextFieldTintColor = true
            keyboardManager.shouldResignOnTouchOutside = true
        }()
        
        if !IS_LOGIN {
            let loginVC = UIStoryboard(name: .user).initialize(class: LoginController.self)
            self.window?.rootViewController = ZYYBaseNavigationController(rootViewController: loginVC)
        }
        
        RCIM.shared().initWithAppKey(RONGCLOUD_IM_APPKEY)
        RCIM.shared().connectionStatusDelegate = self
        RCIM.shared().receiveMessageDelegate = self
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension AppDelegate: RCIMConnectionStatusDelegate {
    func onRCIMConnectionStatusChanged(_ status: RCConnectionStatus) {
        if status == RCConnectionStatus.ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT {
            let alert = LYAlertView(title: "提示：", message: "您的帐号在别的设备上登录，您被迫下线！")
            alert.addAlertAction(with: "知道了", style: .cancel) { [unowned self] _ in
                let loginVC = UIStoryboard(name: .user).initialize(class: LoginController.self)
                self.window?.rootViewController = ZYYBaseNavigationController(rootViewController: loginVC)
                print("跳转到登录~~~~~~~~~~~~~~~~~~~~")
            }
            alert.show()
            
        } else if status == RCConnectionStatus.ConnectionStatus_TOKEN_INCORRECT {
            RCIM.shared().connect(withToken: token, success: { (userID) in
                
            }, error: { (status) in
                
            }) {
                
            }
        } else if status == RCConnectionStatus.ConnectionStatus_DISCONN_EXCEPTION {
            let alert = LYAlertView(title: "提示：", message: "您的帐号被封禁")
            alert.addAlertAction(with: "知道了", style: .cancel) { [unowned self] _ in
                let loginVC = UIStoryboard(name: .user).initialize(class: LoginController.self)
                self.window?.rootViewController = ZYYBaseNavigationController(rootViewController: loginVC)
                print("跳转到登录~~~~~~~~~~~~~~~~~~~~")
            }
            alert.show()
            
        }
    }
}

extension AppDelegate: RCIMReceiveMessageDelegate {
    func onRCIMCustomLocalNotification(_ message: RCMessage!, withSenderName senderName: String!) -> Bool {
        if message.content.isKind(of: RCGroupNotificationMessage.self) {
            return true
        }

        return false
    }
    
    func onRCIMReceive(_ message: RCMessage!, left: Int32) {
        if message.content.isKind(of: RCGroupNotificationMessage.self) {
            
        }
        
    }
}

