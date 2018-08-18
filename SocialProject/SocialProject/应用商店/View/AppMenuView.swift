//
//  AppMenuView.swift
//  SocialProject
//
//  Created by 薛 靖博 on 2018/8/16.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit
import SwiftyJSON

class AppMenuView: UICollectionView, JBPageMenuProtocol {
    
    var toSelected: ((Int) -> Void)?
    var dataArr: [JSON]?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        delegate = self
        dataSource = self
    }
    
    func go(_ index: Int) {
        selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: .right)
    }
}

extension AppMenuView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(type: AppStoreClassCell.self, for: indexPath)
        
        if let dataArr = dataArr {
            let data = dataArr[indexPath.item]
            cell.titleLB.text = data[AppStore.classType].string
//            cell.select = selectArr[indexPath.item]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        toSelected?(indexPath.item)
    }
}
