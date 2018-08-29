//
//  CollectionController.swift
//  SocialProject
//
//  Created by Mac on 2018/7/18.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit

class CollectionController: ZYYBaseViewController {
    @IBOutlet weak var tableView: UITableView!
    var dataArray: [DynamicModel] = []
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: DEVICE_WIDTH, height: 1))
        
        self.getCollectionData()
        tableView.addMJHeader { [unowned self] in
            self.page = 1
            self.getCollectionData()
        }
        tableView.addMJFooter { [unowned self] in
            self.page = 1 + self.page
            self.getCollectionData()
        }
    
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

extension CollectionController: UITableViewDelegate, UITableViewDataSource {
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
            cell.transpondNameBtn.addTarget(self, action: #selector(toOthersAction(_:)), for: .touchUpInside)
            cell.commentBtn.addTarget(self, action: #selector(btnsAction(_:)), for: .touchUpInside)
            cell.transpondBtn.addTarget(self, action: #selector(btnsAction(_:)), for: .touchUpInside)
            cell.likeBtn.addTarget(self, action: #selector(btnsAction(_:)), for: .touchUpInside)
        }
        return cell
    }
    
    @objc func toOthersAction(_ sender: UIButton) {
        let cell = sender.superview?.superview as! DynamicCell
        let indexPath = self.tableView.indexPath(for: cell)
        let userVC = UIStoryboard(name: .connection).initialize(class: InformationController.self)
        let model = self.dataArray[(indexPath?.row)!]
        userVC.ID = model.fromUserId
        userVC.name = model.fromName
        self.navigationController?.pushViewController(userVC, animated: true)
    }
    
    @objc func btnsAction(_ sender: UIButton) {
        let cell = sender.superview?.superview?.superview as! DynamicCell
        let indexPath = self.tableView.indexPath(for: cell)
        switch sender.tag {
        case 5001:
            if sender.isSelected {
                self.cancelRequest(indexPath: indexPath!, type: 2)
            } else {
                self.praseRequest(indexPath: indexPath!, type: 2)
            }
        case 5002:
            self.transmitRequest(indexPath: indexPath!)
        case 5003:
            let commentVC = UIStoryboard(name: .dynamic).initialize(class: CommentListController.self)
            let model = self.dataArray[(indexPath?.row)!]
            commentVC.model = model
            self.navigationController?.pushViewController(commentVC, animated: true)
        case 5004:
            if sender.isSelected {
                self.cancelRequest(indexPath: indexPath!, type: 0)
            } else {
                self.praseRequest(indexPath: indexPath!, type: 0)
            }
        default:
            break
        }
    }
}

extension CollectionController {
    func getCollectionData() {
        self.showBlurHUD()
        let collectionRequest = CollectionListRequest(ID: userID, page: self.page)
        WebAPI.send(collectionRequest) { (isSuccess, result, error) in
            self.hideBlurHUD()
            if isSuccess {
                if self.page > 1 {
                    self.dataArray += (result?.objectModels)!
                } else {
                    self.dataArray.removeAll()
                    self.dataArray = (result?.objectModels)!
                }
                self.tableView.reloadData()
                self.tableView.stopReload()
            } else {
                self.showBlurHUD(result: .failure, title: error?.errorMsg)
            }
        }
    }
    
    // 点赞/收藏
    func praseRequest(indexPath: IndexPath, type: Int) {
        self.showBlurHUD()
        var model = self.dataArray[indexPath.row]
        let praiseRequest = CollectRequest(ID: userID, dynamicsId: model.id, type: type)
        WebAPI.send(praiseRequest) { (isSuccess, result, error) in
            self.hideBlurHUD()
            if isSuccess {
                self.showBlurHUD(result: .success, title: error?.errorMsg) { [unowned self] in
                    if type == 0 {
                        model.collectionlen = "\(Int(model.collectionlen)! + 1)"
                        model.collectionState = true
                    } else {
                        model.praselen = "\(Int(model.praselen)! + 1)"
                        model.praseState = true
                    }
                    self.dataArray.remove(at: indexPath.row)
                    self.dataArray.insert(model, at: indexPath.row)
                    self.tableView.reloadData()
                }
            } else {
                self.showBlurHUD(result: .failure, title: error?.errorMsg)
            }
        }
    }
    
    // 取消点赞/收藏
    func cancelRequest(indexPath: IndexPath, type: Int) {
        self.showBlurHUD()
        var model = self.dataArray[indexPath.row]
        let cancelRequest = CancelCollectRequest(ID: userID, dynamicsId: model.id, type: type)
        WebAPI.send(cancelRequest) { (isSuccess, result, error) in
            self.hideBlurHUD()
            if isSuccess {
                self.showBlurHUD(result: .success, title: error?.errorMsg) { [unowned self] in
                    if type == 0 {
                        model.collectionlen = "\(Int(model.collectionlen)! - 1)"
                        model.collectionState = false
                    } else {
                        model.praselen = "\(Int(model.praselen)! - 1)"
                        model.praseState = false
                    }
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
        var sourceId = model.id
        if model.sourceId.length > 0 {
            sourceId = model.sourceId
        }
        let transmitRequest = TransmitRequest(ID: model.id, loginId: userID, sourceId: sourceId)
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
}
