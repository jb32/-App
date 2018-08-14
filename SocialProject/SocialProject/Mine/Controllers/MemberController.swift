//
//  MemberController.swift
//  SocialProject
//
//  Created by Mac on 2018/7/24.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit

class MemberController: ZYYBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    let titles = ["服务费", "直推充值返佣", "业绩奖", "群人数", "建群个数", "每天发消息", "每天加好友"]
    var commonArr: [String] = []
    var VIPArr: [String] = []
    var diamondArr: [String] = []
    var crownArr: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: DEVICE_WIDTH, height: 1))
        
        self.getMemberData()
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

extension MemberController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath) as! MemberCell
            if commonArr.count > 0 {
                cell.titleLabel.text = self.titles[indexPath.row - 1]
                cell.commonLabel.text = commonArr[indexPath.row - 1]
                cell.VIPLabel.text = VIPArr[indexPath.row - 1]
                cell.diamondLabel.text = diamondArr[indexPath.row - 1]
                cell.crownLabel.text = crownArr[indexPath.row - 1]
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension MemberController {
    func getMemberData() {
        self.showBlurHUD()
        let memberRequest = MemberRequest()
        WebAPI.send(memberRequest) { (isSuccess, result, error) in
            self.hideBlurHUD()
            if isSuccess {
                let dataArray = (result?.objectModels)!
                let commonModel = dataArray[0]
                self.commonArr = [commonModel.dues, "返充值的"+commonModel.directReturnRatio+"%", "拿直推总收入的"+commonModel.monthlyKnotRatio+"%", commonModel.groupPeopleNum+"人群", commonModel.groupNum, commonModel.messageEveryDay, commonModel.friendsEveryDay]
                
                let VIPModel = dataArray[1]
                self.VIPArr = [VIPModel.dues+"/1年服务费", "返充值的"+VIPModel.directReturnRatio+"%", "拿直推总收入的"+VIPModel.monthlyKnotRatio+"%", VIPModel.groupPeopleNum+"人群", VIPModel.groupNum, VIPModel.messageEveryDay, VIPModel.friendsEveryDay]
                
                let diamondModel = dataArray[2]
                self.diamondArr = [diamondModel.dues+"/2年", "返充值的"+diamondModel.directReturnRatio+"%", "拿直推总收入的"+diamondModel.monthlyKnotRatio+"%", diamondModel.groupPeopleNum+"人群", diamondModel.groupNum, diamondModel.messageEveryDay, diamondModel.friendsEveryDay]
                
                let crownModel = dataArray[3]
                self.crownArr = [crownModel.dues+"/3年", "返充值的"+crownModel.directReturnRatio+"%", "拿直推总收入的"+crownModel.monthlyKnotRatio+"%", crownModel.groupPeopleNum+"人群", crownModel.groupNum, crownModel.messageEveryDay, crownModel.friendsEveryDay]
                self.tableView.reloadData()
            } else {
                self.showBlurHUD(result: .failure, title: error?.errorMsg)
            }
        }
    }
}
