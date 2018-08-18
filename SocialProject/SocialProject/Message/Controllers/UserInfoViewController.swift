//
//  UserInfoViewController.swift
//  SocialProject
//
//  Created by 薛 靖博 on 2018/8/13.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserInfoViewController: UITableViewController {

    @IBOutlet weak var userCell: ContactUserCell!
    @IBOutlet weak var telCell: ContactTelCell!
    @IBOutlet weak var blackCell: ContactSwitchCell!
    @IBOutlet weak var attentionCell: ContactSwitchCell!
    
    var data: JSON?
    var relation: Contact = .none
    var id: String? {
        didSet {
            guard let id = id else { return }
            netUserInfo(user: id)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doBlack(_ sender: UISwitch) {
        guard let id = id else { return }
        
        if sender.isOn {
            netAddBlack(user: id)
        } else {
            netDeleteBlack(user: id)
        }
    }
    
    @IBAction func doAttention(_ sender: UISwitch) {
        guard let id = id else { return }
        
        if sender.isOn {
            netAttention(other: id) {
                
            }
        } else {
            netCancelAttention(other: id) {
                
            }
        }
    }
    
    @IBAction func doSend(_ sender: Any) {
        guard let data = data else { return }
        if let vc = RCConversationViewController(conversationType: .ConversationType_PRIVATE, targetId: "\(data[ContactModel.id].int ?? 0)") {
            vc.title = data[ContactModel.name].string
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension UserInfoViewController {
    func netUserInfo(user id: String) -> Void {
        let req = SearchUserInfoReq(id: Int(id) ?? 0)
        
        WebAPI.send(req) { (isSuccess, result, error) in
            
            if isSuccess, let result = result?.array?.first {
                self.data = result
                self.userCell.nameLB.text = result[ContactModel.name].string
                self.userCell.idLB.text = "\(result[ContactModel.id].int ?? (Int(id) ?? 0))"
                
                if let url = URL(string: Image_Path + (result[ContactModel.headImg].string ?? "")) {
                    self.userCell.imgView.af_setImage(withURL: url)
                }
                self.telCell.detailTextLabel?.text = result[ContactModel.mobile].string
                self.title = result[ContactModel.name].string
                self.netRelation(user: id)
            } else {
                
            }
        }
    }
    
    func netRelation(user otherID: String) -> Void {
        let req = RelationReq(user: userID, otherId: otherID)
        WebAPI.send(req) { (isSuccess, result, error) in
            
            if isSuccess, let result = result {
                
                let typeInt = result["type"].int ?? 0
                let type = Contact(rawValue: typeInt) ?? Contact.none
                
                switch type {
                case .none:
                    self.blackCell.switchView.isOn = false
                    self.attentionCell.switchView.isOn = false
                case .attention:
                    self.blackCell.switchView.isOn = false
                    self.attentionCell.switchView.isOn = true
                case .friend:
                    self.blackCell.switchView.isOn = false
                    self.attentionCell.switchView.isOn = true
                case .fans:
                    self.blackCell.switchView.isOn = false
                    self.attentionCell.switchView.isOn = false
                case .black:
                    self.blackCell.switchView.isOn = true
                    self.attentionCell.switchView.isOn = false
                }
                
            } else {
                
            }
        }
    }
    
    func netAddBlack(user id: String) -> Void {
        let req = AddBlackReq(user: userID, otherId: id)
        WebAPI.send(req) { (isSuccess, result, error) in
            self.hideBlurHUD()
            
            if isSuccess {
                let name = NSNotification.Name("\(FriendListController.self)")
                NotificationCenter.default.post(name: name, object: nil)
            } else {
                self.showBlurHUD(result: .failure, title: error?.errorMsg)
            }
            self.tableView?.stopReload()
        }
    }
    
    func netDeleteBlack(user id: String) -> Void {
        let req = DeleteBlackReq(user: userID, otherId: id)
        WebAPI.send(req) { (isSuccess, result, error) in
            self.hideBlurHUD()
            
            if isSuccess {
                let name = NSNotification.Name("\(FriendListController.self)")
                NotificationCenter.default.post(name: name, object: nil)
            } else {
                self.showBlurHUD(result: .failure, title: error?.errorMsg)
            }
            self.tableView?.stopReload()
        }
    }
    
    func netAttention(other id: String, complete: @escaping (() -> Void)) -> Void {
        showBlurHUD()
        
        let req = AttentionReq(id: userID, otherId: id)
        
        WebAPI.send(req) { (isSuccess, result, error) in
            self.hideBlurHUD()
            
            if isSuccess {
                let name = NSNotification.Name("\(FriendListController.self)")
                NotificationCenter.default.post(name: name, object: nil)
                self.showBlurHUD(result: .success, title: "添加成功")
            } else {
                self.showBlurHUD(result: .failure, title: error?.errorMsg)
            }
            complete()
        }
    }
    
    func netCancelAttention(other id: String, complete: @escaping (() -> Void)) -> Void {
        guard let idString = UserDefaults.standard.string(forKey: "ID") else { return }
        
        showBlurHUD()
        
        let req = CancelAttentionReq(id: idString, otherId: id)
        
        WebAPI.send(req) { (isSuccess, result, error) in
            self.hideBlurHUD()
            
            if isSuccess {
                let name = NSNotification.Name("\(FriendListController.self)")
                NotificationCenter.default.post(name: name, object: nil)
                self.showBlurHUD(result: .success, title: "成功")
            } else {
                self.showBlurHUD(result: .failure, title: error?.errorMsg)
            }
            complete()
        }
    }
}












