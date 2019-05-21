//
//  PricePageViewController.swift
//  GGBB_re
//
//  Created by 송시온 on 15/05/2019.
//  Copyright © 2019 송시온. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class PricePageViewController: UIViewController
{
    public var itemInfo = IndicatorInfo(title: "")

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension PricePageViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PricePageCell") as? PricePageCell
            else {
            return UITableViewCell()
        }
        
        return cell
    }
}

extension PricePageViewController: IndicatorInfoProvider  {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}

class PricePageCell: UITableViewCell
{
    
}
