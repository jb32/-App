//
//  ChatPageController.swift
//  SocialProject
//
//  Created by 薛 靖博 on 2018/8/10.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit

class ChatPageController: JBPageController {
    
    @IBOutlet weak var menuView: SegmentedControl!
    var index: Int = 0
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        let sb = UIStoryboard(name: "Im", bundle: nil)
        
        let vc0 = sb.instantiateViewController(withIdentifier: "\(ChatListController.self)")
        let vc1 = sb.instantiateViewController(withIdentifier: "\(ContactListViewController.self)")
        set(dataArr: [vc0, vc1], defalut: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let menuView = menuView {
            sync(menuView)
            set(index: index)
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let vc = segue.destination as? FriendListController {
            vc.atype = .black
        }
    }

}






