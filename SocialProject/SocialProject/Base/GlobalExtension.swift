//
//  ZYYGlobalExtension.swift
//  TyreProject
//
//  Created by ZYY on 2017/7/12.
//  Copyright © 2017年 ZYY. All rights reserved.
//

import Foundation
import UIKit

//MARK: - Notifications
extension Notification.Name {
    static let NOTIFICATION_RECIEVEORDER_REFRESH = Notification.Name("com.kunxugroup.SellerTyreProject.notification.name.orderrefresh") //订单刷新
}

// MARK: - UIStoryboard Extensions
extension UIStoryboard {
    enum StoryboardName: String {
        case main = "Main"
        case user = "LoginAndRegisterStoryboard"
        case connection = "ConnectionStoryboard"
        case dynamic = "DynamicStoryboard"
        case message = "Im"
        case discovery = "DiscoveryStoryboard"
        case mine = "MineStoryboard"
    }
    
    convenience init(name: StoryboardName) {
        self.init(name: name.rawValue, bundle: nil)
    }
    
    //根据类型实例化UIViewController的子类
    func initialize<T: UIViewController>(class: T.Type) -> T {
        let identifier = NSStringFromClass(`class`).components(separatedBy: ".").last!
        let vc = self.instantiateViewController(withIdentifier: identifier) as! T
        return vc
    }
}

// Mark: UILabel
extension UILabel {
    func initLabel(frame: CGRect, text: String, font: Float, color: UIColor, backgroundColor: UIColor) -> UILabel {
        self.frame = frame
        self.text = text
        self.textColor = color
        self.font = UIFont.systemFont(ofSize: CGFloat(font))
        self.backgroundColor = backgroundColor
        return self
    }
}

// MARK: UIButton
enum ButtonImagePosition : Int{
    case PositionTop = 0
    case Positionleft
    case PositionBottom
    case PositionRight
}

extension UIButton {
    func initButton(frame: CGRect, text: String, font: Float, color: UIColor, backgroundColor: UIColor) -> UIButton {
        self.frame = frame
        self.setTitle(text, for: UIControlState.normal)
        self.setTitleColor(color, for: UIControlState.normal)
        self.backgroundColor = backgroundColor
        self.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(font))
        return self
    }
    
    func setImageAndTitle(imageName:String,title:String,type:ButtonImagePosition,Space space:CGFloat)  {
        
        self.setTitle(title, for: .normal)
        if imageName.length > 0 {
            self.setImage(UIImage(named:imageName), for: .normal)
            
            let imageWith :CGFloat = (self.imageView?.frame.size.width)!;
            let imageHeight :CGFloat = (self.imageView?.frame.size.height)!;
            
            var labelWidth :CGFloat = 0.0;
            var labelHeight :CGFloat = 0.0;
            
            labelWidth = CGFloat(self.titleLabel!.intrinsicContentSize.width);
            labelHeight = CGFloat(self.titleLabel!.intrinsicContentSize.height);
            
            var  imageEdgeInsets :UIEdgeInsets = UIEdgeInsets();
            var  labelEdgeInsets :UIEdgeInsets = UIEdgeInsets();
            
            switch type {
            case .PositionTop:
                imageEdgeInsets = UIEdgeInsetsMake(-labelHeight - space/2.0, 0, 0, -labelWidth);
                labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-space/2.0, 0);
                break;
            case .Positionleft:
                imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
                labelEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
                break;
            case .PositionBottom:
                imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-space/2.0, -labelWidth);
                labelEdgeInsets = UIEdgeInsetsMake(-imageHeight-space/2.0, -imageWith, 0, 0);
                break;
            case .PositionRight:
                imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+space/2.0, 0, -labelWidth-space/2.0);
                labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith-space/2.0, 0, imageWith+space/2.0);
                break;
            }
            
            // 4. 赋值
            self.titleEdgeInsets = labelEdgeInsets;
            self.imageEdgeInsets = imageEdgeInsets;
        } else {
            self.setImage(nil, for: .normal)
            self.titleLabel?.textAlignment = .center;
        }
    }
    
    func setSelectedImageAndTitle(imageName:String,title:String,type:ButtonImagePosition,Space space:CGFloat)  {
        
        self.setTitle(title, for: .selected)
        self.setImage(UIImage(named:imageName), for: .selected)
        
        let imageWith :CGFloat = (self.imageView?.frame.size.width)!;
        let imageHeight :CGFloat = (self.imageView?.frame.size.height)!;
        
        var labelWidth :CGFloat = 0.0;
        var labelHeight :CGFloat = 0.0;
        
        labelWidth = CGFloat(self.titleLabel!.intrinsicContentSize.width);
        labelHeight = CGFloat(self.titleLabel!.intrinsicContentSize.height);
        
        var  imageEdgeInsets :UIEdgeInsets = UIEdgeInsets();
        var  labelEdgeInsets :UIEdgeInsets = UIEdgeInsets();
        
        switch type {
        case .PositionTop:
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight - space/2.0, 0, 0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-space/2.0, 0);
            break;
        case .Positionleft:
            imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
            break;
        case .PositionBottom:
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-space/2.0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight-space/2.0, -imageWith, 0, 0);
            break;
        case .PositionRight:
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+space/2.0, 0, -labelWidth-space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith-space/2.0, 0, imageWith+space/2.0);
            break;
        }
        
        // 4. 赋值
        self.titleEdgeInsets = labelEdgeInsets;
        self.imageEdgeInsets = imageEdgeInsets;
    }
}

