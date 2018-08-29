//
//  CircleController.swift
//  SocialProject
//
//  Created by Mac on 2018/8/8.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit

class CircleController: ZYYBaseViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    
    var dataArray: [CircleModel] = []
    var model: CircleModel?
    
    var type: Bool = true

    var saveModelType:(_ model: CircleModel) -> Void = {_ in }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let width = DEVICE_WIDTH / 4 - 10
        layout.itemSize = CGSize(width: width, height: 50)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        self.getCircleData()
        if self.type {
            self.setRightItem(title: "保存")
        }
    }
    
    override func rightAction() {
        if model == nil {
            self.showBlurHUD(result: .failure, title: "您还未选择圈子")
            return
        }
        self.showBlurHUD()
        let chooseCircleRequest = ChooseCircleRequest(circleType: (model?.id)!, ID: userID)
        WebAPI.send(chooseCircleRequest) { (isSuccess, result, error) in
            self.hideBlurHUD()
            if isSuccess {
                self.showBlurHUD(result: .success, title: "保存成功") { [unowned self] in
                    UserDefaults.standard.set((self.model?.id)!, forKey: "circleType")
                    UserDefaults.standard.synchronize()
                    let mainVC = UIStoryboard(name: .main).initialize(class: ZYYBaseTabbarController.self)
                    UIApplication.shared.keyWindow?.rootViewController = mainVC
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

extension CircleController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CircleCell", for: indexPath) as! CircleCell
        let model = self.dataArray[indexPath.item]
        cell.circleBtn.setTitle(model.type, for: .normal)
        cell.circleBtn.isSelected = model.selected
        if model.selected {
            cell.circleBtn.backgroundColor = UIColor.themOneColor
        } else {
            cell.circleBtn.backgroundColor = UIColor.white
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        model = self.dataArray[indexPath.item]
        if !type {
            self.saveModelType(model!)
        } else {
            if !(model?.selected)! {
                for i in 0..<self.dataArray.count {
                    var temp = self.dataArray[i]
                    if temp.selected {
                        temp.selected = false
                        self.dataArray.remove(at: i)
                        self.dataArray.insert(temp, at: i)
                    }
                }
                model?.selected = true
                self.dataArray.remove(at: indexPath.item)
                self.dataArray.insert(model!, at: indexPath.item)
                self.collectionView.reloadData()
            }
        }
    }
}

extension CircleController {
    func getCircleData() {
        self.showBlurHUD()
        let circleRequest = CircleTypeRequest()
        WebAPI.send(circleRequest) { (isSuccess, result, error) in
            self.hideBlurHUD()
            if isSuccess {
                self.dataArray = (result?.objectModels)!
                self.collectionView.reloadData()
            } else {
                self.showBlurHUD(result: .failure, title: error?.errorMsg)
            }
        }
    }
}
