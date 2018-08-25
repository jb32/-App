//
//  ZYYAllDetailTableViewCell.swift
//  TyreProject
//
//  Created by 黄小超 on 2017/7/27.
//  Copyright © 2017年 ZYY. All rights reserved.
//

import UIKit

class ZYYAllDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var detailTypeImageView: UIImageView!
    @IBOutlet weak var detailTypeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
