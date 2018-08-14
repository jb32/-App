//
//  DiscoveryCell.swift
//  SocialProject
//
//  Created by Mac on 2018/7/16.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit

protocol DiscoveryDataDelegate: NSObjectProtocol {
    func getData() -> [ParentModel]
}

class DiscoveryCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    
    var dataArray: [ParentModel] = []
    weak var delegate: DiscoveryDataDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        let width = DEVICE_WIDTH / 4 - 10
        layout.itemSize = CGSize(width: width, height: 60)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func reloadCollectionView() {
        self.dataArray = (self.delegate?.getData())!
        self.collectionView.reloadData()
    }

}

extension DiscoveryCell: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiscoveryTitleCell", for: indexPath) as! DiscoveryTitleCell
        let model = self.dataArray[indexPath.item]
        cell.discoveryImg.setWebImage(with: Image_Path+model.file_url, placeholder: nil)
        cell.discoveryLabel.text = model.typeName
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let projectVC = UIStoryboard(name: .discovery).initialize(class: ProjectController.self)
        projectVC.startIndex = indexPath.item
        var arr: [String] = []
        for model in self.dataArray {
            arr.append(model.typeName)
        }
        projectVC.titles = arr
        projectVC.projectData = self.dataArray
        var next:UIView? = self
        repeat{
            if let nextResponder = next?.next, nextResponder.isKind(of: UIViewController.self) {
                let vc = nextResponder as! UIViewController
                vc.navigationController?.pushViewController(projectVC, animated: true)
                return
            }
            next = next?.superview
        } while next != nil
    }
}
