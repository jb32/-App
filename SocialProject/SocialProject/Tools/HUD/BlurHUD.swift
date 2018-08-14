//
//  ZYYBlurHUD.swift
//  TyreProject
//
//  Created by ZYY on 2017/7/13.
//  Copyright © 2017年 ZYY. All rights reserved.
//

import UIKit

class ZYYBlurHUD: UIView {

    //MARK: Constant
    private let seperate: CGFloat = 10.0
    private let cornerRadius: CGFloat = 5.0
    private let minimumSize: CGSize = CGSize(width: 120, height: 100)
    private let padding: UIEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    private let margin: UIEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
    
    //MARK: - UI Control Properties
    private let parentView: UIView!
    private let blurView: UIView!
    private let blurContentView: UIView!
    private let blurBackgroundView: ZYYBlurView!
    private let indicator: UIActivityIndicatorView! = {
        let indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    private let imageView: UIImageView! = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
    }()
    private let titleLabel: UILabel! = {
        let titleLabel: UILabel = UILabel()
        titleLabel.numberOfLines = 1
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    private let messageLabel: UILabel! = {
        let messageLabel: UILabel = UILabel()
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont.systemFont(ofSize: 11)
        messageLabel.backgroundColor = UIColor.clear
        messageLabel.textColor = .white
        messageLabel.textAlignment = .center
        return messageLabel
    }()
    
    //MARK: - Calculate Properties
    var style: UIBlurEffectStyle {
        return self.blurBackgroundView.style
    }
    var contentColor: UIColor {
        set {
            self.titleLabel.textColor = newValue
            self.messageLabel.textColor = newValue
            self.indicator.color = newValue
            if let image = self.imageView.image {
                self.imageView.image = redrawImage(image, tintColor: newValue)
            }
        }
        get {
            return self.titleLabel.textColor
        }
    }
    var title: String? {
        get {
            return titleLabel.text
        }
        set {
            fitSizeByLabel(titleLabel, text: newValue)
            blurView.frame = calcHUDFrame()
        }
    }
    var message: String? {
        get {
            return messageLabel.text
        }
        set {
            fitSizeByLabel(messageLabel, text: newValue)
            blurView.frame = calcHUDFrame()
        }
    }
    var isShowing: Bool {
        func isViewOnSuperView(_ view: UIView, superView: UIView) -> Bool {
            guard let superview = view.superview else {
                return false
            }
            return superview == superView
        }
        return isViewOnSuperView(self, superView: parentView)
    }
    
    //MARK: - Life Cycle
    init(style: UIBlurEffectStyle, parentView: UIView) {
        self.blurBackgroundView = ZYYBlurView(style: style)
        self.blurContentView = UIView()
        self.blurView = UIView()
        self.parentView = parentView
        super.init(frame: CGRect.zero)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.blurBackgroundView = ZYYBlurView(style: .dark)
        self.blurContentView = UIView()
        self.blurView = UIView()
        self.parentView = (UIApplication.shared.delegate?.window)!
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        switch self.style {
        case .dark:
            self.contentColor = UIColor.white.withAlphaComponent(0.95)
        default:
            self.contentColor = UIColor.darkText.withAlphaComponent(0.95)
        }
        
        blurView.addSubview(blurBackgroundView)
        blurView.addSubview(blurContentView)
        
        blurContentView.addSubview(indicator)
        blurContentView.addSubview(imageView)
        blurContentView.addSubview(titleLabel)
        blurContentView.addSubview(messageLabel)
        
        addSubview(blurView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        blurView.frame = { [unowned self] in
            self.blurView.layer.cornerRadius = self.cornerRadius
            self.blurView.layer.masksToBounds = true
            return self.calcHUDFrame()
            }()
        blurBackgroundView.frame = blurView.bounds
        blurContentView.frame = blurView.bounds
        indicator.center = CGPoint(x: blurContentView.bounds.midX, y: (blurContentView.bounds.height - calcHUDContentSize().height)/2 + indicator.frame.height/2)
        titleLabel.center = CGPoint(x: blurContentView.bounds.midX, y: indicator.frame.maxY + seperate + titleLabel.bounds.midY)
        messageLabel.center = CGPoint(x: blurContentView.bounds.midX, y: titleLabel.frame.maxY + seperate/2 + messageLabel.bounds.midY)
        imageView.frame = indicator.frame
    }
    
    //MARK: - Public Functions
    func showWithAnimation() {
        prepareToShow()
        indicator.startAnimating()
        imageView.image = nil
    }
    
    func showWithImage(image: UIImage, hideAfterSeconds: Double = 0, completion: (() -> Void)? = nil) {
        prepareToShow()
        indicator.stopAnimating()
        imageView.image = redrawImage(image, tintColor: self.titleLabel.textColor)
        DispatchQueue.main.asyncAfter(deadline: .now() + hideAfterSeconds) {
            self.hideWithAnimation(completion: completion)
        }
    }
    
    func hideWithAnimation(completion: (() -> Void)? = nil) {
        prepareToHide()
        indicator.stopAnimating()
        UIView.animate(withDuration: 0.25, animations: {
            self.blurView.alpha = 0
        }) { (finish: Bool) in
            self.cleanup()
            completion?()
        }
    }
    
    //MARK: - Private Functions
    private func redrawImage(_ image: UIImage, tintColor: UIColor) -> UIImage {
        let imageBounds = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        UIGraphicsBeginImageContextWithOptions(image.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(tintColor.cgColor);
        context.fill(imageBounds)
        image.draw(in: imageBounds, blendMode: .destinationIn, alpha: 1.0)
        let redrawImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return redrawImage
    }
    
    private func fitSizeByLabel(_ label: UILabel, text: String?) {
        let maxLabelWidth = parentView.frame.width - margin.left - margin.right - padding.left - padding.right
        let maxLabelHeight = parentView.frame.height - margin.top - margin.bottom - padding.top - padding.bottom
        label.text = text
        label.frame.size = label.sizeThatFits(CGSize(width: maxLabelWidth, height: maxLabelHeight))
        label.center.x = self.blurView.bounds.midX
        if label == self.titleLabel {
            label.frame.origin.y = self.indicator.frame.maxY + seperate
        } else if label == self.messageLabel {
            label.frame.origin.y = self.titleLabel.frame.maxY + seperate/2
        }
    }
    
    private func calcHUDContentSize() -> CGSize {
        var size = CGSize(width: indicator.bounds.width, height: indicator.bounds.height)
        if title != nil {
            size.width = max(size.width, titleLabel.bounds.width)
            size.height = size.height + seperate + titleLabel.bounds.height
            if (message) != nil {
                size.width = max(size.width, messageLabel.bounds.width)
                size.height = size.height + seperate/2 + messageLabel.bounds.height
            }
        } else {
            if (message) != nil {
                size.width = max(size.width, messageLabel.bounds.width)
                size.height = size.height + seperate + messageLabel.bounds.height
            }
        }
        return size
    }
    
    private func calcHUDFrame() -> CGRect {
        let maxSize: CGSize = CGSize(width: parentView.frame.width - margin.left - margin.right, height: parentView.frame.height - margin.top - margin.bottom)
        
        func calcHUDSize() -> CGSize {
            let contentSize = calcHUDContentSize()
            let maxWidth = max(contentSize.width + padding.left + padding.right, minimumSize.width)
            let maxHeight = max(contentSize.height + padding.top + padding.bottom, minimumSize.height)
            let hudSize = CGSize(width: min(maxSize.width, maxWidth), height: min(maxSize.height, maxHeight))
            return hudSize
        }
        
        func calcHUDOriginBySize(_ size: CGSize) -> CGPoint {
            let x: CGFloat = (parentView.frame.width - size.width)/2
            let y: CGFloat = (parentView.frame.height - size.height)/2
            return CGPoint(x: x, y: y)
        }
        
        let size: CGSize = calcHUDSize()
        let origin: CGPoint = calcHUDOriginBySize(size)
        return CGRect(origin: origin, size: size)
    }
    
    private func prepareToShow() {
        frame = parentView.bounds
        parentView.addSubview(self)
        
        self.blurView.alpha = 1.00
    }
    
    private func prepareToHide() {
        self.blurView.alpha = 1.00
    }
    
    private func cleanup() {
        removeFromSuperview()
    }
}

class ZYYBlurView: UIView {
    //MARK: - Private Properties
    private(set) var style: UIBlurEffectStyle!
    private let blurView: UIVisualEffectView!
    private let vibrancyView: UIVisualEffectView!
    
    var contentView: UIView {
        return blurView.contentView
    }
    
    //MARK: - Life Cycle
    init(style: UIBlurEffectStyle) {
        self.style = style
        let blurEffect = UIBlurEffect(style: style)
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        self.blurView = UIVisualEffectView(effect: blurEffect)
        self.vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        
        super.init(frame: .zero)
        
        self.blurView.contentView.addSubview(self.vibrancyView)
        self.addSubview(self.blurView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.style = .extraLight
        let blurEffect = UIBlurEffect(style: style)
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        self.blurView = UIVisualEffectView(effect: blurEffect)
        self.vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        
        super.init(coder: aDecoder)
        
        self.blurView.contentView.addSubview(self.vibrancyView)
        self.addSubview(self.blurView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        blurView.frame = self.bounds
        vibrancyView.frame = blurView.bounds
    }
    
    override func addSubview(_ view: UIView) {
        guard view != self.blurView else {
            super.addSubview(view)
            return
        }
        self.vibrancyView.contentView.addSubview(view)
    }
}
