//
//  StoreInfoViewController.swift
//  GGBB_re
//
//  Created by 송시온 on 07/05/2019.
//  Copyright © 2019 송시온. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class StoreInfoViewController:UIViewController
{
    fileprivate var pagesVC: [UIViewController]!
    fileprivate var pageTabBarVC : TabBarController!
    var titleList: [String] = ["정보", "가격", "블로그"]

    @IBOutlet var bottomMenuLineView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pagesVC = preparePages()
        pageTabBarVC = preparePageController(pagesVC)
        
        // 탭바 뷰
        let newView = pageTabBarVC.view!
        newView.backgroundColor = .red
        self.view.addSubview(newView)
        setAnchorToSafeArea(newView)
        self.addChild(pageTabBarVC)
    }
}


// MainVC TabBar Setting
extension StoreInfoViewController {
    fileprivate func preparePages() -> [UIViewController]{
        var pagesVC = [UIViewController]()
        for title in titleList
        {
            switch(title)
            {
            case "정보":
                let newPage = createStoreInfoPage(title:title)
                pagesVC.append(newPage)
                break
            case "가격":
                let newPage = createPricePage(title:title)
                pagesVC.append(newPage)
            case "블로그":
                let newPage = createBlogPage(title: title)
                pagesVC.append(newPage)
            default:
                break
            }
        }
        
        return pagesVC
    }
    
    // 스토어 정보 페이지
    fileprivate func createStoreInfoPage(title:String) -> UIViewController{
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "StoreInfoPageViewController") as! StoreInfoPageViewController
        vc.itemInfo = IndicatorInfo(title:title)
        return vc
    }
    
    // 가격표 페이지
    fileprivate func createPricePage(title:String) -> UIViewController{
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PricePageViewController") as! PricePageViewController
        vc.itemInfo = IndicatorInfo(title:title)
        return vc
    }
    
    
    // 블로그 웹뷰페이지
    fileprivate func createBlogPage(title:String) -> UIViewController{
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BlogPageViewController") as! BlogPageViewController
        vc.itemInfo = IndicatorInfo(title:title)
        return vc
    }
    
    
    fileprivate func preparePageController(_ pagesVC: [UIViewController]) -> TabBarController{
        let tabVC = TabBarController()
        tabVC.contentsVC = pagesVC
        
        return tabVC
    }
    
    
    private func setAnchorToSafeArea(_ newView:UIView)
    {
        newView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            let guide = self.view.safeAreaLayoutGuide
            newView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
            newView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
            newView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
            newView.bottomAnchor.constraint(equalTo: bottomMenuLineView.topAnchor).isActive = true
        } else {
            NSLayoutConstraint(item: newView,
                               attribute: .top,
                               relatedBy: .equal,
                               toItem: view, attribute: .top,
                               multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: newView,
                               attribute: .leading,
                               relatedBy: .equal, toItem: view,
                               attribute: .leading,
                               multiplier: 1.0,
                               constant: 0).isActive = true
            NSLayoutConstraint(item: newView, attribute: .trailing,
                               relatedBy: .equal,
                               toItem: view,
                               attribute: .trailing,
                               multiplier: 1.0,
                               constant: 0).isActive = true
            NSLayoutConstraint(item: newView, attribute: .bottom,
                               relatedBy: .equal,
                               toItem: bottomMenuLineView,
                               attribute: .top,
                               multiplier: 1.0,
                               constant: 0).isActive = true
        }
    }
}
