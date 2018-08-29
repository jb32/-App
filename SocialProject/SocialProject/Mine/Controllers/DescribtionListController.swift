//
//  DescribtionListController.swift
//  SocialProject
//
//  Created by Mac on 2018/8/27.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit

class DescribtionListController: ZYYBaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var dataArray: [DescribtionModel] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllDescibtionData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: DEVICE_WIDTH, height: 1))
        
        setRightItem(title: "添加")
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
    
    override func rightAction() {
        let describtionVC = DescribtionPublishController()
        self.navigationController?.pushViewController(describtionVC, animated: true)
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

extension DescribtionListController: UITableViewDelegate, UITableViewDataSource {
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
        var height:CGFloat = 130
        let textHeight = String.getTextHeigh(textStr: (model.content), font: UIFont.systemFont(ofSize: 15), width: DEVICE_WIDTH - 30)
        height = height + textHeight
        //4.配图视图
        var pictureHeight: CGFloat = 0.0
        var picURLs: [String] = []
        let arr = model.images.components(separatedBy: ",")
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
            let picWidth = (DEVICE_WIDTH - 30 - 2 * PictureInMargin) / 3
            pictureHeight = CGFloat(row) * picWidth
            pictureHeight = CGFloat(row - 1) * PictureInMargin + pictureHeight
        }
        height = height + pictureHeight
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DescribtionListCell", for: indexPath) as! DescribtionListCell
        if self.dataArray.count > 0 {
            let model = self.dataArray[indexPath.row]
            cell.model = model
            cell.settingBtn.addTarget(self, action: #selector(btnsAction(_:)), for: .touchUpInside)
            cell.editBtn.addTarget(self, action: #selector(btnsAction(_:)), for: .touchUpInside)
            cell.deleteBtn.addTarget(self, action: #selector(btnsAction(_:)), for: .touchUpInside)
        }
        return cell
    }
    
    @objc func btnsAction(_ sender: UIButton) {
        let cell = sender.superview?.superview?.superview as! DescribtionListCell
        let indexPath = self.tableView.indexPath(for: cell)
        let model = self.dataArray[(indexPath?.row)!]
        switch sender.tag {
        case 666:
            // 设置主简介
            setMainDescobtion(model: model)
        case 667:
            // 编辑
            let editVC = DescribtionPublishController()
            editVC.isEdit = true
            editVC.model = model
            self.navigationController?.pushViewController(editVC, animated: true)
        default:
            // 删除
            deleteDescribtion(model: model)
        }
    }
}

extension DescribtionListController {
    func getAllDescibtionData() {
        self.showBlurHUD()
        let describtionRequest = DescribtionRequest(ID: userID)
        WebAPI.send(describtionRequest) { (isSuccess, result, error) in
            self.hideBlurHUD()
            if isSuccess {
                self.dataArray = (result?.objectModels)!
                self.tableView.reloadData()
            } else {
                self.showBlurHUD(result: .failure, title: error?.errorMsg)
            }
        }
    }
    
    func setMainDescobtion(model: DescribtionModel) {
        self.showBlurHUD()
        let setMainReq = SetMainDescribtionRequest(ID: "\(model.ID)")
        WebAPI.send(setMainReq) { (isSuccess, result, error) in
            self.hideBlurHUD()
            if isSuccess {
                self.showBlurHUD(result: .success, title: "设置成功") { [unowned self] in
                    self.getAllDescibtionData()
                }
            } else {
                self.showBlurHUD(result: .failure, title: error?.errorMsg)
            }
        }
    }
    
    func deleteDescribtion(model: DescribtionModel) {
        self.showBlurHUD()
        let deleteReq = DeleteDescribtionRequest(ID: "\(model.ID)")
        WebAPI.send(deleteReq) { (isSuccess, result, error) in
            self.hideBlurHUD()
            if isSuccess {
                self.showBlurHUD(result: .success, title: "删除成功") { [unowned self] in
                    self.getAllDescibtionData()
                }
            } else {
                self.showBlurHUD(result: .failure, title: error?.errorMsg)
            }
        }
    }
}
