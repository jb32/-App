//
//  DirectPushController.swift
//  SocialProject
//
//  Created by Mac on 2018/7/25.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit

class DirectPushController: ZYYBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var model: DirectPushModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: DEVICE_WIDTH, height: 1))
        self.getReferralsListData()
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

extension DirectPushController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if model?.first.count == 0 {
            return 0
        } else {
            if model?.second.count == 0 {
                return 1
            } else {
                return 2
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if model != nil {
            if section == 0 {
                return (model?.first.count)!
            }
            return (model?.second.count)!
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReferralsCell", for: indexPath) as! ReferralsCell
        if model != nil {
            if indexPath.section == 0 {
                let first: [SubModel] = (self.model?.first)!
                let firstModel = first[indexPath.row]
                var defaultImg = UIImage(named: "avatar_boy")
//                if firstModel.sex == "1" {
//                    defaultImg = UIImage(named: "avatar_girl")
//                }
                cell.headImg.setWebImage(with: Image_Path+firstModel.head_img, placeholder: defaultImg)
                cell.nameLabel.text = firstModel.name
                cell.phoneLabel.text = firstModel.mobile
                cell.straightLabel.text = "直推佣金:"+(firstModel.direct_return_month)
                cell.monthLabel.text = "月结奖:"+(firstModel.monthly_knot_month)
                cell.manageLabel.text = "管理奖:"+(firstModel.admin_cost_month)
            } else {
                let second: [SubModel] = (self.model?.second)!
                let secondModel = second[indexPath.row]
                var defaultImg = UIImage(named: "avatar_boy")
//                if secondModel.sex == "1" {
//                    defaultImg = UIImage(named: "avatar_girl")
//                }
                cell.headImg.setWebImage(with: Image_Path+secondModel.head_img, placeholder: defaultImg)
                cell.nameLabel.text = secondModel.name
                cell.phoneLabel.text = secondModel.mobile
                cell.straightLabel.text = "直推佣金:"+(secondModel.direct_return_month)
                cell.monthLabel.text = "月结奖:"+(secondModel.monthly_knot_month)
                cell.manageLabel.text = "管理奖:"+(secondModel.admin_cost_month)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "一级"
        } else {
            return "二级"
        }
    }
}

extension DirectPushController {
    func getReferralsListData() {
        self.showBlurHUD()
        let directRequest = DirectPushRequest(ID: userID)
        WebAPI.send(directRequest) { (isSuccess: Bool, model: DirectPushModel?, error: NetworkError?) in
            self.hideBlurHUD()
            if isSuccess {
                self.model = model
                self.tableView.reloadData()
            } else {
                self.showBlurHUD(result: .failure, title: error?.errorMsg)
            }
        }
    }
}


