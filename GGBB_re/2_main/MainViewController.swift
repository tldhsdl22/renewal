//
//  ViewController.swift
//  GGBB_re
//
//  Created by 송시온 on 2019. 4. 24..
//  Copyright © 2019년 송시온. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire

class MainViewController: UIViewController {
    fileprivate var pagesVC: [UIViewController]!
    fileprivate var pageTabBarVC : TabBarController!
    
    var typeList:[(key: String, value: Int)]?
    var categories:[String:[String]] = [:]
    
    @IBOutlet var navItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 데이터 초기화
        var tmpList = ["먹자":10, "놀자":20, "자자":30, "쇼핑":40, "지하상가":50]
        typeList = tmpList.sorted(by: { (aDic, bDic) -> Bool in
            return aDic.value < bDic.value
            })
        
        //먹자 - 전체, 한식, 일식, 중식, 양식, 카페, 주점, 기타
        //자자 - 호텔, 모텔, 펜션

        categories["먹자"] = ["전체", "한식", "일식",  "중식", "양식", "카페", "주점", "기타"]
        categories["자자"] = ["전체", "호텔", "모텔", "펜션"]
        
        print(typeList)
        
        //setNavigationBar()
        
        preparePages()
        preparePageController()

        
        // 탭바 뷰
        let newView = pageTabBarVC.view!
        newView.backgroundColor = .red
        self.view.addSubview(newView)
        setAnchorToSafeArea(newView)
        self.addChild(pageTabBarVC)
        
        // 사이드 메뉴 앞으로 보이게 하기
        //self.view.bringSubviewToFront(sideMenuView)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadViewIfNeeded()
    }

    
    private func setAnchorToSafeArea(_ newView:UIView)
    {
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
    
    @IBAction func showSlideMenu(_ sender: Any) {
        //let vc = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuViewController") as? SideMenuViewController
        //vc?.modalPresentationStyle = .overCurrentContext
        //vc?.modalTransitionStyle = UIModalTransitionStyle.
//        vc?.modalPresentationStyle = .currentContext
        //vc.modalPresentationStyle = .currentContext
        //vc?.modalPresentationStyle = .overFullScreen

        

        //self.present(vc!, animated: false, completion: nil)
    }
    
    @IBAction func goGMapVC(_ sender: Any) {
        let storyboard = UIStoryboard(name: "GMap", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GmapViewController")
        self.show(vc, sender: self)
    }
    
}

// MainVC TabBar Setting
extension MainViewController {
    fileprivate func preparePages() {
        pagesVC = [UIViewController]()
        for type in typeList!
        {
            let newPage = createStoreThumbViewController(title:type.0, type:type.1, categories: categories[type.0])
            pagesVC.append(newPage)
        }
    }
    
    fileprivate func createStoreThumbViewController(title:String, type:Int, categories:[String]?) -> UIViewController{
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "StoreThumbViewController") as! StoreThumbViewController
        vc.storeType = type
        vc.itemInfo = IndicatorInfo(title:title)
        vc.categoryList = categories
        return vc
    }
    
    fileprivate func preparePageController(){
        pageTabBarVC = TabBarController()
        pageTabBarVC.contentsVC = pagesVC
    }
}
