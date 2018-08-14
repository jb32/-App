//
//  UITableView_Ext.swift
//  Mishu
//
//  Created by JG on 2017/7/27.
//  Copyright © 2017年 jgms. All rights reserved.
//

import UIKit
import MJRefresh

extension UITableView {
    func registerCell<T: UITableViewCell>(type: T.Type) {
        register(type, forCellReuseIdentifier: "\(type)")
    }
    
    func dequeueReusableCell<T: UITableViewCell>(type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: "\(type)", for: indexPath) as! T
    }
    
    func register<T: UITableViewHeaderFooterView>(headerFooter type: T.Type) -> Void {
        register(type, forHeaderFooterViewReuseIdentifier: "\(type)")
    }
    
    func dequeueReusable<T: UITableViewHeaderFooterView>(headerFooter type: T.Type) -> T {
        return dequeueReusableHeaderFooterView(withIdentifier: "\(type)") as! T
    }
}

extension UITableView {
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


