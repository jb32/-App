//
//  ZYYTemplateView.swift
//  SellerTyreProject
//
//  Created by ZYY on 2017/8/16.
//  Copyright © 2017年 ZYY. All rights reserved.
//

import UIKit

class ZYYTemplateView: UIView {

    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    class func getTemplateView() ->ZYYTemplateView {
        let templateView = Bundle.main.loadNibNamed("TemplateView", owner: self, options: nil)?[0] as! ZYYTemplateView
        templateView.nameTF.layer.borderWidth = 0.5
        templateView.nameTF.layer.borderColor = UIColor.fontColor.cgColor
        return templateView
        
    }
}
