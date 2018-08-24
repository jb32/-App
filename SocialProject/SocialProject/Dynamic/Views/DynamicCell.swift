//
//  DynamicCell.swift
//  SocialProject
//
//  Created by Mac on 2018/7/16.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit

class DynamicCell: UITableViewCell {

    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var transpondBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var collectBtn: UIButton!
    @IBOutlet weak var concernBtn: UIButton!
    @IBOutlet weak var photoView: StatusPictureView!
    
    var model: DynamicModel? {
        didSet {
            nameLabel.text = model?.nickname
            avatarImgView.setWebImage(with: Image_Path+(model?.headImg)!, placeholder: UIImage(named: "dynamic_avatar_boy"))
            timeLabel.text = model?.createtime
            contentLabel.text = model?.comment
            likeBtn.setTitle("点赞"+(model?.praselen)!, for: .normal)
            transpondBtn.setTitle("转发"+(model?.forwardlen)!, for: .normal)
            collectBtn.setTitle("收藏"+(model?.collectionlen)!, for: .normal)
            photoView.viewModel = model
        }
    }
    
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

class StatusPictureView: UIView {
    var viewModel: DynamicModel? {
        didSet{
            calcViewSize()
            var picURLs: [String] = []
            let arr = viewModel?.image.components(separatedBy: ",")
            for url in arr! {
                if url.length > 0 {
                    picURLs.append(Image_Path+url)
                }
            }
            //设置微博视图的url（被转发和原创）
            urls = picURLs
        }
    }
    //根据配图视图的大小调整显示内容
    fileprivate func calcViewSize(){
        //处理宽度
        var picURLs: [String] = []
        let arr = viewModel?.image.components(separatedBy: ",")
        for url in arr! {
            if url.length > 0 {
                picURLs.append(Image_Path+url)
            }
        }
        
        if picURLs.count == 1{//a.单图，根据配图视图的大小修改subViews[0]的宽度
            let v = subviews[0]
            v.frame = CGRect(x: 0, y: PictureOutMargin, width: DEVICE_WIDTH - 75, height: 120)
            picviewHeight.constant = 120
        } else {//b.多图，恢复subviews[0]的宽度，保证九宫格布局完整
            let v = subviews[0]
            v.frame = CGRect(x: 0, y: PictureOutMargin, width: PicWidth, height: PicWidth)
            let pictureSize = calcuPictureViewSize(count: picURLs.count)
            //修改高度
            picviewHeight.constant = pictureSize.height
        }
    }
    
    fileprivate func calcuPictureViewSize(count: Int?) -> CGSize {
        
        if  count == 0 || count == nil {
            return CGSize()
        }
        //1.计算高度
        //1>计算行数 根据count计算行数 1-9
        /**
         1 2 3 - 1 = 0 1 2 / 3 = 0 + 1 =1
         4 5 6 - 1 = 3 4 5 / 3 = 1 + 1 =2
         7 8 9 - 1 = 6 7 8 / 3 = 2 + 1 =3
         */
        let row = (count! - 1) / 3 + 1
        
        var height: CGFloat = 0.0
        height = CGFloat(row) * PicWidth + height
        height = CGFloat(row - 1) * PictureInMargin + height
        return CGSize(width: PictureViewWidth, height: height)
    }
    
    
    fileprivate var urls: [String]? {
        didSet{
            //1.隐藏所有的imageView
            for v in subviews {
                v.isHidden = true
            }
            //2.遍历urls 数组，顺序设置图像
            var index = 0
            for url in urls ?? [] {
                //获得对应索引的imageView
                let iv = subviews[index] as! UIImageView
                //4张图像的处理
                if index == 1 && urls?.count == 4 {
                    index += 1
                }
                //设置图像
                iv.setWebImage(with: url, placeholder: nil)
                //判断是否 gif
                iv.subviews[0].isHidden = (((url ?? "") as NSString).pathExtension.lowercased() != "gif")
                iv.isHidden = false
                index += 1
            }
        }
    }
    
    @IBOutlet weak var picviewHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        setupUI()
    }
    
    //MARK:手机监听方法
    @objc fileprivate func tapImageView(tap: UITapGestureRecognizer){
        
        var picURLs: [String] = []
        let arr = viewModel?.image.components(separatedBy: ",")
        for url in arr! {
            if url.length > 0 {
                picURLs.append(Image_Path+url)
            }
        }
        guard let iv = tap.view else{
            return
            
        }
        
        var selectedIndex = iv.tag
        
        //针对四张图处理
        if picURLs.count == 4 && selectedIndex > 1 {
            selectedIndex -= 1
        }
        //处理可见的图像视图数组
        var imageViewList = [UIImageView]()
        for iv in subviews as! [UIImageView] {
            if !iv.isHidden {
                imageViewList.append(iv)
            }
        }
        
        //发送通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: StautsCellBrowserPhotoNotification),
                                        object: self,
                                        userInfo: [ StatusCellBrowserPhotoURLsKey: urls,
                                                    StatusCellBrowserPhotoSelectedIndexKey: selectedIndex,
                                                    StatusCellBrowserPhotoImageViewsKey:imageViewList
            ])
    }
    
}

extension StatusPictureView{
    //1.cell中所有的控件都是提前准备好
    //2.设置的时候，根据数据决定是否显示
    //3.不要动态创建控件
    fileprivate func setupUI(){
        
        
        //设置背景颜色
        backgroundColor = superview?.backgroundColor
        
        //超出边界的内容不显示
        clipsToBounds = true
        
        let count = 3
        let rect = CGRect(x: 0,
                          y: PictureOutMargin,
                          width: PicWidth,
                          height: PicWidth)
        
        for i in 0..<count * count {
            
            let iv = UIImageView()
            //设置contenrMode
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            //行
            let row = CGFloat(i / count)
            //列
            let col = CGFloat(i % count)
            
            let xOffset = col * (PicWidth + PictureInMargin)
            
            let yOffset = row * (PicWidth + PictureInMargin)
            
            iv.frame = rect.offsetBy(dx: xOffset, dy: yOffset)
            
            addSubview(iv)
            
            //让imageView能够接收用户交互
            iv.isUserInteractionEnabled = true
            //添加手势识别
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapImageView))
            iv.addGestureRecognizer(tap)
            //设置imageView的tag
            iv.tag = i
            
            addGifView(iv: iv)
        }
    }
    
    //向图像视图添加gif提示图像
    fileprivate func addGifView(iv: UIImageView){
        
        let gifImageView = UIImageView(image: UIImage(named: "timeline_image_gif"))
        iv.addSubview(gifImageView)
        
        //自动布局
        gifImageView.translatesAutoresizingMaskIntoConstraints = false
        
        //右边
        iv.addConstraint(NSLayoutConstraint(item: gifImageView,
                                            attribute: .right,
                                            relatedBy: .equal,
                                            toItem: iv,
                                            attribute: .right,
                                            multiplier: 1.0,
                                            constant: 0))
        //下边
        iv.addConstraint(NSLayoutConstraint(item: gifImageView,
                                            attribute: .bottom,
                                            relatedBy: .equal,
                                            toItem: iv,
                                            attribute: .bottom,
                                            multiplier: 1.0,
                                            constant: 0))
        
    }
    
}
