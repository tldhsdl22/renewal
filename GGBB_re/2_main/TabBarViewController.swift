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
        settings.style.buttonBarBackgroundColor = Util.ColorMint
        settings.style.buttonBarItemBackgroundColor = Util.ColorMint
        settings.style.selectedBarBackgroundColor = Util.ColorOrange
        
        settings.style.buttonBarItemFont = UIFont(name: "System-system", size:14) ?? UIFont.systemFont(ofSize: 14)
        settings.style.selectedBarHeight = 3.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = Util.ColorOrange
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        
        settings.style.buttonBarLeftContentInset = 20
        settings.style.buttonBarRightContentInset = 20
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .white
            newCell?.label.textColor = Util.ColorOrange
        }
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        if contentsVC == nil {
            contentsVC = [UIViewController]()
        }
        return contentsVC
    }
}