// MARK: - String Extensions
extension String {
    //字符串长度
    var length: Int {
        return self.characters.count
    }
    var trim: String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    //MD5编码
    var md5Hashed: String {
        let trimmedString = lowercased().trimmingCharacters(in: .whitespaces)
        let utf8String = trimmedString.cString(using: .utf8)!
        let stringLength = CC_LONG(trimmedString.lengthOfBytes(using: .utf8))
        let digestLength = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLength)
        CC_MD5(utf8String, stringLength, result)
        var hash: String = ""
        for i in 0..<digestLength {
            hash += String(format: "%02x", result[i])
        }
        result.deallocate(capacity: digestLength)
        return String(format: hash)
    }
    //DES加密
    var desEncoded: String {
        let nsstring = self as NSString
        let encodingStr = nsstring.encoding(withDESKey: DES_KEY) as String
        return encodingStr
    }
}

extension String {
    // 验证邮箱格式
    static func validateEmail(emailString: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: emailString)
    }
    
    // 验证手机号格式
    static func validateMobile(mobileString: String) -> Bool {
        let mobileRegEx = "^1([34578]\\d{9}$)"
        let predicate = NSPredicate(format: "SELF MATCHES %@", mobileRegEx)
        return predicate.evaluate(with: mobileString)
    }
    
    // 验证登录密码格式（6-16位字母加数字）
    func checkPWDValid() -> Bool {
        let psRegex = "^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,16}"
        let predicate = NSPredicate.init(format: "SELF MATCHES %@", psRegex)
        if predicate.evaluate(with: self) == true {
            return true
        }
        return false
    }
    
    // 设置手机号格式132****2222形式
    func replacePhoneStr() -> String {
        if self.isEmpty || self.length == 0 {
            return ""
        }
        var mobileStr = self
        mobileStr.replaceSubrange(mobileStr.index(mobileStr.startIndex, offsetBy: 3)..<mobileStr.index(mobileStr.startIndex, offsetBy: 7), with: "****")
        return mobileStr
    }
    
    func checkPointsCount() -> Bool {
        let arr = self.components(separatedBy: ".")
        if arr.count > 2 {
            return true
        }
        return false
    }
    
    // 日期格式化 “yyyy-mm-dd HH:mm:ss”
    static func dataToString(dateStr:String, format:String) -> String {
        var date:Date? = nil
        date = Date(timeIntervalSince1970: Double(dateStr)!)
        let dataFormate:DateFormatter = DateFormatter()
        dataFormate.dateFormat = format
        return dataFormate.string(from: date!)
    }
    
    static func getTextHeigh(textStr:String,font:UIFont,width:CGFloat) -> CGFloat {
        let normalText:String = textStr
        let size = CGSize(width: width, height: CGFloat(MAXFLOAT))
        let dic = NSDictionary(object: font, forKey: NSAttributedStringKey.font as NSCopying)
        let stringSize = normalText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedStringKey : AnyObject], context:nil).size
        return stringSize.height
    }
    
    func changeTextColor(textStr:String,rang:NSRange,color:UIColor) -> NSMutableAttributedString {
        let attrStr:NSMutableAttributedString = NSMutableAttributedString(string: textStr)
        attrStr.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: rang)
        return attrStr
    }
}

