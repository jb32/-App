//
//  OthersAlbumController.swift
//  SocialProject
//
//  Created by Mac on 2018/8/24.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit
import YLImagePickerController

class OthersAlbumController: ZYYBaseViewController {

    var ID: String = ""
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    
    var imagePicker:YLImagePickerController?
    
    var imgs: [String] = []
    var dataArray: [Data] = []
    var presentAction:(_ vc: UIViewController) -> Void = {_ in }
    
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

extension OthersAlbumController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        cell.photoImg.setWebImage(with: Image_Path+imgs[indexPath.item], placeholder: nil)
        return cell
    }
}

extension OthersAlbumController {
    func getUserData() {
        self.showBlurHUD()
        let userRequest = OthersInfoRequest(ID: ID)
        WebAPI.send(userRequest) { (isSuccess, result, error) in
            self.hideBlurHUD()
            if isSuccess {
                self.imgs = (result?.stringValue.components(separatedBy: ","))!
                self.collectionView.reloadData()
            } else {
                self.showBlurHUD(result: .failure, title: error?.errorMsg)
            }
        }
    }
}
