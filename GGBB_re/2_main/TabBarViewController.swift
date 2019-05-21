//
//  TabBarViewController.swift
//  GGBB_re
//
//  Created by 송시온 on 03/05/2019.
//  Copyright © 2019 송시온. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class TabBarController: ButtonBarPagerTabStripViewController {
    var contentsVC:[UIViewController]!
    
    override func viewDidLoad() {
        prepareTabBar()
        
        super.viewDidLoad()
    }
    
    func prepareTabBar(){
        settings.style.buttonBarHeight = 45
        settings.style.buttonBarBackgroundColor = UIColor.white
        settings.style.buttonBarItemBackgroundColor = UIColor.white
        settings.style.selectedBarBackgroundColor = Util.AppColor
        
        settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 16, weight: .semibold) //UIFont(name: "System-Bold", size:16) ?? UIFont.systemFont(ofSize: 16)
        settings.style.selectedBarHeight = 3.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = Util.AppColor
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        
        // 왼쪽 오른쪽 남은공간
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .black
            newCell?.label.textColor = Util.AppColor
        }
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        if contentsVC == nil {
            contentsVC = [UIViewController]()
        }
        return contentsVC
    }
}
