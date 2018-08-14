//
//  DiscoveryController.swift
//  SocialProject
//
//  Created by Mac on 2018/7/16.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit

class DiscoveryController: UITableViewController {
    
    var projectData: [ParentModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        
        self.getProjectData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnsAction(_ sender: UIButton) {
        switch sender.tag {
        case 1000:
            // 直销品牌
            let brandVC = UIStoryboard(name: .discovery).initialize(class: BrandController.self)
            brandVC.type = .brand
            self.navigationController?.pushViewController(brandVC, animated: true)
        case 1001:
            // 大咖排行
            let rankVC = UIStoryboard(name: .discovery).initialize(class: RankController.self)
            self.navigationController?.pushViewController(rankVC, animated: true)
        default:
            // 应用商店
            break
        }
    }
    

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        }
        return 10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DiscoveryCell", for: indexPath) as! DiscoveryCell
            cell.delegate = self
            if self.projectData.count > 0 {
                cell.reloadCollectionView()
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RankCell", for: indexPath) as! RankCell
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            let quotient = self.projectData.count / 4
            let remainder = self.projectData.count % 4
            if remainder != 0 {
                return CGFloat(70 * (quotient + 1))
            } else {
                return CGFloat(70 * quotient)
            }
        } else {
            return 45
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

extension DiscoveryController {
    func getProjectData() {
        self.showBlurHUD()
        let parentRequest = ParentRequest()
        WebAPI.send(parentRequest) { (isSuccess, result, error) in
            self.hideBlurHUD()
            if isSuccess {
                self.projectData = (result?.objectModels)!
                self.tableView.reloadData()
            } else {
                self.showBlurHUD(result: .failure, title: error?.errorMsg)
            }
        }
    }
}

extension DiscoveryController: DiscoveryDataDelegate {
    func getData() -> [ParentModel] {
        return self.projectData
    }
}
