//
//  ProjectController.swift
//  SocialProject
//
//  Created by Mac on 2018/7/16.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit
import DNSPageView

class ProjectController: ZYYBaseViewController {
    
    @IBOutlet weak var titleView: DNSPageTitleView!
    @IBOutlet weak var contentView: DNSPageContentView!
    
    var titles: [String] = []
    var startIndex = 0
    var projectData: [ParentModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 创建DNSPageStyle，设置样式
        let style = DNSPageStyle()
        style.isTitleScrollEnable = false
        style.titleSelectedColor = .themOneColor
        style.titleColor = .themTwoColor
        style.titleViewBackgroundColor = .backgroundColor
        
        // 对titleView进行设置
        titleView.titles = titles
        titleView.style = style
        titleView.currentIndex = startIndex
        
        // 最后要调用setupUI方法
        titleView.setupUI()
        
        // 创建每一页对应的controller
        let childViewControllers: [BrandController] = titles.map { str -> BrandController in
            let controller = UIStoryboard(name: .discovery).initialize(class: BrandController.self)
            controller.view.backgroundColor = UIColor.backgroundColor
            for model in self.projectData {
                if model.typeName == str {
                    controller.getProjectData(ID: model.id)
                }
            }
            controller.pushAction = { [unowned self] vc in
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return controller
        }
        
        // 对contentView进行设置
        contentView.childViewControllers = childViewControllers
        contentView.startIndex = startIndex
        contentView.style = style
        
        // 最后要调用setupUI方法
        contentView.setupUI()
        
        // 让titleView和contentView进行联系起来
        titleView.delegate = contentView
        contentView.delegate = titleView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
