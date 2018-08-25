//
//  RechargeController.swift
//  SocialProject
//
//  Created by Mac on 2018/8/23.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit

class RechargeController: ZYYBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var moneyView: ZYYTemplateView = ZYYTemplateView.getTemplateView()
    enum PayType: Int {
        case bankpay = 1
        case wechatPay
        case alipay
    }
    
    let imageArray = ["shop_wallet", "shop_wechat", "shop_airpay"]
    let titleList: Array = ["银行卡充值", "微信充值", "支付宝充值"]
    let describtionList: Array = ["单笔限额20000，单日限额50000", "单笔限额20000，单日限额50000", "单笔限额20000，单日限额50000"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.moneyView.frame = self.view.bounds
        self.moneyView.nameTF.keyboardType = .decimalPad
        self.view.addSubview(self.moneyView)
        self.moneyView.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension RechargeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ZYYRechargeCell") as! ZYYRechargeCell
        cell.rechargeImgView.image = UIImage(named: imageArray[indexPath.row])
        cell.rechargeTitleLabel.text = titleList[indexPath.row]
        cell.rechargeDesciptionLabel.text = describtionList[indexPath.row]
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            let alert = LYAlertView(title: "提示：", message: "此功能暂未开放")
            alert.addAlertAction(with: "确定", style: .cancel)
            alert.show()
        case 1, 2:
            self.moneyView.isHidden = false
            self.moneyView.doneBtn.tag = 100 + indexPath.row
            self.moneyView.doneBtn.addTarget(self, action: #selector(payAction(btn:)), for: .touchUpInside)
        default:
            break
        }
    }
    
    @objc func payAction(btn: UIButton) {
        let row = btn.tag - 100
        if row == 1 {
            self.wechatAction()
        } else {
            self.aliPayAction()
        }
    }
    
    func wechatAction() {
        self.moneyView.isHidden = true
//        if WXApi.isWXAppInstalled() {
//            if !(self.moneyView.nameTF.text?.isEmpty)! {
//                self.showBlurHUD()
//                self.loadPayData(payType: .wechatPay, money: self.moneyView.nameTF.text!)
//            }
//        } else {
//            self.showBlurHUD(result: .failure, title: "请先安装微信")
//        }
    }
    
    func aliPayAction() {
        self.moneyView.isHidden = true
//        if !(self.moneyView.nameTF.text?.isEmpty)! {
//            self.showBlurHUD()
//            self.loadPayData(payType: .alipay, money: self.moneyView.nameTF.text!)
//        }
    }
    

}
