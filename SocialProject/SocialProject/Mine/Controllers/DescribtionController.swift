//
//  DescribtionController.swift
//  SocialProject
//
//  Created by Mac on 2018/7/18.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit

class DescribtionController: ZYYBaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let emptyView = EmptyView.getTemplateView()
    var dataArray: [DescribtionModel] = []
    
    var pushAction:(_ vc: UIViewController) -> Void = {_ in }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMainDescribtionData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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

    @IBAction func describtionListAction(_ sender: UIButton) {
        let listVC = UIStoryboard(name: .mine).initialize(class: DescribtionListController.self)
        self.pushAction(listVC)
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

extension DescribtionController: UITableViewDelegate, UITableViewDataSource {
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
        var height:CGFloat = 90
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "DescibtionCell", for: indexPath) as! DescibtionCell
        if self.dataArray.count > 0 {
            let model = self.dataArray[indexPath.row]
            cell.model = model
        }
        return cell
    }
}

extension DescribtionController {
    func getMainDescribtionData() {
        self.showBlurHUD()
        let describtionRequest = MainDescribtionRequest(ID: userID)
        WebAPI.send(describtionRequest) { (isSuccess: Bool, model: DescribtionModel?, error: NetworkError?) in
            self.hideBlurHUD()
            if isSuccess {
                if model?.ID == 0 {
                    self.addEmptyView()
                } else {
                    self.emptyView.removeFromSuperview()
                    self.dataArray.removeAll()
                    self.dataArray.append(model!)
                    self.tableView.reloadData()
                }
            } else {
                self.showBlurHUD(result: .failure, title: error?.errorMsg)
            }
        }
    }
}

extension DescribtionController {
    func addEmptyView() {
        emptyView.frame = self.view.bounds
        emptyView.addBtn.addTarget(self, action: #selector(addDescribtion), for: .touchUpInside)
        self.view.addSubview(emptyView)
    }
    
    @objc func addDescribtion() {
        let describtionVC = DescribtionPublishController()
        self.pushAction(describtionVC)
    }
}
