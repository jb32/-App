//
//  DetailsController.swift
//  SocialProject
//
//  Created by Mac on 2018/8/23.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit

class DetailsController: ZYYBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dataArray: [TradeModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: DEVICE_WIDTH, height: 1))
        
        getDetailsData()
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

extension DetailsController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ZYYAllDetailTableViewCell") as! ZYYAllDetailTableViewCell
        let model: TradeModel = self.dataArray[indexPath.row]
        cell.moneyLabel.text = String(format: "+%.2f元", model.money)
        cell.detailTypeLabel.text = model.typeStr
        cell.timeLabel.text = model.dataStr
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension DetailsController {
    func getDetailsData() {
        self.showBlurHUD()
        let detailsRequest = DetailsRequest(ID: userID)
        WebAPI.send(detailsRequest) { (isSuccess, result, error) in
            self.hideBlurHUD()
            if isSuccess {
                self.dataArray = (result?.objectModels)!
                self.tableView.reloadData()
            } else {
                self.showBlurHUD(result: .failure, title: error?.errorMsg)
            }
        }
    }
}
