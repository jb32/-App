//
//  ConnectionController.swift
//  SocialProject
//
//  Created by Mac on 2018/7/16.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit
import DNSPageView

class ConnectionController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        automaticallyAdjustsScrollViewInsets = false
        self.getCircleData()
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

extension ConnectionController {
    func getCircleData() {
        self.showBlurHUD()
        let circleRequest = CircleTypeRequest()
        WebAPI.send(circleRequest) { (isSuccess, result, error) in
            self.hideBlurHUD()
            if isSuccess {
                var titles: [String] = []
                var childViewControllers: [ConnectionContentController] = []
                for model in (result?.objectModels)! {
                    titles.append(model.type)
                    let controller = UIStoryboard(name: .connection).initialize(class: ConnectionContentController.self)
                    controller.type = "\(model.id)"
                    controller.view.backgroundColor = UIColor.backgroundColor
                    controller.pushAction = { [unowned self] vc in
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    childViewControllers.append(controller)
                }
                
                // 创建DNSPageStyle，设置样式
                let style = DNSPageStyle()
                style.titleSelectedColor = .themOneColor
                style.titleColor = .themTwoColor
                style.titleViewBackgroundColor = .backgroundColor
                
                // 创建对应的DNSPageView，并设置它的frame
                let pageView = DNSPageView(frame: CGRect(x: 0, y: 0, width: DEVICE_WIDTH, height: DEVICE_HEIGHT), style: style, titles: titles, childViewControllers: childViewControllers)
                self.view.addSubview(pageView)
            } else {
                self.showBlurHUD(result: .failure, title: error?.errorMsg)
            }
        }
    }
}
