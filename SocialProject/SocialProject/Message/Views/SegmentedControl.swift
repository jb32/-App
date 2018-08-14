//
//  SegmentedControl.swift
//  SocialProject
//
//  Created by 薛 靖博 on 2018/8/10.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit

class SegmentedControl: UISegmentedControl, JBPageMenuProtocol {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addTarget(self, action: #selector(doSelect(_:)), for: .valueChanged)
    }
    
    var toSelected: ((Int) -> Void)?
    
    func go(_ index: Int) {
        selectedSegmentIndex = index
    }
    
    @objc func doSelect(_ sender: UIButton) {
        toSelected?(selectedSegmentIndex)
    }
}
