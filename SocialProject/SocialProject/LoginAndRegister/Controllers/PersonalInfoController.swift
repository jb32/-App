//
//  PersonalInfoController.swift
//  SocialProject
//
//  Created by Mac on 2018/7/27.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit

class PersonalInfoController: ZYYBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let titles = ["昵称：", "性别：", "年龄：", "地区："]
    let placeholders = ["请输入您的昵称", "请输入您的性别", "请输入您的年龄", "请输入您的地区"]
    var contents: [String] = []
    
    var nicknameTF: UITextField!
    var sexTF: UITextField!
    var ageTF: UITextField!
    var addressTF: UITextField!
//    var jobTF: UITextField!
//    var projectNameTF: UITextField!
//    var companyAddressTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: DEVICE_WIDTH, height: 1))
        self.getUserData()
        self.setRightItem(title: "保存")
    }
    
    override func rightAction() {
        self.showBlurHUD()

        var dateStr: String = ""
        if self.ageTF.text?.length != 0 {
            let dfmatter = DateFormatter()
            dfmatter.dateFormat="yyyy-MM-dd HH:mm:ss"
            let date = dfmatter.date(from: (self.ageTF.text! + " 00:00:00"))
            let dateStamp:TimeInterval = date!.timeIntervalSince1970
            let dateSt:Int = Int(dateStamp)
            dateStr = "\(dateSt)"
        }
        let updateUserInfoRequest = UpdateUserInfoRequest(ID: userID, name: nicknameTF.text!, sex: sexTF.text! == "男" ? "0" : "1", address: addressTF.text!, industry: "", autograph: "", dateOfBirth: dateStr)
        WebAPI.send(updateUserInfoRequest) { (isSuccess, result, error) in
            self.hideBlurHUD()
            if isSuccess {
                self.showBlurHUD(result: .success, title: "修改成功") { [unowned self] in
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                self.showBlurHUD(result: .failure, title: error?.errorMsg)
            }
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

extension PersonalInfoController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalInfoCell", for: indexPath) as! PersonalInfoCell
        cell.titleLabel.text = titles[indexPath.row]
        cell.contentTF.placeholder = placeholders[indexPath.row]
        cell.contentTF.isEnabled = false
        if contents.count > 0 {
            cell.contentTF.text = contents[indexPath.row]
        }
        switch indexPath.row {
        case 0:
            cell.contentTF.isEnabled = true
            self.nicknameTF = cell.contentTF
        case 1:
            cell.contentTF.isEnabled = false
            self.sexTF = cell.contentTF
        case 2:
            cell.contentTF.isEnabled = false
            self.ageTF = cell.contentTF
        case 3:
            cell.contentTF.isEnabled = false
            self.addressTF = cell.contentTF
//        case 4:
//            cell.contentTF.isEnabled = true
//            self.jobTF = cell.contentTF
//        case 5:
//            cell.contentTF.isEnabled = true
//            self.projectNameTF = cell.contentTF
        default:
//            cell.contentTF.isEnabled = false
//            self.companyAddressTF = cell.contentTF
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 1:
            UsefulPickerView.showSingleColPicker("性别", data: ["男", "女"], defaultSelectedIndex: 0) {[unowned self] (selectedIndex, selectedValue) in
                self.sexTF.text = selectedValue
            }
        case 2:
            UsefulPickerView.showDatePicker("日期选择") {[unowned self] ( selectedDate) in
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let string = formatter.string(from: selectedDate)
                self.ageTF.text = string
            }
        case 3:
            UsefulPickerView.showCitiesPicker("省市区选择", defaultSelectedValues: ["河南", "郑州", "中原区"]) {[unowned self] (selectedIndexs, selectedValues) in
                // 处理数据
                let combinedString = selectedValues.reduce("", { (result, value) -> String in
                    result + " " + value
                })
                self.addressTF.text = combinedString
            }
//        case 7:
//            UsefulPickerView.showCitiesPicker("省市区选择", defaultSelectedValues: ["河南", "郑州", "中原区"]) {[unowned self] (selectedIndexs, selectedValues) in
//                // 处理数据
//                let combinedString = selectedValues.reduce("", { (result, value) -> String in
//                    result + " " + value
//                })
//                self.companyAddressTF.text = combinedString
//            }
        default:
            break
        }
    }
    
}

extension PersonalInfoController {
    func getUserData() {
        self.showBlurHUD()
        let userRequest = UserInfoRequest(ID: userID)
        WebAPI.send(userRequest) { (isSuccess: Bool, user: UserModel?, error: NetworkError?) in
            self.hideBlurHUD()
            if isSuccess {
                if user?.dateOfBirth.length == 0 {
                   self.contents = [user?.name, user?.sexStr, user?.dateOfBirth, user?.address] as! [String]
                } else {
                    let timeStamp = Int((user?.dateOfBirth)!)
                    // 转换为时间
                    let timeInterval:TimeInterval = TimeInterval(timeStamp!)
                    let date = Date(timeIntervalSince1970: timeInterval)
                    // 格式话输出
                    let dformatter = DateFormatter()
                    dformatter.dateFormat = "yyyy-MM-dd"
                    self.contents = [user?.name, user?.sexStr, dformatter.string(from: date), user?.address] as! [String]
                }
                self.tableView.reloadData()
            } else {
                self.showBlurHUD(result: .failure, title: error?.errorMsg)
            }
        }
    }
}
