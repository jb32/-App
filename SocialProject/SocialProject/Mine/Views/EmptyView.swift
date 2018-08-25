//
//  EmptyView.swift
//  SocialProject
//
//  Created by Mac on 2018/8/24.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit

class EmptyView: UIView {

    @IBOutlet weak var addBtn: UIButton!
    class func getTemplateView() ->EmptyView {
        let templateView = Bundle.main.loadNibNamed("EmptyView", owner: self, options: nil)?[0] as! EmptyView
        return templateView
        
    }

}
