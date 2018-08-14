//
//  LYPieProgressView.swift
//  LYFootballLottery
//
//  Created by Tsz on 2017/1/11.
//  Copyright © 2017年 Tsz. All rights reserved.
//

import UIKit

class LYPieProgressView: UIView {

    var lineWidth: CGFloat = 1.0 {
        didSet {
            updatePieView()
        }
    }
    var pieRadius: CGFloat = 15.0 {
        didSet {
            self.bounds.size = CGSize(width: pieRadius * 2, height: pieRadius * 2)
            updatePieView()
        }
    }
    var pieInset: CGFloat = 3.0  {
        didSet {
            updatePieView()
        }
    }
    var color: UIColor! = UIColor.white.withAlphaComponent(0.75) {
        didSet {
            updatePieView()
        }
    }
    var hidesWhenFinished: Bool = true
    
    fileprivate lazy var borderLayer: CAShapeLayer = { [unowned self] in
        let lazyBorderLayer = CAShapeLayer()
        lazyBorderLayer.path = UIBezierPath.init(roundedRect: CGRect(x: self.lineWidth/2, y: self.lineWidth/2, width: self.bounds.width - self.lineWidth, height: self.bounds.height - self.lineWidth), cornerRadius: CGFloat(self.pieRadius) - self.lineWidth/2).cgPath
        lazyBorderLayer.lineWidth = self.lineWidth
        lazyBorderLayer.lineCap = kCALineCapRound
        lazyBorderLayer.lineJoin = kCALineJoinRound
        lazyBorderLayer.strokeColor = self.color.cgColor
        lazyBorderLayer.fillColor = UIColor.clear.cgColor
        lazyBorderLayer.strokeStart = 0
        lazyBorderLayer.strokeEnd = 1
        return lazyBorderLayer
    }()
    
    fileprivate lazy var pieLayer: CAShapeLayer = { [unowned self] in
        let innerPieRadius: CGFloat = (self.pieRadius - self.lineWidth/2 - self.pieInset)/2
        let lazyPieLayer = CAShapeLayer()
        lazyPieLayer.path = UIBezierPath(roundedRect: CGRect(x: self.lineWidth/2 + self.pieInset + innerPieRadius, y: self.lineWidth/2 + self.pieInset + innerPieRadius, width: innerPieRadius * 2, height: innerPieRadius * 2), cornerRadius: innerPieRadius).cgPath
        lazyPieLayer.lineWidth = innerPieRadius * 2
        lazyPieLayer.lineCap = kCALineCapButt
        lazyPieLayer.lineJoin = kCALineJoinRound
        lazyPieLayer.strokeColor = self.color.cgColor
        lazyPieLayer.fillColor = UIColor.clear.cgColor
        lazyPieLayer.strokeStart = 0
        lazyPieLayer.strokeEnd = 0
        return lazyPieLayer
    }()
    
    fileprivate(set) var progress: Double = 0.0;
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(borderLayer)
        layer.addSublayer(pieLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.addSublayer(borderLayer)
        layer.addSublayer(pieLayer)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.addSublayer(borderLayer)
        layer.addSublayer(pieLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.borderLayer.frame = self.bounds
        self.pieLayer.frame = self.bounds
    }
    
    //MARK: - Private Function
    private func updatePieView() {
        borderLayer.path = UIBezierPath(roundedRect: CGRect(x: lineWidth/2, y: lineWidth/2, width: self.bounds.width - lineWidth, height: self.bounds.height - lineWidth), cornerRadius: pieRadius - lineWidth/2).cgPath
        borderLayer.lineWidth = lineWidth
        borderLayer.strokeColor = color.cgColor
        
        let innerPieRadius: CGFloat = (pieRadius - lineWidth/2 - pieInset)/2
        self.pieLayer.path = UIBezierPath(roundedRect: CGRect(x: lineWidth/2 + pieInset + innerPieRadius, y: lineWidth/2 + pieInset + innerPieRadius, width: innerPieRadius * 2, height: innerPieRadius * 2), cornerRadius: innerPieRadius).cgPath
        self.pieLayer.lineWidth = innerPieRadius * 2
        self.pieLayer.strokeColor = self.color.cgColor
    }

    //MARK: - Public Function
    func setProgressWithAnimation(_ progress: Double) {
        self.isHidden = false
        self.pieLayer.strokeStart = 0
        self.pieLayer.strokeEnd = CGFloat(progress)
        self.progress = progress;
        
        if self.progress >= 1.0 {
            let time: TimeInterval = 0.3
            let delay = DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delay) {
                if self.hidesWhenFinished {
                    self.isHidden = true
                }
                self.pieLayer.strokeEnd = 0
                self.progress = 0
            }
        }
    }
}
