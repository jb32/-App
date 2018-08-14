//
//  DynamicContentController.swift
//  SocialProject
//
//  Created by Mac on 2018/7/16.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit
import DNSPageView

class DynamicContentController: ZYYBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dataArray: [DynamicModel] = []
    var type = "推荐"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: DEVICE_WIDTH, height: 1))
        self.getData()
    }
    
    func getData() {
        if type == "推荐" {
            self.getRecommendData()
        } else if type == "热门" {
            self.getHotData()
        } else if type == "好友动态" {
            self.dynamicRequest()
        } else {
            self.getProjectData(type: type)
        }
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

extension DynamicContentController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DynamicCell", for: indexPath) as! DynamicCell
        let model = self.dataArray[indexPath.row]
        cell.avatarImgView.setWebImage(with: model.image, placeholder: UIImage(named: "dynamic_avatar_boy"))
        cell.timeLabel.text = model.createtime
        cell.contentLabel.text = model.content
        cell.concernBtn.addTarget(self, action: #selector(btnsAction(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func btnsAction(_ sender: UIButton) {
        let cell = sender.superview?.superview as! ConnectionCell
        let indexPath = self.tableView.indexPath(for: cell)
        switch sender.tag {
        case 5000:
            self.concernRequest(indexPath: indexPath!)
        case 5001:
            self.praseRequest(indexPath: indexPath!)
        default:
            break
        }
    }
}

extension DynamicContentController {
    // 推荐
    func getRecommendData() {
        self.showBlurHUD()
        let recommendRequest = RecommendRequest()
        WebAPI.send(recommendRequest) { (isSuccess, result, error) in
            self.hideBlurHUD()
            if isSuccess {
                self.dataArray = (result?.objectModels)!
                self.tableView.reloadData()
            } else {
                self.showBlurHUD(result: .failure, title: error?.errorMsg)
            }
        }
    }
    
    // 热门
    func getHotData() {
        self.showBlurHUD()
        let hotRequest = HotRequest()
        WebAPI.send(hotRequest) { (isSuccess, result, error) in
            self.hideBlurHUD()
            if isSuccess {
                self.dataArray = (result?.objectModels)!
                self.tableView.reloadData()
            } else {
                self.showBlurHUD(result: .failure, title: error?.errorMsg)
            }
        }
    }
    
    // 项目
    func getProjectData(type: String) {
        self.showBlurHUD()
        let hotRequest = ProjectListRequest(type: type)
        WebAPI.send(hotRequest) { (isSuccess, result, error) in
            self.hideBlurHUD()
            if isSuccess {
                self.dataArray = (result?.objectModels)!
                self.tableView.reloadData()
            } else {
                self.showBlurHUD(result: .failure, title: error?.errorMsg)
            }
        }
    }
    
    // 好友动态
    func dynamicRequest() {
        self.showBlurHUD()
        let dynamicRequest = DynamicRequest(userId: userID)
        WebAPI.send(dynamicRequest) { (isSuccess, result, error) in
            self.hideBlurHUD()
            if isSuccess {
                self.dataArray = (result?.objectModels)!
                self.tableView.reloadData()
            } else {
                self.showBlurHUD(result: .failure, title: error?.errorMsg)
            }
        }
    }
    
    // 关注
    func concernRequest(indexPath: IndexPath) {
        self.showBlurHUD()
        let model = self.dataArray[indexPath.row]
        let attentionRequest = AttentionRequest(ID: userID, concernID: Int(model.id)!)
        WebAPI.send(attentionRequest) { (isSuccess, result, error) in
            self.hideBlurHUD()
            if isSuccess {
                self.showBlurHUD(result: .success, title: "关注成功") { [unowned self] in
                    self.getData()
                }
            } else {
                self.showBlurHUD(result: .failure, title: error?.errorMsg)
            }
        }
    }
    
    // 点赞
    func praseRequest(indexPath: IndexPath) {
        self.showBlurHUD()
        let model = self.dataArray[indexPath.row]
        let praiseRequest = PraiseRequest(ID: userID, userLoginId: Int(model.id)!)
        WebAPI.send(praiseRequest) { (isSuccess, result, error) in
            self.hideBlurHUD()
            if isSuccess {
                self.showBlurHUD(result: .success, title: "点赞成功") { [unowned self] in
                    self.getData()
                }
            } else {
                self.showBlurHUD(result: .failure, title: error?.errorMsg)
            }
        }
    }
    
    // 转发
    func transmitRequest(indexPath: IndexPath) {
        self.showBlurHUD()
        let model = self.dataArray[indexPath.row]
        let transmitRequest = TransmitRequest(ID: userID, loginId: Int(model.id)!)
        WebAPI.send(transmitRequest) { (isSuccess, result, error) in
            self.hideBlurHUD()
            if isSuccess {
                self.showBlurHUD(result: .success, title: "转发成功") { [unowned self] in
                    self.getData()
                }
            } else {
                self.showBlurHUD(result: .failure, title: error?.errorMsg)
            }
        }
    }
    
    // 收藏
    func collectRequest(indexPath: IndexPath) {
        self.showBlurHUD()
        let model = self.dataArray[indexPath.row]
        let collectRequest = CollectRequest(ID: userID, userLoginId: Int(model.id)!)
        WebAPI.send(collectRequest) { (isSuccess, result, error) in
            self.hideBlurHUD()
            if isSuccess {
                self.showBlurHUD(result: .success, title: "收藏成功") { [unowned self] in
                    self.getData()
                }
            } else {
                self.showBlurHUD(result: .failure, title: error?.errorMsg)
            }
        }
    }
}

extension DynamicContentController: DNSPageReloadable {
    func titleViewDidSelectedSameTitle() {
        print("重复点击了标题")
        self.getData()
    }
    
    func contentViewDidEndScroll() {
        print("contentView滑动结束")
    }
}
