//
//  ReferralsCell.swift
//  SocialProject
//
//  Created by Mac on 2018/7/25.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit

class ReferralsCell: UITableViewCell {
    @IBOutlet weak var headImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var straightLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var manageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
