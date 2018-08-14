//
//  JBPageMenuView.swift
//  AtlasEnergy
//
//  Created by 薛 靖博 on 2018/7/16.
//  Copyright © 2018年 JB. All rights reserved.
//

import UIKit

protocol JBPageMenuProtocol {
    /// 点击菜单，联动页面
    var toSelected: ((Int) -> Void)? { get set }
    /// 滑动页面，联动菜单
    ///
    /// - Parameter index: index
    func go(_ index: Int) -> Void
}

class JBPageMenuView: UIScrollView, JBPageMenuProtocol {
    
    private var items = [UIButton]()
    
    var selectedColor = UIColor.red
    var normalColor = UIColor.black
    var itemWidth: CGFloat = 180
    var itemHeight: CGFloat = 44
    var toSelected: ((Int) -> Void)?
    
    var titleArr: [String]? {
        didSet {
            guard let titleArr = titleArr else { return }
            
            items.forEach { $0.removeFromSuperview() }
            items.removeAll()
            
            for (index, item) in titleArr.enumerated() {
                let btn = UIButton(type: .custom)
                
                btn.setTitle(item, for: .normal)
                btn.setTitleColor(selectedColor, for: .selected)
                btn.setTitleColor(normalColor, for: .normal)
                btn.addTarget(self, action: #selector(doSelect(_:)), for: .touchUpInside)
                btn.tag = index
                addSubview(btn)
                items.append(btn)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() -> Void {
        isDirectionalLockEnabled = true
        scrollsToTop = false
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        backgroundColor = .clear
    }
    
    @objc func doSelect(_ sender: UIButton) {
        go(sender.tag)
        toSelected?(sender.tag)
    }
    
    func go(_ index: Int) {
        
        for (i, item) in items.enumerated() {
            if i == index {
                item.isSelected = true
            } else {
                item.isSelected = false
            }
        }
        
        if items.count <= index || contentSize.width < frame.width {
            return
        }
        
        if index == items.count - 1 && index != 0 {
            setContentOffset(CGPoint(x: contentSize.width - frame.width + contentInset.right, y: 0), animated: true)
        } else {
            let btn = items[index]
            let tabExcept = DEVICE_HEIGHT - btn.frame.width
            let tabPadding = tabExcept / 2.0
            let offsetX = max(0, min(btn.frame.minX - tabPadding, items.last?.frame.minX ?? 0 - tabExcept))
            setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        itemWidth = frame.width / CGFloat(items.count)
        
        for (index, item) in items.enumerated() {
            item.frame = CGRect(x: itemWidth * CGFloat(index), y: 0, width: itemWidth, height: itemHeight)
        }
    }
}

extension JBPageMenuView {
    class Item: UIButton {
        private var selectedColor = UIColor.clear
        private var normalColor = UIColor.clear
        
        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
    }
}
