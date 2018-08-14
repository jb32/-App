//
//  DynamicCell.swift
//  SocialProject
//
//  Created by Mac on 2018/7/16.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit

class DynamicCell: UITableViewCell {

    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var transpondBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var collectBtn: UIButton!
    @IBOutlet weak var concernBtn: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImgView: UIImageView!
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
