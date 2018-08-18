//
//  CycleCollectionheader.swift
//  SocialProject
//
//  Created by 薛 靖博 on 2018/8/15.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit
import LLCycleScrollView

class CycleCollectionheader: UICollectionReusableView {
    @IBOutlet weak var cycleView: LLCycleScrollView!
    var toSelect: ((Int) -> Void)? {
        didSet {
            cycleView.delegate = self
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension CycleCollectionheader: LLCycleScrollViewDelegate {
    func cycleScrollView(_ cycleScrollView: LLCycleScrollView, didSelectItemIndex index: NSInteger) {
        toSelect?(index)
    }
}
