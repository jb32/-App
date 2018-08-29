//
//  DescribtionListCell.swift
//  SocialProject
//
//  Created by Mac on 2018/8/27.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit

class DescribtionListCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var photoView: DescribtionPictureView!
    
    @IBOutlet weak var settingBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var model: DescribtionModel? {
        didSet {
            contentLabel.text = model?.content
            photoView.viewModel = model
            if model?.show == 1 {
                titleLabel.text = "主简介"
                settingBtn.isSelected = true
                settingBtn.isUserInteractionEnabled = false
            } else {
                titleLabel.text = "普通简介"
                settingBtn.isSelected = false
                settingBtn.isUserInteractionEnabled = true
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
