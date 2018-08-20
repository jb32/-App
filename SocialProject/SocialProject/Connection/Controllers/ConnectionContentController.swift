//
//  ConnectionContentController.swift
//  SocialProject
//
//  Created by Mac on 2018/7/16.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit
import DNSPageView

class ConnectionContentController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var dataArray: [UserModel] = []
    var type = "1"
    
    var pushAction:(_ vc: UserInfoViewController) -> Void = {_ in }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: DEVICE_WIDTH, height: 1))
        self.getConnectionPersonList(type: type)
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

extension ConnectionContentController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConnectionCell", for: indexPath) as! ConnectionCell
        let model = self.dataArray[indexPath.row]
        var defaultImg = UIImage(named: "avatar_boy")
        cell.nameLabel.textColor = UIColor.themTwoColor
        if model.sex == "1" {
            cell.nameLabel.textColor = UIColor.themOneColor
            defaultImg = UIImage(named: "avatar_girl")
        }
        cell.avartarImgView.setWebImage(with: Image_Path+model.headImg, placeholder: defaultImg)
        cell.projectNameLabel.text = model.newDynamic
        cell.nameLabel.text = model.name
        cell.concernCountLabel.text = model.concernNumber
        cell.distanceLabel.text = model.address + " " + model.distance
        cell.concernBtn.addTarget(self, action: #selector(concernAction(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func concernAction(_ sender: UIButton) {
        let cell = sender.superview?.superview as! ConnectionCell
        let indexPath = self.tableView.indexPath(for: cell)
        self.concernRequest(indexPath: indexPath!)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let userVC = UIStoryboard(name: .message).initialize(class: UserInfoViewController.self)
        let model = self.dataArray[indexPath.row]
        userVC.id = "\(model.id)"
        userVC.title = model.name
        self.pushAction(userVC)
    }
}

extension ConnectionContentController {
    func getConnectionPersonList(type: String) {
        self.showBlurHUD()
        let circleRequest = CircleRequest(ID: userID, type: type)
        WebAPI.send(circleRequest) { (isSuccess, result, error) in
            self.hideBlurHUD()
            if isSuccess {
                self.dataArray = (result?.objectModels)!
                self.tableView.reloadData()
            } else {
                self.showBlurHUD(result: .failure, title: error?.errorMsg)
            }
        }
    }

    func concernRequest(indexPath: IndexPath) {
        self.showBlurHUD()
        let model = self.dataArray[indexPath.row]
        self.showBlurHUD()
        let req = AttentionReq(id: userID, otherId: "\(model.id)")
        WebAPI.send(req) { (isSuccess, result, error) in
            self.hideBlurHUD()
            if isSuccess {
                self.showBlurHUD(result: .success, title: "关注成功") { [unowned self] in
                    self.getConnectionPersonList(type: self.type)
                }
            } else {
                self.showBlurHUD(result: .failure, title: error?.errorMsg)
            }
        }
    }
}

extension ConnectionContentController: DNSPageReloadable {
    func titleViewDidSelectedSameTitle() {
        print("重复点击了标题")
        self.getConnectionPersonList(type: self.type)
    }
    
    func contentViewDidEndScroll() {
        print("contentView滑动结束")
    }
}
