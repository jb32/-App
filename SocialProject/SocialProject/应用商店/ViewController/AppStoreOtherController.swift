//
//  AppStoreOtherController.swift
//  SocialProject
//
//  Created by 薛 靖博 on 2018/8/15.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit
import SwiftyJSON
import SafariServices

class AppStoreOtherController: ZYYBaseViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataArr: [JSON]?
    var classId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let classId = classId {
            netApps(classId: classId)
        }
        // Do any additional setup after loading the view.
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

extension AppStoreOtherController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(type: AppCollectionCell.self, for: indexPath)
        
        if let dataArr = dataArr {
            let app = dataArr[indexPath.item]
            
            if let url = URL(string: Image_Path + (app[AppStore.fileUrl].string ?? "")) {
                cell.imgView.af_setImage(withURL: url)
            }
            cell.titleLB.text = app[AppStore.title].string
            cell.subTitleLB?.text = (app[AppStore.keywords].string ?? "0") + "万下载/" + (app[AppStore.appType].string ?? "0") + "M"
            cell.detailLB?.text = app[AppStore.content].string
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: DEVICE_WIDTH, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let safari = SFSafariViewController(url: URL(string: "https://www.baidu.com")!)
        present(safari, animated: true, completion: nil)
    }
}

//MARK: - net
extension AppStoreOtherController {
    
    func netApps(classId: String) -> Void {
        let req = AppListReq(classId: classId, search: nil)
        WebAPI.send(req) { (isSuccess, result, error) in
            if isSuccess, let result = result, let arr = result.array {
                self.dataArr = arr
                self.collectionView.reloadData()
            } else {
                
            }
        }
    }
}













