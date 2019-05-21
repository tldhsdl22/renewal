//
//  File.swift
//  GGBB_re
//
//  Created by 송시온 on 14/05/2019.
//  Copyright © 2019 송시온. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class StoreInfoPageViewController: UIViewController
{
    public var itemInfo = IndicatorInfo(title: "")

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func showReview(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "StoreReviewViewController")
        
        
        self.show(vc!, sender: self.parent)
    }
}

extension StoreInfoPageViewController: IndicatorInfoProvider  {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
