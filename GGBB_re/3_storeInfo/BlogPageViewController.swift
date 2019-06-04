//
//  NaverBlog.swift
//  GGBB_re
//
//  Created by 송시온 on 15/05/2019.
//  Copyright © 2019 송시온. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import WebKit

class BlogPageViewController: UIViewController
{
    public var itemInfo = IndicatorInfo(title: "")

    var webView: WKWebView!
    var query: String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        webView = WKWebView()
        self.view.addSubview(webView)
        setAnchorToSafeArea(webView)
        
        let encodedQuery =
            query?.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
        
        var blogUrl =  "https://m.search.naver.com/search.naver?where=m_view&sm=mtb_jum&query=" + encodedQuery

        loadUrl(blogUrl ?? "https://m.search.naver.com/")
    }
    
    func loadUrl(_ addr:String)
    {
        if let url = URL(string: addr)
        {
            let req = URLRequest(url: url)
            webView.load(req)
        }
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
}

extension BlogPageViewController: IndicatorInfoProvider  {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
