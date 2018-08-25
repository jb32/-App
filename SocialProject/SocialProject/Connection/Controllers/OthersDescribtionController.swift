//
//  OthersDescribtionController.swift
//  SocialProject
//
//  Created by Mac on 2018/8/24.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit

class OthersDescribtionController: UIViewController {
    
    var ID: String = ""

    @IBOutlet weak var tableView: UITableView!
    var dataArray: [DescribtionModel] = []
    
    var pushAction:(_ vc: UIViewController) -> Void = {_ in }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        netRelation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: DEVICE_WIDTH, height: 1))
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

extension OthersDescribtionController: UITableViewDelegate, UITableViewDataSource {
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
        var height:CGFloat = 75
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
            pictureHeight = CGFloat(row) * PicWidth
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

extension OthersDescribtionController {
    func netRelation() {
        self.dataArray.removeAll()
        self.showBlurHUD()
        let req = RelationReq(user: userID, otherId: ID)
        WebAPI.send(req) { (isSuccess, result, error) in
            if isSuccess, let result = result {
                let model = DescribtionModel.parse(result["profile"])
                self.dataArray.append(model!)
                self.tableView.reloadData()
            } else {
                self.showBlurHUD(result: .failure, title: error?.errorMsg)
            }
            self.hideBlurHUD()
        }
    }
}
