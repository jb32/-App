//
//  UIButtton+Utils.swift
//  SocialProject
//
//  Created by 薛 靖博 on 2018/8/15.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import Foundation

extension UIButton {
    var toSelect: (() -> Void)? {
        get {
            return objc_getAssociatedObject(self, &Target.key) as? (() -> Void)
        }
        set {
            objc_setAssociatedObject(self, &Target.key, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    func add(selecte: (() -> Void)?) -> Void {
        toSelect = selecte
        addTarget(self, action: #selector(doSelect(_:)), for: .touchUpInside)
    }
    
    @objc func doSelect(_ sender: UIButton) {
        toSelect?()
    }
}

extension UIButton {
    fileprivate struct Target {
        static var key: UInt8 = 0
    }
}












