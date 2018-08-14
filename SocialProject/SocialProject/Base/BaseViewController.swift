//
//  ZYYBaseViewController.swift
//  SellerTyreProject
//
//  Created by ZYY on 2017/8/9.
//  Copyright © 2017年 ZYY. All rights reserved.
//

import UIKit

class ZYYBaseViewController: UIViewController {
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.setStatusBarBackgroundColor(color: UIColor.white)
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.setStatusBarBackgroundColor(color: UIColor.themOneColor)
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setLeftItem(img: UIImage(named: "back")!)
//        NotificationCenter.default.addObserver(self, selector: #selector(loginAction), name: NSNotification.Name(rawValue: "LOGINNotification"), object: nil)
    }

    // 设置左边按钮
    func setLeftItem(img: UIImage) {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: img, style: UIBarButtonItemStyle.plain, target: self, action: #selector(leftAction))
    }
    
    func setLeftItem(title: String) {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: title, style: UIBarButtonItemStyle.plain, target: self, action: #selector(leftAction))
    }
    
    @objc func leftAction() {
        if (self.presentingViewController != nil) {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // 设置右边按钮
    func setRightItem(title: String) {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: title, style: UIBarButtonItemStyle.plain, target: self, action: #selector(rightAction))
    }
    
    func setRightItem(img: UIImage) {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: img, style: UIBarButtonItemStyle.plain, target: self, action: #selector(rightAction))
    }
    
    @objc func rightAction() {
        
    }

}
