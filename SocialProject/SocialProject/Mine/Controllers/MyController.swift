//
//  MyController.swift
//  SocialProject
//
//  Created by Mac on 2018/8/16.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit

class MyController: UITableViewController {
    
    var pushAction:(_ vc: UIViewController) -> Void = {_ in }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: DEVICE_WIDTH, height: 1))
    }
    
    @IBAction func btnsAction(_ sender: UIButton) {
        switch sender.tag {
        case 523:
            // 扫一扫
            let qrcodeVC = SWQRCodeViewController()
            self.pushAction(qrcodeVC)
        default:
            // 我的二维码
            let myqrcodeVC = QRCodeViewController()
            self.pushAction(myqrcodeVC)
            break
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 1:
            let walletVC = UIStoryboard(name: .mine).initialize(class: WalletController.self)
            self.pushAction(walletVC)
        case 2:
            let pushVC = UIStoryboard(name: .mine).initialize(class: DirectPushController.self)
            self.pushAction(pushVC)
        case 3:
            let collectionVC = UIStoryboard(name: .mine).initialize(class: CollectionController.self)
            self.pushAction(collectionVC)
        case 4:
            let personalVC = UIStoryboard(name: .user).initialize(class: PersonalInfoController.self)
            self.pushAction(personalVC)
        case 5:
            let memberVC = UIStoryboard(name: .mine).initialize(class: MemberController.self)
            self.pushAction(memberVC)
        default:
            break
        }
    }

}
