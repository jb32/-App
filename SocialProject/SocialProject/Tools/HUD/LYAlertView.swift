//
//  LYAlertView.swift
//  LYFootballLottery
//
//  Created by Tsz on 2017/2/14.
//  Copyright © 2017年 Tsz. All rights reserved.
//

import UIKit

private let alertViewWidth: CGFloat = 270
private let padding = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
private let seperate: CGFloat = 5
private let lineHeight: CGFloat = 0.5
private let buttonHeight: CGFloat = 44
private let cornerRadius: CGFloat = 15

private let maxButtonCount: Int = 5
private let maxAlertViewHeight: CGFloat = DEVICE_HEIGHT - 50 * 2
private let maxTitleHeight: CGFloat = 60

private let contentAlpha: CGFloat = 0.66


enum LYAlertActionStyle: Int {
    case `default` = 0
    case cancel = -1
    case destructive = 1
}

class LYAlertButton: UIButton {
    var style: LYAlertActionStyle
    var action: ((String) -> Void)?
    
    init(style: LYAlertActionStyle, action: ((String) -> Void)? = nil) {
        self.style = style
        self.action = action
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.style = .default
        self.action = nil
        super.init(coder: aDecoder)
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let touchPoint = touch.location(in: self)
        let containsTouch = self.bounds.contains(touchPoint)
        self.isHighlighted = containsTouch
        return containsTouch
    }
}

class LYAlertView: UIView {
    
