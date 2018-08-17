//
//  AppStoreNavController.swift
//  SocialProject
//
//  Created by 薛 靖博 on 2018/8/15.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit
import SwiftyJSON

class AppStoreNavController: ZYYBaseViewController {
    
    @IBOutlet weak var menuView: AppMenuView!
    
    var dataArr: [JSON]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        netClass()
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

extension AppStoreNavController {
    func netClass() -> Void {
        let req = AppClassReq()
        WebAPI.send(req) { (isSuccess, result, error) in
            if isSuccess, let result = result, let arr = result.array {
                self.dataArr = arr
                self.menuView.reloadData()
                
                if let vc = self.childViewControllers.first as? AppStorePageController {
                    vc.set(titles: arr.map({ $0[AppStore.classId].string ?? "" }))
                    vc.sync(self.menuView)
                }
            } else {
                
            }
        }
    }
}

extension AppStoreNavController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(type: AppStoreClassCell.self, for: indexPath)
        
        if let dataArr = dataArr {
            let data = dataArr[indexPath.item]
            cell.titleLB.text = data[AppStore.classType].string
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        
        menuView.toSelected?(indexPath.item)
    }
}












