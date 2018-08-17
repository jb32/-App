//
//  CommentListController.swift
//  SocialProject
//
//  Created by Mac on 2018/8/15.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit

class CommentListController: ZYYBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var model: DynamicModel?
    var dataArray: [CommentModel] = []
    
    var commentView: CustomInputView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: DEVICE_WIDTH, height: 1))
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        getCommentListData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func commentAction(_ sender: UIButton) {
        commentView = CustomInputView.instance(superView: self.view)!
        commentView?.delegate = self as CustomInputViewDelegate
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

extension CommentListController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        let model = self.dataArray[indexPath.row]
        cell.timeLabel.text = model.commenttime
        cell.contentLabel.text = model.comment
        return cell
    }
}

extension CommentListController {
    func getCommentListData() {
        self.showBlurHUD()
        let hotRequest = CommentListRequest(movementId: (model?.id)!)
        WebAPI.send(hotRequest) { (isSuccess, result, error) in
            self.hideBlurHUD()
            if isSuccess {
                self.dataArray = (result?.objectModels)!
                self.tableView.reloadData()
            } else {
                self.showBlurHUD(result: .failure, title: error?.errorMsg)
            }
        }
    }
    
    // 评论
    func comentRequest(text: String) {
        self.showBlurHUD()
        let collectRequest = CommentRequest(comment: text, loginId: userID, movementId: (model?.id)!)
        WebAPI.send(collectRequest) { (isSuccess, result, error) in
            self.hideBlurHUD()
            if isSuccess {
                self.showBlurHUD(result: .success, title: "评论成功") { [unowned self] in
                    self.commentView?.removeFromSuperview()
                    self.getCommentListData()
                }
            } else {
                self.showBlurHUD(result: .failure, title: error?.errorMsg)
            }
        }
    }
}

extension CommentListController: CustomInputViewDelegate {
    func send(text: String) {
        self.comentRequest(text: text)
    }
}
