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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: DEVICE_WIDTH, height: 1))
        
        self.getCollectionData()
    
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
            cell.concernBtn.isHidden = true
            cell.collectBtn.isSelected = true
            cell.collectBtn.isUserInteractionEnabled = false
            cell.commentBtn.addTarget(self, action: #selector(btnsAction(_:)), for: .touchUpInside)
            cell.transpondBtn.addTarget(self, action: #selector(btnsAction(_:)), for: .touchUpInside)
            cell.likeBtn.addTarget(self, action: #selector(btnsAction(_:)), for: .touchUpInside)
        }
        return cell
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
            self.navigationController?.pushViewController(commentVC, animated: true)
        default:
            break
        }
    }
}

extension CollectionController {
    func getCollectionData() {
        self.showBlurHUD()
        let collectionRequest = CollectionListRequest(ID: userID)
        WebAPI.send(collectionRequest) { (isSuccess, result, error) in
            self.hideBlurHUD()
            if isSuccess {
                self.dataArray = (result?.objectModels)!
                self.tableView.reloadData()
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
}
