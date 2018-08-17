//
//  AppStorePageController.swift
//  SocialProject
//
//  Created by 薛 靖博 on 2018/8/15.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit

class AppStorePageController: JBPageController {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func set(titles: [String]) -> Void {
        
        guard titles.count > 0 else {
            return
        }
        let appStore = UIStoryboard(name: .appStore)
        
        var vcs = [UIViewController]()
        
        for (i, classId) in titles.enumerated() {
            if i == 0 {
                let home = appStore.initialize(class: AppStoreHomeController.self)
                home.classId = classId
                vcs.append(home)
            } else {
                let vc = appStore.initialize(class: AppStoreOtherController.self)
                vc.classId = classId
                vcs.append(vc)
            }
        }
        set(dataArr: vcs, defalut: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
