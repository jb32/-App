//
//  ChangePasswordController.swift
//  SocialProject
//
//  Created by Mac on 2018/8/7.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit

class ChangePasswordController: ZYYBaseViewController {
    
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var verifyCodeTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var verificationBtn: UIButton!
    
    var timer: Timer?
    var count = 60
    private var isVerification:Bool = false //表示是否发送了验证码

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // 发送验证码
    @IBAction func sendMessageAction(_ sender: UIButton) {
        let phoneStr = NSString(string: phoneTF.text!).replacingOccurrences(of: " ", with: "")
        if phoneStr.length == 0 {
            self.showBlurHUD(result: .warning, title: "请输入手机号")
            return
        }
        guard String.validateMobile(mobileString: phoneStr) == true else {
            self.showBlurHUD(result: .warning, title: "手机号码有误")
            return
        }
        
        self.showBlurHUD(title: "发送中")
        let messageRequest = SendMsgRequest(mobile: phoneStr)
        WebAPI.send(messageRequest, completeHandler: { (isSeccess, response, error) in
            if isSeccess {
                self.showBlurHUD(result: .success, title: "验证码发送成功")
                self.isVerification = true
                self.timer = Timer(timeInterval: 1, target: self, selector: #selector(self.timerDidFired(_:)), userInfo: nil, repeats: true)
                RunLoop.main.add(self.timer!, forMode: .defaultRunLoopMode)
            } else {
                self.showBlurHUD(result: .failure, title: error!.errorMsg)
            }
        })
    }
    
    // MARK: - 倒计时
    @objc private func timerDidFired(_ timer: Timer) {
        self.count = self.count - 1
        if self.count <= 0 {
            self.count = 60
            self.timer?.invalidate()
            self.timer = nil
            
            self.verificationBtn.isEnabled = true
            self.verificationBtn.setTitle("\(self.count)s", for: .disabled)
        } else {
            self.verificationBtn.isEnabled = false
            self.verificationBtn.setTitle("\(self.count)s", for: .disabled)
        }
        self.verificationBtn.setTitle(self.isVerification ? "重新获取" : "获取验证码", for: .normal)
    }

    @IBAction func changePasswordAction(_ sender: UIButton) {
        let phoneStr = NSString(string: phoneTF.text!).replacingOccurrences(of: " ", with: "")
        guard let verifyCode = self.verifyCodeTF.text, verifyCode.length > 0 else {
            self.showBlurHUD(result: .warning, title: "请输入验证码")
            return
        }
        guard let password = self.passwordTF.text, password.length > 0 else {
            self.showBlurHUD(result: .warning, title: "请输入密码")
            return
        }
        self.showBlurHUD()
        let changePasswordRequest = ChangePasswordRequest(code: self.verifyCodeTF.text!, mobile: phoneStr, password: self.passwordTF.text!)
        WebAPI.send(changePasswordRequest) { (isSuccess, result, error) in
            self.hideBlurHUD()
            if isSuccess {
                self.navigationController?.popViewController(animated: true)
            } else {
                self.showBlurHUD(result: .failure, title: error?.errorMsg)
            }
        }
    }
    
}

extension ChangePasswordController: UITextFieldDelegate {
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
