//
//  BrandController.swift
//  SocialProject
//
//  Created by Mac on 2018/7/16.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit
import DNSPageView

enum DiscoveryType: Int {
    // 直销品牌
    case brand = 0
    case other
    case consult
}

class BrandController: ZYYBaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
//    var dataArray: [BrandModel] = []
    var type: DiscoveryType = .other
    var ID: String = ""
    var page = 1
    
    var projectData: [ProjectModel] = []
    var pushAction:(_ vc: ProjectDetaiController) -> Void = {_ in }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: DEVICE_WIDTH, height: 1))
        switch type {
        case .brand:
            self.getBrandList()
        case .consult:
            tableView.addMJHeader { [unowned self] in
                self.page = 1
                self.getInformationData()
            }
            tableView.addMJFooter { [unowned self] in
                self.page = 1 + self.page
                self.getInformationData()
            }
            self.getInformationData()
        default:
            break
        }
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

extension BrandController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.projectData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BrandCell", for: indexPath) as! BrandCell
        let model = self.projectData[indexPath.row]
        cell.brandImgView.setWebImage(with: Image_Path+model.file_url, placeholder: nil)
        cell.titleLabel.text = model.title
        cell.contentLabel.text = model.synopsis
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.projectData[indexPath.row]
        let detailVC = UIStoryboard(name: .discovery).initialize(class: ProjectDetaiController.self)
        detailVC.model = model
        if self.type == .brand {
            self.navigationController?.pushViewController(detailVC, animated: true)
        } else {
            self.pushAction(detailVC)
        }
    }
}

extension BrandController {
    func getBrandList() {
        self.showBlurHUD()
        let brandRequest = BrandRequest()
        WebAPI.send(brandRequest) { (isSuccess, result, error) in
            self.hideBlurHUD()
            if isSuccess {
                self.projectData = (result?.objectModels)!
                self.tableView.reloadData()
            } else {
                self.showBlurHUD(result: .failure, title: error?.errorMsg)
            }
        }
    }
    
    func getProjectData(ID: String) {
        self.showBlurHUD()
        let projectRequest = ProjectRequest(ID: ID)
        WebAPI.send(projectRequest) { (isSuccess, result, error) in
            self.hideBlurHUD()
            if isSuccess {
                self.projectData = (result?.objectModels)!
                self.tableView.reloadData()
            } else {
                self.showBlurHUD(result: .failure, title: error?.errorMsg)
            }
        }
    }
    
    // 咨询
    func getInformationData() {
        self.showBlurHUD()
        let informationRequest = InformationListRequest(page: self.page)
        WebAPI.send(informationRequest) { (isSuccess, result, error) in
            self.hideBlurHUD()
            if isSuccess {
                if self.page > 1 {
                    self.projectData += (result?.objectModels)!
                } else {
                    self.projectData.removeAll()
                    self.projectData = (result?.objectModels)!
                }
                self.tableView.reloadData()
                self.tableView.stopReload()
            } else {
                self.showBlurHUD(result: .failure, title: error?.errorMsg)
            }
        }
    }
}

extension BrandController: DNSPageReloadable {
    func titleViewDidSelectedSameTitle() {
        print("重复点击了标题")
        switch type {
        case .brand:
            break
        case .consult:
            self.getInformationData()
        default:
            self.getProjectData(ID: self.ID)
        }
    }
    
    func contentViewDidEndScroll() {
        print("contentView滑动结束")
    }
}
