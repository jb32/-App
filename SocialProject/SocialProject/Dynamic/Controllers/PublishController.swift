//
//  PublishController.swift
//  SocialProject
//
//  Created by Mac on 2018/8/20.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit

class PublishController: XWPublishController {
    
    var model: CircleModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
    }
    
    override func chooseCircleAction(_ sender: UIButton!) {
        let circleVC = UIStoryboard(name: .user).initialize(class: CircleController.self)
        circleVC.type = false
        circleVC.saveModelType = { [unowned self] model in
            self.model = model
            self.chooseCircleBtn.setTitle(model.type, for: .normal)
            self.navigationController?.popViewController(animated: true)
        }
        self.navigationController?.pushViewController(circleVC, animated: true)
    }
    
    override func submitToServer() {
        if self.model == nil {
            self.showBlurHUD(result: .warning, title: "请选择项目名称")
            return
        }
        self.showBlurHUD()
        let imageData: [Data] = self.getBigImageArray() as! [Data]
        let uploadRequest = UploadPhotoRequest(ID: userID, file: imageData, url: "/addDynamic", type: "\((self.model?.id)!)", comment: noteTextView.text)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
