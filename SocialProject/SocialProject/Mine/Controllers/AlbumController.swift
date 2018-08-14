//
//  AlbumController.swift
//  SocialProject
//
//  Created by Mac on 2018/7/18.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit
import YLImagePickerController

class AlbumController: ZYYBaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    
    var imagePicker:YLImagePickerController?
    
    var imgs: [String] = []
    var dataArray: [Data] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getUserData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let width = (DEVICE_WIDTH - 45) / 3
        layout.itemSize = CGSize(width: width, height: width)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.setRightItem(img: UIImage(named: "add")!)
    }
    
    @objc override func rightAction() {
        imagePicker = YLImagePickerController.init(maxImagesCount: 9)
        // 导出图片
        imagePicker?.didFinishPickingPhotosHandle = {(photos: [YLPhotoModel]) in
            for photo in photos {
                if photo.type == YLAssetType.photo {
                    print((UIImagePNGRepresentation(photo.image!)?.count)! / 1024)
                    self.dataArray.append(UIImageJPEGRepresentation(photo.image!, 0.2)!)
                    
                }else if photo.type == YLAssetType.gif {
                    print((photo.data?.count)! / 1024)
                }else if photo.type == YLAssetType.video {
                    print("视频")
                }
            }
            self.showBlurHUD()
            let uploadRequest = UploadPhotoRequest(ID: userID, file: self.dataArray, url: "")
            WebAPI.upload(uploadRequest, progressHandler: { (progress) in
                
            }, completeHandler: { (isSuccess, urlString, error) in
                if isSuccess == true, let urlString = urlString as? String {
                    self.showBlurHUD(result: .success, title: "上传成功")
                } else {
                    self.showBlurHUD(result: .failure, title: error?.errorMsg)
                }
            })
        }
        
        present(imagePicker!, animated: true, completion: nil)
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

extension AlbumController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        cell.photoImg.setWebImage(with: Image_Path+imgs[indexPath.item], placeholder: nil)
        cell.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(gesture:))))
        return cell
    }
    
    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        let selectedIndexPath = self.collectionView.indexPathForItem(at: gesture.location(in: self.collectionView))
        switch(gesture.state) {
        case .began:
            guard let selectedIndexPath = self.collectionView.indexPathForItem(at: gesture.location(in: self.collectionView)) else {
                break
            }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            self.collectionView.endInteractiveMovement()
            // 检测是否删除操作，是的话删除数据并调用 reloadData()
            let alert = LYAlertView(title: "提示：", message: "是否删除该张照片？")
            alert.addAlertAction(with: "取消", style: .cancel)
            alert.addAlertAction(with: "确定", style: .destructive) { [unowned self] _ in
                self.deletePhoto(indexPath: selectedIndexPath!)
                return
            }
            alert.show()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
}

extension AlbumController {
    func getUserData() {
        self.showBlurHUD()
        let userRequest = UserInfoRequest(ID: userID)
        WebAPI.send(userRequest) { (isSuccess: Bool, user: UserModel?, error: NetworkError?) in
            self.hideBlurHUD()
            if isSuccess {
                if (user?.album.length)! > 0 {
                    self.imgs = (user?.album.components(separatedBy: ","))!
                    self.collectionView.reloadData()
                }
            } else {
                self.showBlurHUD(result: .failure, title: error?.errorMsg)
            }
        }
    }
    
    func deletePhoto(indexPath: IndexPath) {
        self.showBlurHUD()
        let deleteRequest = DeletePhotoRequest(ID: userID, imgUrl: self.imgs[indexPath.item])
        WebAPI.send(deleteRequest) { (isSuccess, result, error) in
            self.hideBlurHUD()
            if isSuccess {
                self.getUserData()
            } else {
                self.showBlurHUD(result: .failure, title: error?.errorMsg)
            }
        }
    }
}
