//
//  LoginController.swift
//  SocialProject
//
//  Created by Mac on 2018/7/15.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit

class LoginController: ZYYBaseViewController {

    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.leftBarButtonItem = nil
        self.setRightItem(title: "注册")
    }
    
    override func rightAction() {
        let registerVC = UIStoryboard(name: .user).initialize(class: RegisterController.self)
        self.navigationController?.pushViewController(registerVC, animated: true)
//        let personalVC = UIStoryboard(name: .user).initialize(class: PersonalInfoController.self)
//        self.navigationController?.pushViewController(personalVC, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let phoneStr = NSString(string: phoneTF.text!).replacingOccurrences(of: " ", with: "")
        if phoneStr.length == 0 {
            self.showBlurHUD(result: .warning, title: "请输入手机号")
            return
        }
        if !String.validateMobile(mobileString: phoneStr) {
            self.showBlurHUD(result: .warning, title: "手机号码格式不正确")
            return
        }
        if self.passwordTF.text?.length == 0 {
            self.showBlurHUD(result: .warning, title: "请输入密码")
            return
        }
//        if (self.passwordTF.text?.length)! < 6 || (self.passwordTF.text?.length)! > 16 {
//            self.showBlurHUD(result: .warning, title: "用户名或密码错误")
//            return
//        }
        
        self.showBlurHUD()
        let loginRequest = LoginRequest(mobile: phoneStr, password: self.passwordTF.text!)
        WebAPI.send(loginRequest) { (isSuccess, result, error) in
            if isSuccess {
                UserDefaults.standard.set(result!["id"].stringValue, forKey: "ID")
                UserDefaults.standard.set(result!["token"].stringValue, forKey: "token")
                UserDefaults.standard.set(result!["circleType"].stringValue, forKey: "circleType")
                UserDefaults.standard.synchronize()
                self.login(name: phoneStr, userid: userID, token: token, password: self.passwordTF.text!.md5Hashed)
                LocationManager.shareManager.creatLocationManager().startLocation { (location, adress, error) in
                    print("经度 \(location?.coordinate.longitude ?? 0.0)")
                    print("纬度 \(location?.coordinate.latitude ?? 0.0)")
                    print("地址\(adress ?? "")")
                    print("error\(error ?? "没有错误")")
                    
                    let locationReuqest = LocationRequest(ID: userID, longitude: (location?.coordinate.longitude)!, latitude: (location?.coordinate.latitude)!)
                    WebAPI.send(locationReuqest, completeHandler: { (isSuccess, result, errror) in
                        self.hideBlurHUD()
                        if isSuccess {
                            if circleType.length == 0 {
                                let circleVC = UIStoryboard(name: .user).initialize(class: CircleController.self)
                                self.navigationController?.pushViewController(circleVC, animated: true)
                            } else {
                                let mainVC = UIStoryboard(name: .main).initialize(class: ZYYBaseTabbarController.self)
                                UIApplication.shared.keyWindow?.rootViewController = mainVC
                            }
                        } else {
                            
                        }
                    })
                }
            } else {
                self.showBlurHUD(result: .failure, title: error?.errorMsg)
            }
        }
        
    }
    
    // 忘记密码
    @IBAction func forgetPasswordAction(_ sender: UIButton) {
        let changePasswordVC = UIStoryboard(name: .user).initialize(class: ChangePasswordController.self)
        self.navigationController?.pushViewController(changePasswordVC, animated: true)
    }
    
}

extension LoginController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.phoneTF {
            if textField.text?.length == 3  && string.length != 0{
                textField.text = textField.text?.appending(" ")
            } else if textField.text?.length == 8  && string.length != 0{
                textField.text = textField.text?.appending(" ")
            }
            if textField.text?.length == 13 && string.length != 0{
                return false
            }
        }
        if textField == self.passwordTF {
            if (textField.text?.length)! >= 16 && string.length != 0 {
                return false
            }
        }
        return true
    }
}

// MARK: 融云登录
extension LoginController {
    func login(name: String, userid: String, token: String, password: String) {
        RCIM.shared().connect(withToken: token, success: { (userID) in
            print("登录成功 ==== 用户ID:" + userID!)
        }, error: { (status) in
            print("error status ==== %ld", status.rawValue)
        }) {
            print("token 错误")
        }
    }
}
