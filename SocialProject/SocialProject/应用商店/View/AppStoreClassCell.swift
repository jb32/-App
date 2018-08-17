//
//  AppStoreClassCell.swift
//  SocialProject
//
//  Created by 薛 靖博 on 2018/8/15.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit

class AppStoreClassCell: UICollectionViewCell {
    @IBOutlet weak var titleLB: UILabel!
    
    override var isSelected: Bool {
        get {
            return super.isSelected
        }
        set {
            super.isSelected = newValue
            select = newValue
        }
    }
    
    var select: Bool {
        get {
            return isSelected
        }
        set {
            titleLB.layer.cornerRadius = 5
            titleLB.clipsToBounds = true
            
            if select {
                titleLB.backgroundColor = UIColor.white
            } else {
                titleLB.backgroundColor = UIColor.clear
            }
        }
    }
}