// MARK: - Date Extensions
extension Date {
    var dateString: String {
        return dateString(with: "yyyy-MM-dd")
    }
    var timeString: String {
        return dateString(with: "HH:mm:ss")
    }
    
    func dateString(with format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

// MARK: - UIColor Extensions
extension UIColor {
    // 通过十六进制获取颜色
    class func colorWithHex(_ hex: String) -> UIColor {
        let hexString = hex.trimmingCharacters(in: .whitespaces).uppercased()
        let nsHexString = hexString.replacingOccurrences(of: "#", with: "") as NSString
        if nsHexString.length == 6 {
            let rString = nsHexString.substring(with: NSMakeRange(0, 2)) as String
            let gString = nsHexString.substring(with: NSMakeRange(2, 2)) as String
            let bString = nsHexString.substring(with: NSMakeRange(4, 2)) as String
            
            var r: UInt32 = 0, g: UInt32 = 0, b: UInt32 = 0
            Scanner(string: rString).scanHexInt32(&r)
            Scanner(string: gString).scanHexInt32(&g)
            Scanner(string: bString).scanHexInt32(&b)
            
            if #available(iOS 10.0, *) {
                return UIColor(displayP3Red: CGFloat(Float(r)/Float(UInt8.max)), green: CGFloat(Float(g)/Float(UInt8.max)), blue: CGFloat(Float(b)/Float(UInt8.max)), alpha: 1.0)
            } else {
                // Fallback on earlier versions
                return UIColor(red: CGFloat(Float(r)/Float(UInt8.max)), green: CGFloat(Float(g)/Float(UInt8.max)), blue: CGFloat(Float(b)/Float(UInt8.max)), alpha: 1.0)
            }
        }
        return .clear
    }
}

// MARK: - UIImage Extensions
extension UIImage {
    // 通过颜色构造图片
    class func imageWith(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    // 通过颜色构造按钮背景图片
    class func btnBackgroundImage(_ color: UIColor, cornerRadius: CGFloat = 4, isStroked: Bool = false) -> UIImage {
        let innerWith: CGFloat = 10
        let rect = CGRect(x: 0, y: 0, width: cornerRadius * 2 + innerWith, height: cornerRadius * 2 + innerWith)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()!
        if isStroked {
            let lineWidth: CGFloat = 0.5
            context.addPath(UIBezierPath(roundedRect: rect.insetBy(dx: lineWidth, dy: lineWidth), cornerRadius: cornerRadius).cgPath)
            context.setLineWidth(lineWidth)
            context.setStrokeColor(color.cgColor)
            context.strokePath()
        } else {
            context.addPath(UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath)
            context.setFillColor(color.cgColor)
            context.fillPath()
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        let insets = UIEdgeInsets(top: cornerRadius + innerWith/2,
                                  left: cornerRadius + innerWith/2,
                                  bottom: cornerRadius + innerWith/2,
                                  right: cornerRadius + innerWith/2)
        let resizedImage = image.resizableImage(withCapInsets: insets, resizingMode: .stretch)
        UIGraphicsEndImageContext()
        return resizedImage
    }
}

// MARK: - UIImageView Extensions
extension UIImageView {
    // 圆角
    @IBInspectable
    var cornerRadius: CGFloat {
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = newValue > 0
        }
        get {
            return self.layer.cornerRadius
        }
    }
    // 是否是圆形
    @IBInspectable
    var isRounded: Bool {
        set {
            cornerRadius = newValue ? min(self.bounds.width, self.bounds.height) / 2 : 0
        }
        get {
            return self.layer.cornerRadius == min(self.bounds.width, self.bounds.height) / 2
        }
    }
}

// MARK: - UIViewController Extensions
extension UIViewController {
    private struct AssociatedKeys {
        static var _indicatorView: UIActivityIndicatorView?
        static var _blurHUD: ZYYBlurHUD?
    }
    
//    // 登录
//    func loginAction() {
//        if self.isKind(of: ZYYLoginController.self) {
//            return
//        }
//        let loginVC = UIStoryboard(name: .user).initialize(class: ZYYLoginController.self)
//        let navc = ZYYBaseNavigationController(rootViewController: loginVC)
//        self.present(navc, animated: true, completion: nil)
//    }
    
