//
//  FriendListController.swift
//  SocialProject
//
//  Created by 薛 靖博 on 2018/8/10.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit
import SwiftyJSON

class FriendListController: ZYYBaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let refreshNotity = NSNotification.Name(rawValue: "\(FriendListController.self)")
    
    var dataArr: [JSON]?
    var searchArr: [JSON]?
    
    var atype: Contact = .none {
        didSet {
            if atype == .black {
                netBlackList()
            } else {
                netFriends(atype: atype)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView?.addMJHeader { [weak self] in
            self?.atype = self?.atype ?? .none
        }
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData(_:)), name: refreshNotity, object: nil)
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
        
        if let vc = segue.destination as? UserInfoViewController, let id = sender as? String {
            vc.id = id
        }
    }
    
    @IBAction func doSearch(_ sender: UIBarButtonItem) {
        if let txt = searchBar.text {
            netSearch(phone: txt)
        }
    }
    
}

extension FriendListController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContactCell
        
        if let dataArr = searchArr {
            let data = dataArr[indexPath.row]
            
            if let headImg = data[ContactModel.headImg].string, let url = URL(string: Image_Path + headImg) {
                cell.imgView.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "mine_avatar")) { (rsp) in
                    cell.imgView.image = rsp.value?.resize(width: 44, height: 44)
                }
            } else {
                cell.imgView.image = #imageLiteral(resourceName: "mine_avatar")
            }
            cell.titleLB.text = data[ContactModel.name].string
            cell.addBtn?.isHidden = data[ContactModel.friends].bool ?? true
            cell.toAdd = {
                cell.addBtn?.isEnabled = false
                self.netAttention(other: "\(data["id"].int ?? 0)", complete: {
                    cell.addBtn?.isEnabled = true
                })
            }
            cell.toCancel = {
                cell.cancelBtn?.isEnabled = false
                self.netCancelAttention(other: "\(data["id"].int ?? 0)", complete: {
                    cell.cancelBtn?.isEnabled = true
                })
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let searchArr = searchArr else { return }
        let data = searchArr[indexPath.row]
        performSegue(withIdentifier: "toDetail", sender: "\(data[ContactModel.id].int ?? 0)")
    }
}

extension FriendListController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("textDidChange #" + searchText)
        
        if atype != .none {
            
            if let txt = searchBar.text {
                
                if txt.count != 0 {
                    searchArr = searchArr?.filter({
                        let isMobile = ($0[ContactModel.mobile].string ?? "").contains(txt)
                        let isName = ($0[ContactModel.name].string ?? "").contains(txt)
                        
                        return isName || isMobile
                    })
                } else {
                    searchArr = dataArr
                    searchBar.text = ""
                }
                
                tableView.reloadData()
            }
        } else {
            if let txt = searchBar.text {
                netSearch(phone: txt)
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        print("shouldChangeTextIn #" + text + "--" + (searchBar.text ?? ""))
        
        if atype != .none {
            
            if let txt = searchBar.text, txt.count == 1, text == "" {
                searchArr = dataArr
                searchBar.text = ""
                tableView.reloadData()
            }
        } else {
            searchArr = nil
            tableView.reloadData()
        }
        
        return true
    }
}

extension FriendListController {
    
    @objc func refreshData(_ sender: NSNotification) {
        netFriends(atype: atype)
    }
    
    func netFriends(atype: Contact) -> Void {
        guard
            let idString = UserDefaults.standard.string(forKey: "ID"),
            let id = Int(idString)
            else { return }
        
        showBlurHUD()
        
        let req = ContactRequest(id: id, type: atype.rawValue)
        
        WebAPI.send(req) { (isSuccess, result, error) in
            self.hideBlurHUD()
            
            if isSuccess, let result = result {
                if let arr = result[ContactModel.list].array {
                    self.dataArr = Array<JSON>(arr)
                    self.searchArr = Array<JSON>(arr)
                }
                self.tableView?.reloadData()
            } else {
                self.showBlurHUD(result: .failure, title: error?.errorMsg)
            }
            self.tableView?.stopReload()
        }
    }
    
    func netAttention(other id: String, complete: @escaping (() -> Void)) -> Void {
        guard let idString = UserDefaults.standard.string(forKey: "ID") else { return }
        
        showBlurHUD()
        
        let req = AttentionReq(id: idString, otherId: id)
        
        WebAPI.send(req) { (isSuccess, result, error) in
            self.hideBlurHUD()
            
            if isSuccess {
                NotificationCenter.default.post(name: self.refreshNotity, object: nil)
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
                NotificationCenter.default.post(name: self.refreshNotity, object: nil)
                self.showBlurHUD(result: .success, title: "成功")
            } else {
                self.showBlurHUD(result: .failure, title: error?.errorMsg)
            }
            complete()
        }
    }
    
    func netSearch(phone: String) -> Void {
        
        let req = SearchUserInfoReq(mobile: phone)
        
        WebAPI.send(req) { (isSuccess, result, error) in
            self.hideBlurHUD()
            
            if isSuccess, let result = result {
                if let arr = result.array {
                    self.dataArr = Array<JSON>(arr)
                    self.searchArr = Array<JSON>(arr)
                }
                self.tableView?.reloadData()
            } else {
                self.showBlurHUD(result: .failure, title: error?.errorMsg)
            }
            self.tableView?.stopReload()
        }
    }
    
    func netBlackList() -> Void {
        
        let req = BlackListReq(user: userID)
        WebAPI.send(req) { (isSuccess, result, error) in
            self.hideBlurHUD()
            
            if isSuccess, let result = result {
                
                if let arr = result.array {
                    self.dataArr = Array<JSON>(arr)
                    self.searchArr = Array<JSON>(arr)
                }
                self.tableView?.reloadData()
            } else {
                self.showBlurHUD(result: .failure, title: error?.errorMsg)
            }
            self.tableView?.stopReload()
        }
    }
}













