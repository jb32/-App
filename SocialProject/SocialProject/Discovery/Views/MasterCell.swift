//
//  MasterCell.swift
//  SocialProject
//
//  Created by Mac on 2018/8/18.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit

class MasterCell: UITableViewCell {
    @IBOutlet weak var nicknameLabel: UILabel!
    
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var headImgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
