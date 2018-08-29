//
//  DynamicController.swift
//  SocialProject
//
//  Created by Mac on 2018/7/16.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit
import DNSPageView

class DynamicController: UIViewController {
    
    var titleView: ZYYCommonTF?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        automaticallyAdjustsScrollViewInsets = false
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "camera"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(rightAction))
        
        let titleView = ZYYCommonTF(frame: CGRect(x: 0, y: 0, width: DEVICE_WIDTH - 100, height: 30))
        titleView.delegate = self
        titleView.backgroundColor = UIColor.backgroundColor
        titleView.returnKeyType = .search
        titleView.leftViewMode = UITextFieldViewMode.unlessEditing
        titleView.leftView = UIImageView(image: UIImage(named: "search"))
        titleView.placeholder = "搜索"
        titleView.textAlignment = .center
        titleView.font = UIFont.systemFont(ofSize: 14.0)
        self.titleView = titleView
        self.navigationItem.titleView = titleView
        
        // 创建DNSPageStyle，设置样式
        let style = DNSPageStyle()
        style.isTitleScrollEnable = false
        style.titleSelectedColor = .themOneColor
        style.titleColor = .themTwoColor
        style.titleViewBackgroundColor = .backgroundColor
        
        // 设置标题内容
        let titles = ["推荐", "热门", "项目", "资讯", "好友动态"]
        var childViewControllers: [UIViewController] = []
        let recommendController = UIStoryboard(name: .dynamic).initialize(class: DynamicContentController.self)
        recommendController.type = "推荐"
        recommendController.view.backgroundColor = UIColor.backgroundColor
        recommendController.pushAction = { [unowned self] vc in
            self.navigationController?.pushViewController(vc, animated: true)
        }
        childViewControllers.append(recommendController)
        let hotController = UIStoryboard(name: .dynamic).initialize(class: DynamicContentController.self)
        hotController.type = "热门"
        hotController.view.backgroundColor = UIColor.backgroundColor
        hotController.pushAction = { [unowned self] vc in
            self.navigationController?.pushViewController(vc, animated: true)
        }
        childViewControllers.append(hotController)
        let projectController = UIStoryboard(name: .dynamic).initialize(class: DynamicContentController.self)
        projectController.type = "项目"
        projectController.view.backgroundColor = UIColor.backgroundColor
        projectController.pushAction = { [unowned self] vc in
            self.navigationController?.pushViewController(vc, animated: true)
        }
        childViewControllers.append(projectController)
        let brandVC = UIStoryboard(name: .discovery).initialize(class: BrandController.self)
        brandVC.type = .consult
        brandVC.pushAction = { [unowned self] vc in
            self.navigationController?.pushViewController(vc, animated: true)
        }
        childViewControllers.append(brandVC)
        let dynamicController = UIStoryboard(name: .dynamic).initialize(class: DynamicContentController.self)
        dynamicController.type = "好友动态"
        dynamicController.view.backgroundColor = UIColor.backgroundColor
        dynamicController.pushAction = { [unowned self] vc in
            self.navigationController?.pushViewController(vc, animated: true)
        }
        childViewControllers.append(dynamicController)
        
        // 创建对应的DNSPageView，并设置它的frame
        let pageView = DNSPageView(frame: CGRect(x: 0, y: 0, width: DEVICE_WIDTH, height: DEVICE_HEIGHT - 44), style: style, titles: titles, childViewControllers: childViewControllers)
        view.addSubview(pageView)
    }
    
    @objc func rightAction() {
        let publishVC = PublishController()
        self.navigationController?.pushViewController(publishVC, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DynamicController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let dynamicController = UIStoryboard(name: .dynamic).initialize(class: SearchDynamicController.self)
        self.navigationController?.pushViewController(dynamicController, animated: true)
    }
}
