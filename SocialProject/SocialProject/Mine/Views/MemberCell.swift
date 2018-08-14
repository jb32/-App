//
//  MemberCell.swift
//  SocialProject
//
//  Created by Mac on 2018/7/25.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit

class MemberCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var commonLabel: UILabel!
    @IBOutlet weak var VIPLabel: UILabel!
    @IBOutlet weak var diamondLabel: UILabel!
    @IBOutlet weak var crownLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
