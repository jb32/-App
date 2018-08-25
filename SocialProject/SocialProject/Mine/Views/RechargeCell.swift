//
//  ZYYRechargeCell.swift
//  TyreProject
//
//  Created by ZYY on 2017/7/25.
//  Copyright © 2017年 ZYY. All rights reserved.
//

import UIKit

class ZYYRechargeCell: UITableViewCell {

    @IBOutlet weak var rechargeImgView: UIImageView!
    @IBOutlet weak var rechargeTitleLabel: UILabel!
    @IBOutlet weak var rechargeDesciptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
