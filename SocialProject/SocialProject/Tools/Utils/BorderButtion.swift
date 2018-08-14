//
//  BorderButtion.swift
//  SocialProject
//
//  Created by 薛 靖博 on 2018/8/13.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit

class BorderButtion: UIButton {
    @IBInspectable var borderColor = UIColor.black {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 5 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 1 {
        didSet  {
            layer.borderWidth = borderWidth
        }
    }
}
