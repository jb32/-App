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
    
    var pushAction:(_ vc: CommentListController) -> Void = {_ in }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: DEVICE_WIDTH, height: 1))
        self.getData()
        
        //注册通知
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(browserPhoto),
                                               name: NSNotification.Name(rawValue: StautsCellBrowserPhotoNotification),
                                               object: nil)
    }
    
    deinit {
        //注销通知
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK:浏览照片的通知监听方法
    @objc fileprivate func browserPhoto(n: Notification){
        //1.从通知的userInfo提取参数
        guard let selectedIndex = n.userInfo?[StatusCellBrowserPhotoSelectedIndexKey] as? Int,
            let urls = n.userInfo?[StatusCellBrowserPhotoURLsKey] as? [String],
            let imageViewList = n.userInfo?[StatusCellBrowserPhotoImageViewsKey] as? [UIImageView]
            else{
                return
        }
        
        //展现照片浏览控制器
        let vc = HMPhotoBrowserController.photoBrowser(withSelectedIndex: selectedIndex,
                                                       urls: urls,
                                                       parentImageViews: imageViewList)
        present(vc, animated: true, completion: nil)
        
    }
    
    func getData() {
        if type == "推荐" {
            self.getRecommendData()
        } else if type == "热门" {
            self.getHotData()
        } else if type == "好友动态" {
            self.dynamicRequest()
        } else if type == "咨询" {
            self.getInformationData()
        } else {
            self.getProjectData(type: circleType)
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
        if self.dataArray.count > 0 {
            return updateRowHeight(indexPath: indexPath)
        }
        return 0
    }
    
    func updateRowHeight(indexPath: IndexPath) -> CGFloat {
        let model = self.dataArray[indexPath.row]
        var height:CGFloat = 105
        let textHeight = String.getTextHeigh(textStr: (model.comment), font: UIFont.systemFont(ofSize: 15), width: DEVICE_WIDTH - 75)
        print(textHeight)
        height = height + textHeight
        //4.配图视图
        var pictureHeight: CGFloat = 0.0
        var picURLs: [String] = []
        let arr = model.image.components(separatedBy: ",")
        for url in arr {
            if url.length > 0 {
                picURLs.append(Image_Path+url)
            }
        }
        switch picURLs.count {
        case 0:
            pictureHeight = 0
        case 1:
            pictureHeight = 150
        default:
            let row = (picURLs.count - 1) / 3 + 1
            pictureHeight = CGFloat(row) * PicWidth
            pictureHeight = CGFloat(row - 1) * PictureInMargin + pictureHeight
        }
        height = height + pictureHeight
        print("======================" + "\(height)")
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DynamicCell", for: indexPath) as! DynamicCell
        if self.dataArray.count > 0 {
            let model = self.dataArray[indexPath.row]
            cell.model = model
            cell.concernBtn.addTarget(self, action: #selector(concernAction(_:)), for: .touchUpInside)
            cell.collectBtn.addTarget(self, action: #selector(btnsAction(_:)), for: .touchUpInside)
            cell.commentBtn.addTarget(self, action: #selector(btnsAction(_:)), for: .touchUpInside)
            cell.transpondBtn.addTarget(self, action: #selector(btnsAction(_:)), for: .touchUpInside)
            cell.likeBtn.addTarget(self, action: #selector(btnsAction(_:)), for: .touchUpInside)
        }
        return cell
    }
    
    @objc func concernAction(_ sender: UIButton) {
        let cell = sender.superview?.superview as! DynamicCell
        let indexPath = self.tableView.indexPath(for: cell)
        self.concernRequest(indexPath: indexPath!)
    }
    
    @objc func btnsAction(_ sender: UIButton) {
        let cell = sender.superview?.superview?.superview as! DynamicCell
        let indexPath = self.tableView.indexPath(for: cell)
        switch sender.tag {
        case 5001:
            self.praseRequest(indexPath: indexPath!)
        case 5002:
            self.transmitRequest(indexPath: indexPath!)
        case 5003:
            let commentVC = UIStoryboard(name: .dynamic).initialize(class: CommentListController.self)
            let model = self.dataArray[(indexPath?.row)!]
            commentVC.model = model
            self.pushAction(commentVC)
        case 5004:
            self.collectRequest(indexPath: indexPath!)
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
    
    // 咨询
    func getInformationData() {
        self.showBlurHUD()
        let informationRequest = InformationListRequest()
        WebAPI.send(informationRequest) { (isSuccess, result, error) in
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
        self.showBlurHUD()
        let req = AttentionReq(id: userID, otherId: "\(model.id)")
        WebAPI.send(req) { (isSuccess, result, error) in
            self.hideBlurHUD()
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
        var model = self.dataArray[indexPath.row]
        let praiseRequest = PraiseRequest(ID: model.id, userLoginId: userID)
        WebAPI.send(praiseRequest) { (isSuccess, result, error) in
            self.hideBlurHUD()
            if isSuccess {
                self.showBlurHUD(result: .success, title: "点赞成功") { [unowned self] in
                    model.praselen = "\(Int(model.praselen)! + 1)"
                    self.dataArray.remove(at: indexPath.row)
                    self.dataArray.insert(model, at: indexPath.row)
                    self.tableView.reloadData()
                }
            } else {
                self.showBlurHUD(result: .failure, title: error?.errorMsg)
            }
        }
    }
    
    // 转发
    func transmitRequest(indexPath: IndexPath) {
        self.showBlurHUD()
        var model = self.dataArray[indexPath.row]
        let transmitRequest = TransmitRequest(ID: model.id, loginId: userID)
        WebAPI.send(transmitRequest) { (isSuccess, result, error) in
            self.hideBlurHUD()
            if isSuccess {
                self.showBlurHUD(result: .success, title: "转发成功") { [unowned self] in
                    model.forwardlen = "\(Int(model.forwardlen)! + 1)"
                    self.dataArray.remove(at: indexPath.row)
                    self.dataArray.insert(model, at: indexPath.row)
                    self.tableView.reloadData()
                }
            } else {
                self.showBlurHUD(result: .failure, title: error?.errorMsg)
            }
        }
    }
    
    // 收藏
    func collectRequest(indexPath: IndexPath) {
        self.showBlurHUD()
        var model = self.dataArray[indexPath.row]
        let collectRequest = CollectRequest(ID: userID, dynamicsId: model.id)
        WebAPI.send(collectRequest) { (isSuccess, result, error) in
            self.hideBlurHUD()
            if isSuccess {
                self.showBlurHUD(result: .success, title: "收藏成功") { [unowned self] in
                    model.collectionlen = "\(Int(model.collectionlen)! + 1)"
                    self.dataArray.remove(at: indexPath.row)
                    self.dataArray.insert(model, at: indexPath.row)
                    self.tableView.reloadData()
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
