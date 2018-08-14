//
//  ContactCell.swift
//  SocialProject
//
//  Created by 薛 靖博 on 2018/8/10.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var addBtn: UIButton?
    @IBOutlet weak var cancelBtn: UIButton?
    var toAdd: (() -> Void)?
    var toCancel: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func doAdd(_ sender: UIButton) {
        toAdd?()
    }
    
    @IBAction func doCancel(_ sender: UIButton) {
        toCancel?()
    }
}
