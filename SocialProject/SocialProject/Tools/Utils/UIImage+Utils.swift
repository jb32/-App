//
//  UIImage+Utils.swift
//  AtlasEnergy
//
//  Created by 薛 靖博 on 2018/5/24.
//  Copyright © 2018年 JB. All rights reserved.
//

import UIKit

extension UIImage {
    
    static func image(with color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image ?? UIImage()
    }
    
    ///重新绘制图片到指定大小
    func resize(width: CGFloat, height: CGFloat) -> UIImage? {
        let size = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
