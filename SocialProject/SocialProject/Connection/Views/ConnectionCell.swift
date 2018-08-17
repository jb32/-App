//
//  ConnectionCell.swift
//  SocialProject
//
//  Created by Mac on 2018/7/16.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit

class ConnectionCell: UITableViewCell {
    @IBOutlet weak var avartarImgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var projectNameLabel: UILabel!
    
    @IBOutlet weak var concernBtn: UIButton!
    @IBOutlet weak var concernCountLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        concernBtn.layer.borderWidth = 1
        concernBtn.layer.borderColor = UIColor.themOneColor.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
