//
//  AppStoreHomeController.swift
//  SocialProject
//
//  Created by 薛 靖博 on 2018/8/14.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit
import SwiftyJSON
import SafariServices

class AppStoreHomeController: ZYYBaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var cycArr: [JSON]?
    var ads: [JSON]?
    var apps: [JSON]?
    var classId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        netAd()
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

extension AppStoreHomeController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return cycArr != nil || ads != nil || apps != nil ? 3 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 0
        case 1:
            return ads?.count ?? 0
        case 2:
            return apps?.count ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 1:
            let cell = collectionView.dequeueReusableCell(type: HorizontalCollectionCell.self, for: indexPath)
            cell.dataArr = ads
            cell.toSelect = { i in
                let safari = SFSafariViewController(url: URL(string: "https://www.baidu.com")!)
                self.present(safari, animated: true, completion: nil)
            }
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(type: AppCollectionCell.self, for: indexPath)
            if let apps = apps {
                let app = apps[indexPath.item]
                
                if let url = URL(string: Image_Path + (app[AppStore.fileUrl].string ?? "")) {
                    cell.imgView.af_setImage(withURL: url)
                }
                cell.titleLB.text = app[AppStore.title].string
                cell.subTitleLB?.text = (app[AppStore.keywords].string ?? "0") + "万下载/" + (app[AppStore.appType].string ?? "0") + "M"
                cell.detailLB?.text = app[AppStore.content].string
            }
            
            
            return cell
        default:
            let cell = UICollectionViewCell(frame: CGRect.zero)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 1:
            return CGSize(width: DEVICE_WIDTH, height: 140)
        case 2:
            return CGSize(width: DEVICE_WIDTH, height: 90)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 0:
            return cycArr != nil ? CGSize(width: DEVICE_WIDTH, height: 150) : .zero
        default:
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableHeader(type: CycleCollectionheader.self, for: indexPath)
        
        if let cycArr = cycArr {
            let imagePaths = cycArr.map({ Image_Path + ($0[AppStore.advUrl].string ?? "") })
            header.cycleView.imagePaths = imagePaths
            header.toSelect = { i in
                let safari = SFSafariViewController(url: URL(string: "https://www.baidu.com")!)
                self.present(safari, animated: true, completion: nil)
            }
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let safari = SFSafariViewController(url: URL(string: "https://www.baidu.com")!)
        present(safari, animated: true, completion: nil)
    }
}
//MARK: - net
extension AppStoreHomeController {
    
    func netApps(classId: String) -> Void {
        let req = AppListReq(classId: classId, search: nil)
        WebAPI.send(req) { (isSuccess, result, error) in
            if isSuccess, let result = result, let arr = result.array {
                self.apps = arr
                self.collectionView.reloadData()
            } else {
                
            }
            self.netFashion()
        }
    }
    
    func netAd() -> Void {
        let req = AppAdReq()
        
        WebAPI.send(req) { (isSuccess, result, error) in
            if isSuccess, let result = result, let arr = result.array {
                self.cycArr = arr
                self.collectionView.reloadData()
            } else {
                
            }
            
            if let classId = self.classId {
                self.netApps(classId: classId)
            }
        }
    }
    
    func netFashion() -> Void {
        let req = FashionReq()
        
        WebAPI.send(req) { (isSuccess, result, error) in
            if isSuccess, let result = result, let arr = result.array {
                self.ads = arr
                self.collectionView.reloadData()
            } else {
                
            }
        }
    }
}




