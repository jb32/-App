//
//  UICollectionViewUtils.swift
//  JBReader
//
//  Created by 薛 靖博 on 2018/4/12.
//  Copyright © 2018年 薛 靖博. All rights reserved.
//

import UIKit
import MJRefresh

extension UICollectionView {
    func registerCell<T: UICollectionViewCell>(type: T.Type) {
        register(type, forCellWithReuseIdentifier: "\(type)")
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: "\(type)", for: indexPath) as! T
    }
    
    func registerHeader<T: UICollectionReusableView>(type: T.Type) {
        register(type, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "\(type)")
    }
    
    func dequeueReusableHeader<T: UICollectionReusableView>(type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "\(type)", for: indexPath) as! T
    }
    
    func registerFooter<T: UICollectionReusableView>(type: T.Type) {
        register(type, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "\(type)")
    }
    
    func dequeueReusableFooter<T: UICollectionReusableView>(type: T.Type, for indexPath: IndexPath) -> T {
        
        return dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "\(type)", for: indexPath) as! T
    }
}

extension UICollectionView {
    func addMJHeader(_ begin: @escaping () -> Void) -> Void {
        mj_header = MJRefreshNormalHeader(refreshingBlock: {
            begin()
        })
    }
    
    func addMJFooter(_ begin: @escaping () -> Void) -> Void {
        mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            begin()
        })
    }
    
    func noMoreData() -> Void {
        mj_footer?.endRefreshingWithNoMoreData()
    }
    
    func resetMoreData() -> Void {
        mj_footer?.resetNoMoreData()
    }
    
    func refresh() -> Void {
        guard let header = mj_header, !header.isRefreshing else { return }
        guard let footer = mj_footer, !footer.isRefreshing else { return }
        header.beginRefreshing()
    }
    
    func loadMore() -> Void {
        guard let footer = mj_footer, !footer.isRefreshing else { return }
        guard let header = mj_header, !header.isRefreshing else { return }
        footer.beginRefreshing()
    }
    
    func stopReload() -> Void {
        if let header = mj_header, header.isRefreshing {
            header.endRefreshing()
        }
        
        if let footer = mj_footer, footer.isRefreshing {
            footer.endRefreshing()
        }
    }
}




