//
//  WalletController.swift
//  SocialProject
//
//  Created by Mac on 2018/7/18.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit

class WalletController: ZYYBaseViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var banlanceLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bgView.backgroundColor = .themOneColor
        self.getBanlanceData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 充值
    @IBAction func rechargeAction(_ sender: UIButton) {
        let rechargeVC = UIStoryboard(name: .mine).initialize(class: RechargeController.self)
        self.navigationController?.pushViewController(rechargeVC, animated: true)
    }
    
    // 明细
    @IBAction func detailsAction(_ sender: UIButton) {
        let detailsVC = UIStoryboard(name: .mine).initialize(class: DetailsController.self)
        self.navigationController?.pushViewController(detailsVC, animated: true)
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

extension WalletController {
    func getBanlanceData() {
        self.showBlurHUD()
        let balanceRequest = BalanceRequest(ID: userID)
        WebAPI.send(balanceRequest) { (isSuccess, result, error) in
            self.hideBlurHUD()
            if isSuccess {
                self.banlanceLabel.text = "余额：" + result!["balance"].stringValue
            } else {
                self.showBlurHUD(result: .failure, title: error?.errorMsg)
            }
        }
    }
}
