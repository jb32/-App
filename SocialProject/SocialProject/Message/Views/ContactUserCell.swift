//
//  ContactUserCell.swift
//  SocialProject
//
//  Created by 薛 靖博 on 2018/8/13.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit

class ContactUserCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var idLB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class ContactTelCell: UITableViewCell {
    
}

class ContactSwitchCell: UITableViewCell {
    @IBOutlet weak var switchView: UISwitch!
    
}









