//
//  PersonalInfoCell.swift
//  SocialProject
//
//  Created by Mac on 2018/7/27.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit

class PersonalInfoCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTF: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
