//
//  JBPageController.swift
//  AtlasEnergy
//
//  Created by 薛 靖博 on 2018/7/16.
//  Copyright © 2018年 JB. All rights reserved.
//

import UIKit

class JBPageController: UIPageViewController {
    
    fileprivate var currentIndex = 0
    var dataArr: [UIViewController]?
    
    fileprivate var menu: JBPageMenuProtocol?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        delegate = self
        dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
    }

    func set(dataArr: [UIViewController], defalut index: Int) -> Void {
        guard dataArr.count - 1 >= index else {
            return
        }
        self.dataArr = dataArr
        currentIndex = index
        setViewControllers([dataArr[index]], direction: .forward, animated: true, completion: nil)
    }
    
    func set(index: Int) -> Void {
        guard let dataArr = dataArr, dataArr.count - 1 >= index else {
            return
        }
        setViewControllers([dataArr[index]], direction: .forward, animated: true, completion: nil)
        synchMenu(index)
    }
    
    func sync(_ menu: JBPageMenuProtocol) -> Void {
        self.menu = menu
        self.menu?.toSelected = { [weak self] (index) in
            guard let `self` = self else { return }
            guard let dataArr = self.dataArr, index < dataArr.count && index >= 0 else { return }
            
            if self.currentIndex > index {
                self.setViewControllers([dataArr[index]], direction: .reverse, animated: true, completion: nil)
            } else {
                self.setViewControllers([dataArr[index]], direction: .forward, animated: true, completion: nil)
            }
            self.currentIndex = index
        }
        synchMenu()
    }
    
    fileprivate func synchMenu(_ index: Int? = nil) -> Void {
        
        if let index = index {
            currentIndex = index
            menu?.go(index)
        } else {
            menu?.go(currentIndex)
        }
    }
    
    fileprivate func before() -> UIViewController? {
        if let dataArr = dataArr, currentIndex > 0 {
            return dataArr[currentIndex - 1]
        }
        return nil
    }
    
    fileprivate func after() -> UIViewController? {
        if let dataArr = dataArr, dataArr.count - 1 > currentIndex {
            return dataArr[currentIndex + 1]
        }
        return nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension JBPageController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return before()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return after()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let vc = viewControllers?.last, let dataArr = dataArr, completed {
            let index = dataArr.index(of: vc)
            synchMenu(index)
        }
    }
}






