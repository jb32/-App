//
//  HorizontalCollectionCell.swift
//  SocialProject
//
//  Created by 薛 靖博 on 2018/8/15.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit
import SwiftyJSON

class HorizontalCollectionCell: UICollectionViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    var dataArr: [JSON]?
    var toSelect: ((Int) -> Void)?
}

extension HorizontalCollectionCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let dataArr = dataArr else { return 0 }
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(type: AppCollectionCell.self, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        toSelect?(indexPath.item)
    }
}
