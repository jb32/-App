//
//  AppMenuView.swift
//  SocialProject
//
//  Created by 薛 靖博 on 2018/8/16.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit

class AppMenuView: UICollectionView, JBPageMenuProtocol {
    
    var toSelected: ((Int) -> Void)?
    
    func go(_ index: Int) {
        selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: .right)
    }
}
