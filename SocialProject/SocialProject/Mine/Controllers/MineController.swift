//
//  MineController.swift
//  SocialProject
//
//  Created by Mac on 2018/7/16.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit
import AVFoundation
import AssetsLibrary
import DNSPageView

class MineController: UIViewController {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    var userModel: UserModel?
    
    // 相机，相册
    var cameraPicker: UIImagePickerController!
    var photoPicker: UIImagePickerController!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getUserData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        bgView.backgroundColor = UIColor.themOneColor
        
        let titles: [String] = ["我的", "简介", "相册", "动态"]
        var childViewControllers: [UIViewController] = []
        let myVC = UIStoryboard(name: .mine).initialize(class: MyController.self)
        myVC.pushAction = { [unowned self] vc in
            self.navigationController?.pushViewController(vc, animated: true)
        }
        childViewControllers.append(myVC)
        let describtionVC = UIStoryboard(name: .mine).initialize(class: DescribtionController.self)
        childViewControllers.append(describtionVC)
        let albumVC = UIStoryboard(name: .mine).initialize(class: AlbumController.self)
        albumVC.presentAction = { [unowned self] vc in
            self.present(vc, animated: true, completion: nil)
        }
        childViewControllers.append(albumVC)
        let dynamicVC = UIStoryboard(name: .mine).initialize(class: MyDynamicController.self)
        childViewControllers.append(dynamicVC)
        
        // 创建DNSPageStyle，设置样式
        let style = DNSPageStyle()
        style.titleSelectedColor = .yellow
        style.titleColor = .white
        style.titleViewBackgroundColor = .themOneColor
        
        // 创建对应的DNSPageView，并设置它的frame
        let pageView = DNSPageView(frame: CGRect(x: 0, y: 110, width: DEVICE_WIDTH, height: DEVICE_HEIGHT - 44 - 100), style: style, titles: titles, childViewControllers: childViewControllers)
        self.view.addSubview(pageView)
        
        self.avatarImg.isUserInteractionEnabled = true
        avatarImg.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(changeAvartar)))
    }
    
    @objc func changeAvartar() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "拍照", style: .default, handler: { [unowned self] (action) in
            actionSheet.dismiss(animated: true, completion: nil)
            let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            if (authStatus == AVAuthorizationStatus.restricted) || (authStatus == AVAuthorizationStatus.denied) {
                let alert = LYAlertView(title: "您尚未开启相机权限，是否开启")
                alert.addAlertAction(with: "取消", style: .cancel)
                alert.addAlertAction(with: "去设置", style: .destructive) {[unowned self] _ in
                    let url = NSURL(string: UIApplicationOpenSettingsURLString)!
                    if UIApplication.shared.canOpenURL(url as URL) {
                        UIApplication.shared.openURL(url as URL)
                    }
                }
                alert.show()
            } else {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    self.initCameraPicker()
                    self.present(self.cameraPicker, animated: true, completion: nil)
                }
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "相册", style: .default, handler: { [unowned self] (action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.initPhotoPicker()
                self.present(self.photoPicker, animated: true, completion: nil)
            }
        }))
        self.present(actionSheet, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension MineController {
    func getUserData() {
        self.showBlurHUD()
        let userRequest = UserInfoRequest(ID: userID)
        WebAPI.send(userRequest) { (isSuccess: Bool, user: UserModel?, error: NetworkError?) in
            self.hideBlurHUD()
            if isSuccess {
                self.userModel = user
                self.avatarImg.setWebImage(with: Image_Path+(user?.headImg)!, placeholder: UIImage(named: "mine_avatar"))
                self.nameLabel.text = user?.name
            } else {
                self.showBlurHUD(result: .failure, title: error?.errorMsg)
            }
        }
    }
}

extension MineController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: 修改头像那一块儿👦
    func initCameraPicker(){
        cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        cameraPicker.cameraDevice = .front
        cameraPicker.cameraCaptureMode = .photo
        cameraPicker.allowsEditing = true
    }
    
    func initPhotoPicker(){
        photoPicker =  UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.sourceType = .photoLibrary
        photoPicker.allowsEditing = true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            let imageData = UIImageJPEGRepresentation(image, 0.5)!
            self.showBlurHUD(title: "修改头像中")
            let uploadRequest = UploadPhotoRequest(ID: userID, file: [imageData], url: "/app/headUploadFile")
            WebAPI.upload(uploadRequest, progressHandler: { (progress) in
                
            }, completeHandler: { (isSuccess, urlString, error) in
                if isSuccess == true, let urlString = urlString as? String {
                    self.showBlurHUD(result: .success, title: "修改成功")
                    picker.dismiss(animated: true, completion: {
                        self.avatarImg.setWebImage(with: Image_Path+urlString)
                    })
                    self.dismiss(animated: true, completion: nil)
                }
            })
        } else {
            picker.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }
}
