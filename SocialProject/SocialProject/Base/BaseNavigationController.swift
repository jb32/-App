//
//  ZYYBaseNavigationController.swift
//  TyreProject
//
//  Created by 黄小超 on 2017/7/25.
//  Copyright © 2017年 ZYY. All rights reserved.
//

import UIKit

class ZYYBaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 每一次push都会执行这个方法，push之前设置viewController的hidesBottomBarWhenPushed 
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.hidesBottomBarWhenPushed = true
        super.pushViewController(viewController, animated: true)
        viewController.hidesBottomBarWhenPushed = false
    }
    override func popViewController(animated: Bool) -> UIViewController? {
        // 以下函数是对返回上一级界面之前的设置操作
        // 每一次对viewController进行push的时候，会把viewController放入一个栈中
        // 每一次对viewController进行pop的时候，会把viewController从栈中移除
        if self.childViewControllers.count == 2 {
            // 如果viewController栈中存在的ViewController的个数为两个，再返回上一级界面就是根界面了
            // 那么要对tabbar进行显示
            let controller:UIViewController = self.childViewControllers[0]
            controller.hidesBottomBarWhenPushed = false
        } else {
            // 如果viewController栈中存在的ViewController的个数超过两个，对要返回到的上一级的界面设置hidesBottomBarWhenPushed = true
            // 把tabbar进行隐藏 
            let count = self.childViewControllers.count - 2
            let controller = self.childViewControllers[count]
            controller.hidesBottomBarWhenPushed = true
        }
        return super.popViewController(animated: true)
    }
    
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        if self.childViewControllers.count == 2 {
            // 如果viewController栈中存在的ViewController的个数为两个，再返回上一级界面就是根界面了
            // 那么要对tabbar进行显示
            viewController.hidesBottomBarWhenPushed = false
        } else {
            // 如果viewController栈中存在的ViewController的个数超过两个，对要返回到的上一级的界面设置hidesBottomBarWhenPushed = true
            // 把tabbar进行隐藏
            viewController.hidesBottomBarWhenPushed = true
        }
        return super.popToViewController(viewController, animated: animated)
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