    // 这里有什么涵义呢？get方法中转圈圈,set方法中取消转圈圈？
    fileprivate var indicatorView: UIActivityIndicatorView? {
        get {
            guard let obj = objc_getAssociatedObject(self, &AssociatedKeys._indicatorView) as? UIActivityIndicatorView else {
                return nil
            }
            return obj
        }
        set {
            guard let _ = newValue else {
                objc_removeAssociatedObjects(self)
                return
            }
            objc_setAssociatedObject(self, &AssociatedKeys._indicatorView, newValue as UIActivityIndicatorView?, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate var blurHUD: ZYYBlurHUD? {
        get {
            guard let obj = objc_getAssociatedObject(self, &AssociatedKeys._blurHUD) as? ZYYBlurHUD else {
                return nil
            }
            return obj
        }
        set {
            guard let _ = newValue else {
                objc_removeAssociatedObjects(self)
                return
            }
            objc_setAssociatedObject(self, &AssociatedKeys._blurHUD, newValue as ZYYBlurHUD?, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    enum ZYYBlurHUDResult: String {
        case success
        case warning
        case failure
        
        var image: UIImage {
            return UIImage(named: self.rawValue)!
        }
        
        var hideAfterSeconds: Double {
            switch self {
            case .success:
                return 1.5
            default:
                return 2.5
            }
        }
    }
    
    // 显示加载模态框
    func showBlurHUD(title: String = "努力加载中...", message: String? = nil, isUserInteractionEnabled: Bool = true) {
        if self.blurHUD == nil {
            self.blurHUD = ZYYBlurHUD(style: .dark, parentView: UIApplication.shared.keyWindow!)
        }
        self.blurHUD!.isUserInteractionEnabled = isUserInteractionEnabled
        self.blurHUD!.title = title
        self.blurHUD!.message = message
        self.blurHUD?.showWithAnimation()
    }
    
    // 使用模态框显示结果
    func showBlurHUD(result: ZYYBlurHUDResult, title: String? = nil, message: String? = nil, isUserInteractionEnabled: Bool = true, competion: (() -> Void)? = nil) {
        if self.blurHUD == nil {
            self.blurHUD = ZYYBlurHUD(style: .dark, parentView: UIApplication.shared.keyWindow!)
        }
        self.blurHUD!.isUserInteractionEnabled = isUserInteractionEnabled
        self.blurHUD!.title = title
        self.blurHUD!.message = message
        self.blurHUD!.showWithImage(image: result.image, hideAfterSeconds: result.hideAfterSeconds, completion: competion)
    }
    
    // 隐藏模态框
    func hideBlurHUD(completion: (() -> Void)? = nil) {
        self.blurHUD?.hideWithAnimation(completion: completion)
    }
    
    // 页面开始加载动画，用于加载网络请求
    func startLoading() {
        if self.indicatorView == nil {
            self.indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
            self.indicatorView!.center = CGPoint(x: DEVICE_WIDTH/2, y: DEVICE_HEIGHT/2)
            self.indicatorView!.color = UIColor.white
            self.view.addSubview(self.indicatorView!)
        }
        self.view.bringSubview(toFront: self.indicatorView!)
        self.indicatorView?.startAnimating()
    }
    
    // 停止页面加载动画
    func stopLoading() {
        self.indicatorView?.hidesWhenStopped = true
        self.indicatorView?.stopAnimating()
    }
    
    func setStatusBarBackgroundColor(color : UIColor) {
        let statusBarWindow : UIView = UIApplication.shared.value(forKey: "statusBarWindow") as! UIView
        let statusBar : UIView = statusBarWindow.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = color
        }
    }
}

extension UITableViewController {
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.indicatorView?.center.x = self.tableView.center.x - self.tableView.contentInset.left
        self.indicatorView?.center.y = self.tableView.center.y - self.tableView.contentInset.top
    }
}

extension UINavigationController: UINavigationControllerDelegate {
    @discardableResult
    func popToViewControllerAt(_ index: Int, animated: Bool) -> [UIViewController]? {
        guard index >= 0 && index < self.viewControllers.count else {
            return nil
        }
        return self.popToViewController(self.viewControllers[index], animated: animated)
    }
    
}
