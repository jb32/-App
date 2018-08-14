//
//  ZYYCommonTF.swift
//  SellerTyreProject
//
//  Created by ZYY on 2017/8/9.
//  Copyright © 2017年 ZYY. All rights reserved.
//

import UIKit

class ZYYCommonTF: UITextField {

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        self.layer.cornerRadius = 8.0
        let inset = CGRect(x: bounds.origin.x + 10 + 15 + 5, y: bounds.origin.y, width: bounds.size.width - 20 - 15 - 5, height: bounds.size.height)
        return inset
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let inset = CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.size.width - 20, height: bounds.size.height)
        return inset
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let inset = CGRect(x: bounds.origin.x + 10 + 15 + 5, y: bounds.origin.y, width: bounds.size.width - 20 - 15 - 5, height: bounds.size.height)
        return inset
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let inset = CGRect(x: bounds.origin.x + 10, y: bounds.origin.y + (bounds.size.height - 15) / 2, width: 15, height: 15)
        return inset
    }
}