    //MARK: - Storage Properties
    //MARK: Private
    private lazy var alertBackgroundView: UIView = {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        return blur
    }()
    private lazy var alertView: UIView = {
        let alertView = UIView()
        alertView.layer.cornerRadius = cornerRadius
        alertView.layer.masksToBounds = true
        return alertView
    }()
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = UIColor.white.withAlphaComponent(contentAlpha)
        return contentView
    }()
    private lazy var scrollView: UIScrollView = {
        let contentScrollView = UIScrollView()
        contentScrollView.backgroundColor = UIColor.clear
        return contentScrollView
    }()
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.textColor = UIColor.darkText
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    private lazy var messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont.systemFont(ofSize: 13)
        messageLabel.textColor = UIColor.darkText
        messageLabel.backgroundColor = UIColor.clear
        messageLabel.textAlignment = .center
        return messageLabel
    }()
    private var buttons: [LYAlertButton] = []
    
    //MARK: Public
    var isEnableAutoDismiss: Bool = true
    var accessoryView: UIView? = nil {
        didSet {
            if let accessoryView = self.accessoryView {
                accessoryView.frame.origin = CGPoint(x: 0, y: 0)
                accessoryView.frame.size.width = min(accessoryView.frame.width, alertViewWidth - padding.left - padding.right)
            }
            self.updateSubviewsFrame()
        }
    }
    
    override var tintColor: UIColor! {
        didSet {
            self.buttons.forEach { [unowned self] (btn) in
                btn.tintColor = self.tintColor
                if btn.style != .destructive {
                    btn.setTitleColor(btn.tintColor, for: .normal)
                    btn.setTitleColor(btn.tintColor, for: .highlighted)
                }
            }
        }
    }
    
    //MARK: - Calculate Properties
    //MARK: Public
    var title: String {
        get {
            return self.titleLabel.text ?? ""
        }
        set {
            self.titleLabel.text = newValue
        }
    }
    var message: String? {
        get {
            return self.messageLabel.text
        }
        set {
            self.messageLabel.text = newValue
        }
    }
    
    //MARK: - Life Cycle
    convenience init(title: String, message: String? = nil) {
        self.init(frame: .zero)
        self.title = title
        self.message = message
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateSubviewsFrame()
    }
    
    //MARK: - Custom Event
    private func updateSubviewsFrame() {
        self.alertView.frame.size = self.calcAlertSize()
        self.alertView.frame.origin = CGPoint(x: (DEVICE_WIDTH - alertViewWidth)/2, y: (DEVICE_HEIGHT - self.alertView.frame.height)/2)
        self.alertBackgroundView.frame = self.alertView.bounds
        
        var btnsHeight: CGFloat = 0
        if self.buttons.count <= 0 {
            btnsHeight = 0
        } else if self.buttons.count > 0 && self.buttons.count <= 2 {
            btnsHeight = buttonHeight + lineHeight
            if self.buttons.count == 1 {
                let first = self.buttons.first!
                first.frame = CGRect(x: 0, y: self.alertView.frame.height - buttonHeight, width: alertViewWidth, height: buttonHeight)
            } else {
                let first = self.buttons.first!
                let second = self.buttons.last!
                second.frame = CGRect(x: 0, y: self.alertView.frame.height - buttonHeight, width: (alertViewWidth - lineHeight)/2, height: buttonHeight)
                second.superview?.bringSubview(toFront: first)
                first.frame = CGRect(x: second.frame.maxX + lineHeight, y: second.frame.minY, width: (alertViewWidth - lineHeight)/2, height: buttonHeight)
                first.superview?.bringSubview(toFront: second)
            }
        } else {
            btnsHeight = (buttonHeight + lineHeight) * CGFloat(self.buttons.count)
            for (index, btn) in self.buttons.enumerated() {
                btn.frame = CGRect(x: 0, y: self.alertView.frame.height - btnsHeight + lineHeight + (buttonHeight + lineHeight) * CGFloat(index), width: alertViewWidth, height: buttonHeight)
                btn.superview?.bringSubview(toFront: btn)
            }
        }
        let limitMaxHeight = maxAlertViewHeight - btnsHeight - padding.top - padding.bottom
        
        var titleLabelHeight: CGFloat = 0
        var messageLabelHeight: CGFloat = 0
        var accessoryHeight: CGFloat = 0
        
        titleLabelHeight = self.titleLabel.sizeThatFits(CGSize(width: alertViewWidth - padding.left - padding.right, height: limitMaxHeight)).height
        guard titleLabelHeight < limitMaxHeight else {
            self.contentView.frame = CGRect(x: 0, y: 0, width: self.alertView.bounds.width, height: self.alertView.bounds.height - btnsHeight)
            self.titleLabel.frame = CGRect(x: padding.left, y: padding.top, width: self.alertView.bounds.width - padding.left - padding.right, height: titleLabelHeight)
            self.scrollView.frame = .zero
            self.scrollView.contentSize = .zero
            self.messageLabel.frame = .zero
            self.accessoryView?.frame = .zero
            return
        }
        if self.message != nil && self.message != "" {
            messageLabelHeight = self.messageLabel.sizeThatFits(CGSize(width: alertViewWidth - padding.left - padding.right, height: CGFloat.greatestFiniteMagnitude)).height
        }
        if let accessoryView = self.accessoryView {
            accessoryHeight = accessoryView.frame.height
        }
        let contentHeight = messageLabelHeight + seperate + accessoryHeight
        guard contentHeight > seperate else {
            self.contentView.frame = CGRect(x: 0, y: 0, width: self.alertView.bounds.width, height: self.alertView.bounds.height - btnsHeight)
            self.titleLabel.frame = CGRect(x: padding.left, y: padding.top, width: self.alertView.bounds.width - padding.left - padding.right, height: titleLabelHeight)
            self.scrollView.frame = .zero
            self.scrollView.contentSize = .zero
            self.messageLabel.frame = .zero
            self.accessoryView?.frame = .zero
            return
        }
        let totalHeight = titleLabelHeight + seperate + messageLabelHeight + seperate + accessoryHeight
        guard totalHeight < limitMaxHeight else {
            self.contentView.frame = CGRect(x: 0, y: 0, width: self.alertView.bounds.width, height: self.alertView.bounds.height - btnsHeight)
            self.titleLabel.frame = CGRect(x: padding.left, y: padding.top, width: self.alertView.bounds.width - padding.left - padding.right, height: titleLabelHeight)
            self.scrollView.frame = CGRect(x: 0, y: self.titleLabel.frame.maxY + seperate, width: self.alertView.bounds.width, height: limitMaxHeight - titleLabelHeight - seperate)
            self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: messageLabelHeight + seperate + accessoryHeight)
            self.messageLabel.frame = CGRect(x: padding.left, y: 0, width: self.scrollView.frame.width - padding.left - padding.right, height: messageLabelHeight)
            self.accessoryView?.frame = CGRect(x: padding.left, y: self.messageLabel.frame.maxY + seperate, width: self.scrollView.frame.width - padding.left - padding.right, height: accessoryHeight)
            return
        }
        self.contentView.frame = CGRect(x: 0, y: 0, width: self.alertView.bounds.width, height: self.alertView.bounds.height - btnsHeight)
        self.titleLabel.frame = CGRect(x: padding.left, y: padding.top, width: self.alertView.bounds.width - padding.left - padding.right, height: titleLabelHeight)
        self.scrollView.frame = CGRect(x: 0, y: self.titleLabel.frame.maxY + seperate, width: self.alertView.bounds.width, height: messageLabelHeight + seperate + accessoryHeight)
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: self.scrollView.frame.height)
        self.messageLabel.frame = CGRect(x: padding.left, y: 0, width: self.scrollView.frame.width - padding.left - padding.right, height: messageLabelHeight)
        self.accessoryView?.frame = CGRect(x: padding.left, y: self.messageLabel.frame.maxY + seperate, width: self.scrollView.frame.width - padding.left - padding.right, height: accessoryHeight)
    }
    
    private func calcAlertSize() -> CGSize {
        var btnsHeight: CGFloat = 0
        if self.buttons.count <= 0 {
            btnsHeight = 0
        } else if self.buttons.count > 0 && self.buttons.count <= 2 {
            btnsHeight = buttonHeight + lineHeight
        } else {
            btnsHeight = (buttonHeight + lineHeight) * CGFloat(self.buttons.count)
        }
        let limitMaxHeight = maxAlertViewHeight - btnsHeight - padding.top - padding.bottom
        
        var titleLabelHeight: CGFloat = 0
        var messageLabelHeight: CGFloat = 0
        var accessoryHeight: CGFloat = 0

        titleLabelHeight = self.titleLabel.sizeThatFits(CGSize(width: alertViewWidth - padding.left - padding.right, height: limitMaxHeight)).height
        guard titleLabelHeight < limitMaxHeight else {
            return CGSize(width: alertViewWidth, height: btnsHeight + (padding.top + padding.bottom + titleLabelHeight))
        }
        if self.message != nil && self.message != "" {
            messageLabelHeight = self.messageLabel.sizeThatFits(CGSize(width: alertViewWidth - padding.left - padding.right, height: CGFloat.greatestFiniteMagnitude)).height
        }
        if let accessoryView = self.accessoryView {
            accessoryHeight = accessoryView.frame.height
        }
        let contentHeight = messageLabelHeight + seperate + accessoryHeight
        guard contentHeight > seperate else {
            return CGSize(width: alertViewWidth, height: btnsHeight + (padding.top + padding.bottom + titleLabelHeight))
        }
        let totalHeight = titleLabelHeight + seperate + messageLabelHeight + seperate + accessoryHeight
        guard totalHeight < limitMaxHeight else {
            return CGSize(width: alertViewWidth, height: btnsHeight + (padding.top + padding.bottom + limitMaxHeight))
        }
        return CGSize(width: alertViewWidth, height: btnsHeight + (padding.top + padding.bottom + totalHeight))
    }
    
    private func imageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    @objc private func handleBtnAction(_ sender: LYAlertButton) {
        sender.action?(sender.currentTitle ?? "")
        if self.isEnableAutoDismiss {
            self.dismiss()
        }
    }
    
    //MAKR: - Public Functions
    func addAlertAction(with title: String, style: LYAlertActionStyle, action: ((String) -> Void)? = nil) {
        if self.buttons.count < maxButtonCount {
            let btn = LYAlertButton(style: style, action: action)
            btn.setTitle(title, for: .normal)
            switch style {
            case .default:
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
                btn.setTitleColor(self.tintColor, for: .normal)
                btn.setTitleColor(self.tintColor, for: .highlighted)
            case .cancel:
                btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
                btn.setTitleColor(self.tintColor, for: .normal)
                btn.setTitleColor(self.tintColor, for: .highlighted)
            case .destructive:
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
                btn.setTitleColor(UIColor.red, for: .normal)
                btn.setTitleColor(UIColor.red, for: .highlighted)
            }
            btn.setBackgroundImage(self.imageWithColor(UIColor.white.withAlphaComponent(contentAlpha)), for: .normal)
            btn.setBackgroundImage(self.imageWithColor(UIColor.white.withAlphaComponent(contentAlpha/2.0)), for: .highlighted)
            btn.addTarget(self, action: #selector(self.handleBtnAction(_:)), for: .touchUpInside)
            self.buttons.append(btn)
        }
        self.buttons.sort { (btn1, btn2) -> Bool in
            switch btn1.style {
            case .default:
                return true
            case .cancel:
                switch btn2.style {
                case .default:
                    return false
                case .cancel:
                    return true
                case .destructive:
                    return false
                }
            case .destructive:
                switch btn2.style {
                case .default:
                    return false
                case .cancel:
                    return true
                case .destructive:
                    return true
                }
            }
        }
    }
    
    func removeAlertAction(by title: String) {
        for (index, btn) in self.buttons.enumerated() {
            if btn.currentTitle == title {
                self.buttons.remove(at: index)
                break
            }
        }
    }
    
    func show() {
        guard self.buttons.count > 0 else {
            return
        }
        
        self.addSubview(self.alertView)
        self.alertView.addSubview(self.alertBackgroundView)
        self.alertView.addSubview(self.contentView)
        self.buttons.forEach { [unowned self] (btn) in
            self.alertView.addSubview(btn)
        }
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.scrollView)
        self.scrollView.addSubview(self.messageLabel)
        if let accessoryView = self.accessoryView { self.scrollView.addSubview(accessoryView) }
        
        self.frame = CGRect(x: 0, y: 0, width: DEVICE_WIDTH, height: DEVICE_HEIGHT)
        
        let keyWindow = UIApplication.shared.keyWindow
        keyWindow?.isMultipleTouchEnabled = false
        keyWindow?.addSubview(self)
        
        self.alertView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        self.backgroundColor = .clear
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.99, initialSpringVelocity: 10, options: [.beginFromCurrentState, .curveEaseOut], animations: {
            self.alertView.transform = .identity
            self.backgroundColor = UIColor.black.withAlphaComponent(0.33)
        })
    }
    
    func dismiss() {
        self.alertView.alpha = 1
        self.backgroundColor = UIColor.black.withAlphaComponent(0.33)
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [.beginFromCurrentState, .curveEaseIn], animations: {
            self.alertView.alpha = 0
            self.backgroundColor = .clear
        }) { (finished) in
            if let accessoryView = self.accessoryView { accessoryView.removeFromSuperview() }
            self.messageLabel.removeFromSuperview()
            self.scrollView.removeFromSuperview()
            self.titleLabel.removeFromSuperview()
            self.contentView.removeFromSuperview()
            self.buttons.forEach { (btn) in btn.removeFromSuperview() }
            self.alertBackgroundView.removeFromSuperview()
            self.alertView.removeFromSuperview()
            self.removeFromSuperview()
            
            self.buttons.removeAll()
            
            let keyWindow = UIApplication.shared.keyWindow
            keyWindow?.isMultipleTouchEnabled = true
        }
    }
}
