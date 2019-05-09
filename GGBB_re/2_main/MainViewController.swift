//
//  ViewController.swift
//  GGBB_re
//
//  Created by 송시온 on 2019. 4. 24..
//  Copyright © 2019년 송시온. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class MainViewController: UIViewController {
    fileprivate var pagesVC: [UIViewController]!
    fileprivate var pageTabBarVC : TabBarController!
    var titleList: [String] = ["먹자", "놀자", "자자", "하하", "케케"]
    
    @IBOutlet var sideMenuWidth: NSLayoutConstraint!
    @IBOutlet var sideMenuView: UIView!
    @IBOutlet var innerView: UIView!
    @IBOutlet var navItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setNavigationBar()
        
        preparePages()
        preparePageController()
        
        /*
        self.view.addSubview(pageTabBarVC.view)
        
        pageTabBarVC.view.topAnchor.constraint(equalTo: self.view.topAnchor)
        pageTabBarVC.view.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        pageTabBarVC.view.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        pageTabBarVC.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        */
        self.edgesForExtendedLayout = []//Optional our as per your view ladder
 
        let newView = pageTabBarVC.view!
        newView.backgroundColor = .red
        self.view.addSubview(newView)
        newView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            let guide = self.view.safeAreaLayoutGuide
            newView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
            newView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
            newView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
            newView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
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
                               toItem: view,
                               attribute: .bottom,
                               multiplier: 1.0,
                               constant: 0).isActive = true
        }
        
        self.view.layoutIfNeeded()
        self.view.bringSubviewToFront(sideMenuView)
    }
    
    public func setNavigationBar()
    {
        let titleImageView = UITextView(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
        titleImageView.text = "test"
        self.navigationController?.navigationItem .titleView = titleImageView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickButton01(_ sender: Any) {
        sideMenuWidth.constant = 0
    }
    
    @IBAction func clickButton02(_ sender: Any) {
        sideMenuWidth.constant = 0
    }
    
    @IBAction func showMainPage(_ sender: Any) {
        if(sideMenuWidth.constant > 0)
        {
            sideMenuWidth.constant = 0
        }
        else
        {
            sideMenuWidth.constant = 200
        }
        
        UIView.animate(withDuration: 0.2, delay:0, animations: {
                self.view.layoutIfNeeded()
            })
    }
}

// MainVC TabBar Setting
extension MainViewController {
    fileprivate func preparePages() {
        pagesVC = [UIViewController]()
        for title in titleList
        {
            let newPage = createStoreThumbViewController(title:title)
            pagesVC.append(newPage)
        }
    }
    
    fileprivate func createStoreThumbViewController(title:String) -> UIViewController{
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "StoreThumbViewController") as! StoreThumbViewController
        vc.itemInfo = IndicatorInfo(title:title)
        return vc
    }
    
    fileprivate func preparePageController(){
        pageTabBarVC = TabBarController()
        pageTabBarVC.contentsVC = pagesVC
    }
}
