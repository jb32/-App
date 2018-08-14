//
//  ChatListController.swift
//  SocialProject
//
//  Created by Mac on 2018/8/3.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit

class ChatListController: RCConversationListViewController {
    
    var isClick: Bool = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isClick = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let conversationTypes: [RCConversationType] = [.ConversationType_PRIVATE, .ConversationType_APPSERVICE, .ConversationType_SYSTEM]
        setDisplayConversationTypes(conversationTypes.map({ NSNumber(value: $0.rawValue ) }))
        RCIM.shared().userInfoDataSource = self
//        setCollectionConversationType([RCConversationType.ConversationType_DISCUSSION.rawValue, RCConversationType.ConversationType_GROUP.rawValue])
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

    override func onSelectedTableRow(_ conversationModelType: RCConversationModelType, conversationModel model: RCConversationModel!, at indexPath: IndexPath!) {
        if isClick {
            isClick = false
            if model.conversationModelType == RCConversationModelType.CONVERSATION_MODEL_TYPE_PUBLIC_SERVICE {
                let chatVC = RCConversationViewController.init()
                chatVC.conversationType = model.conversationType
                chatVC.targetId = model.targetId
                chatVC.title = model.conversationTitle
                self.navigationController?.pushViewController(chatVC, animated: true)
            }
            if model.conversationModelType == RCConversationModelType.CONVERSATION_MODEL_TYPE_NORMAL {
                let chatVC = RCConversationViewController.init()
                chatVC.conversationType = model.conversationType
                chatVC.targetId = model.targetId
                chatVC.title = model.conversationTitle
                chatVC.unReadMessage = model.unreadMessageCount
                chatVC.enableNewComingMessageIcon = true
                chatVC.enableUnreadMessageIcon = true
                if model.conversationType == RCConversationType.ConversationType_SYSTEM {
                    chatVC.title = "系统消息"
                }
                if model.objectName == "RC:ContactNtf" {
                    
                }
                if model.conversationType == .ConversationType_PRIVATE {
                    chatVC.displayUserNameInCell = false
                }
                self.navigationController?.pushViewController(chatVC, animated: true)
            }
        }
    }
}

extension ChatListController: RCIMUserInfoDataSource {
    
    func getUserInfo(withUserId userId: String!, completion: ((RCUserInfo?) -> Void)!) {
        
        let info = RCIM.shared().getUserInfoCache(userId)
        
        if let info = info {
            completion?(info)
        } else {
            let req = SearchUserInfoReq(id: Int(userId) ?? 0)
            
            WebAPI.send(req) { (isSuccess, result, error) in
                
                if isSuccess, let result = result?.array?.first {
                    let info = RCUserInfo(userId: result[ContactModel.id].string, name: result[ContactModel.name].string, portrait: Image_Path + (result[ContactModel.headImg].string ?? ""))
                    DispatchQueue.main.async {
                        completion?(info)
                        self.conversationListTableView.reloadData()
                    }
                } else {
                    DispatchQueue.main.async {
                        completion?(nil)
                        self.conversationListTableView.reloadData()
                    }
                }
                
            }
        }
    }
}


