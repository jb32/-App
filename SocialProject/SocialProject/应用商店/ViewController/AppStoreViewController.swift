//
//  AppStoreHomeController.swift
//  SocialProject
//
//  Created by 薛 靖博 on 2018/8/14.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit
import SwiftyJSON

class AppStoreHomeController: ZYYBaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var dataArr: (JSON, [JSON], [JSON])?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        return 3//dataArr == nil ? 0 : 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        guard let dataArr = dataArr else { return 0 }
        switch section {
        case 0:
            return 0
        case 1:
            return 1//dataArr.1.count
        case 2:
            return 3//dataArr.2.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 1:
            let cell = collectionView.dequeueReusableCell(type: HorizontalCollectionCell.self, for: indexPath)
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(type: AppCollectionCell.self, for: indexPath)
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
            return CGSize(width: DEVICE_WIDTH, height: 115)
        default:
            return CGSize.zero
        }
    }
}




