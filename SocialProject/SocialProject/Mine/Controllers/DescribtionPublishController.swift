//
//  DescribtionPublishController.swift
//  SocialProject
//
//  Created by Mac on 2018/8/21.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit

let kMaxTextCount = 300

class DescribtionPublishController: XWPublishBaseController {
    
    var isEdit: Bool = false
    var model: DescribtionModel?
    
    var mainScrollView: UIScrollView!
    
    var noteTextBackgroudView: UIView!
    var contentTV: UITextView!
    var textNumberLabel: UILabel!
    var submitBtn: UIButton!
    
    var noteTextHeight: CGFloat = 0.0
    var allViewHeight: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = self.isEdit ? "编辑简介" : "发布简介"
        
        self.view.backgroundColor = .white
        self.mainScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: DEVICE_WIDTH, height: DEVICE_HEIGHT))
        self.mainScrollView.delegate = self
        self.view.addSubview(self.mainScrollView!)
        
        self.showInView = self.mainScrollView
        
        self.initPickerView()
        
        self.addSubviews()
    }
    
    func addSubviews() {
        noteTextBackgroudView = UIView()
        noteTextBackgroudView.backgroundColor = .white
        mainScrollView.addSubview(noteTextBackgroudView)
        
        contentTV = UITextView()
        contentTV.backgroundColor = UIColor.backgroundColor
        contentTV.keyboardType = .default
        contentTV.font = UIFont.systemFont(ofSize: 15.0)
        contentTV.textColor = .themTwoColor
        contentTV.delegate = self
        mainScrollView?.addSubview(contentTV)
        
        textNumberLabel = UILabel()
        textNumberLabel.textAlignment = .right
        textNumberLabel.font = UIFont.systemFont(ofSize: 12.0)
        textNumberLabel.textColor = UIColor.fontColor
        textNumberLabel.backgroundColor = .white
        textNumberLabel.text = "0/\(kMaxTextCount)"
        self.mainScrollView.addSubview(textNumberLabel)
        
        //发布按钮样式->可自定义!
        submitBtn = UIButton()
        submitBtn.setTitle("发布", for: .normal)
        submitBtn.setTitleColor(UIColor.white, for: .normal)
        submitBtn.backgroundColor = UIColor.themOneColor
        submitBtn.layer.cornerRadius = 20
        submitBtn.layer.masksToBounds = true
        submitBtn.layer.shouldRasterize = true
        submitBtn.layer.rasterizationScale = UIScreen.main.scale
        submitBtn.addTarget(self, action: #selector(submitBtnClicked), for: .touchUpInside)
        self.mainScrollView.addSubview(submitBtn)
        
        if isEdit {
            self.contentTV.text = model?.content
            self.imageArray.addObjects(from: (model?.images.components(separatedBy: ","))!)
        }
        
        updateViewsFrame()
    }
    
    func updateViewsFrame() {
        if (allViewHeight == 0) {
            allViewHeight = 0
        }
        if (noteTextHeight == 0) {
            noteTextHeight = 100
        }
        
        noteTextBackgroudView.frame = CGRect(x: 0, y: 0, width: DEVICE_WIDTH, height: noteTextHeight + 10)
        
        //文本编辑框
        contentTV.frame = CGRect(x: 15, y: 10, width: DEVICE_WIDTH - 30, height: noteTextHeight)
        
        //文字个数提示Label
        textNumberLabel.frame = CGRect(x: 0, y: contentTV.frame.origin.y + contentTV.frame.size.height-15, width: DEVICE_WIDTH-10, height: 15)
        
        self.updatePickerViewFrameY(textNumberLabel.frame.origin.y + textNumberLabel.frame.size.height)
        
        //发布按钮
        submitBtn.bounds = CGRect(x: 15, y: self.getPickerViewFrame().origin.y+self.getPickerViewFrame().size.height+10, width: DEVICE_WIDTH - 30, height: 40)
        submitBtn.frame = CGRect(x: 15, y: self.getPickerViewFrame().origin.y+self.getPickerViewFrame().size.height+10, width: DEVICE_WIDTH - 30, height: 40)
        allViewHeight = noteTextHeight + 10 + self.getPickerViewFrame().size.height + 15 + 50
        mainScrollView.contentSize = CGSize(width: 0, height: allViewHeight)
    }
    
    @objc func submitBtnClicked() {
        if checkInput() {
            submitToServer()
        }
    }
    
    override func pickerViewFrameChanged() {
        self.updateViewsFrame()
    }
    
    func checkInput() -> Bool {
        if contentTV.text.length == 0 {
            self.showBlurHUD(result: .warning, title: "请输入文字")
            return false
        }
        if contentTV.text.length > 300 {
            self.showBlurHUD(result: .warning, title: "超出文本限制")
            return false
        }
        return true
    }
    
    func submitToServer() {
        if isEdit {
            var temp: String = ""
            let arr = model?.images.components(separatedBy: ",")
            for img in arr! {
                if self.imageArray.contains(img) {
                } else {
                    temp = temp + img + ","
                }
            }
            self.showBlurHUD()
            let imageData: [Data] = self.getBigImageArray() as! [Data]
            let uploadRequest = UploadPhotoRequest(ID: String(format: "%d", (model?.ID)!), file: imageData, url: "/userProfile/app/updataProfile", type: "", comment: temp, content: contentTV.text)
            WebAPI.upload(uploadRequest, progressHandler: { (progress) in
                
            }, completeHandler: { (isSuccess, urlString, error) in
                self.hideBlurHUD()
                if isSuccess == true {
                    let alert = LYAlertView(title: "修改成功")
                    alert.addAlertAction(with: "确定", style: .destructive) {[unowned self] _ in
                        self.navigationController?.popViewController(animated: true)
                    }
                    alert.show()
                } else {
                    self.showBlurHUD(result: .failure, title: error?.errorMsg)
                }
            })
        } else {
            self.showBlurHUD()
            let imageData: [Data] = self.getBigImageArray() as! [Data]
            let uploadRequest = UploadPhotoRequest(ID: userID, file: imageData, url: "/userProfile/app/releaseProfile", type: "", comment: "", content: contentTV.text)
            WebAPI.upload(uploadRequest, progressHandler: { (progress) in
                
            }, completeHandler: { (isSuccess, urlString, error) in
                self.hideBlurHUD()
                if isSuccess == true {
                    let alert = LYAlertView(title: "上传成功")
                    alert.addAlertAction(with: "确定", style: .destructive) {[unowned self] _ in
                        self.navigationController?.popViewController(animated: true)
                    }
                    alert.show()
                } else {
                    self.showBlurHUD(result: .failure, title: error?.errorMsg)
                }
            })
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

extension DescribtionPublishController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            self.view.endEditing(true)
        }
    }
}

extension DescribtionPublishController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        textNumberLabel.text = "\(contentTV.text.length)/\(kMaxTextCount)"
        if contentTV.text.length > kMaxTextCount {
            textNumberLabel.textColor = .red
        } else {
            textNumberLabel.textColor = .fontColor
        }
        textChanged()
        return true
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        textNumberLabel.text = "\(contentTV.text.length)/\(kMaxTextCount)"
        if contentTV.text.length > kMaxTextCount {
            textNumberLabel.textColor = .red
        } else {
            textNumberLabel.textColor = .fontColor
        }
        textChanged()
    }
    
    func textChanged() {
        var orgRect = self.contentTV.frame
        let size = contentTV.sizeThatFits(CGSize(width: orgRect.size.width, height: CGFloat(MAXFLOAT)))
        orgRect.size.height = size.height + 10
        if orgRect.size.height > 100 {
            noteTextHeight = orgRect.size.height
        } else {
            noteTextHeight = 100
        }
        
        self.updateViewsFrame()
    }
}
