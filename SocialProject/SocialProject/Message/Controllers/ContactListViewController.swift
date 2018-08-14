//
//  ContactListViewController.swift
//  SocialProject
//
//  Created by 薛 靖博 on 2018/8/10.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit

enum Contact: Int {
    case none = 0
    case friend = 1
    case attention = 2
    case fans = 3
    case black = 4
}

class ContactListViewController: ZYYBaseViewController {
    
    var curVC: FriendListController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        (childViewControllers as! [FriendListController]).forEach { (vc) in
            
            if let id = vc.restorationIdentifier {
                switch id {
                case "\(FriendListController.self)0":
                    vc.atype = .friend
                case "\(FriendListController.self)1":
                    vc.atype = .attention
                case "\(FriendListController.self)2":
                    vc.atype = .fans
                default:
                    break
                }
            }
            
        }
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

extension ContactListViewController {

    @IBAction func doSelect(_ sender: UISegmentedControl) {
        let vcs = childViewControllers as! [FriendListController]
        
        if curVC == nil {
            curVC = vcs.filter({ $0.restorationIdentifier! == "\(FriendListController.self)0" })[0]
        }
        let vc = vcs.filter({ $0.restorationIdentifier! == "\(FriendListController.self)\(sender.selectedSegmentIndex)" })[0]
        
        transition(from: curVC!, to: vc, duration: 1, options: .autoreverse, animations: nil) { (finish) in
            if finish {
                self.curVC = vc
            }
        }
    }
}










