//
//  Terms2ViewController.swift
//  GGBB_re
//
//  Created by 송시온 on 15/05/2019.
//  Copyright © 2019 송시온. All rights reserved.
//

import UIKit
import WebKit

class Terms2ViewController: UIViewController
{
    @IBOutlet var webviewAreaView: UIView!
    var webView:WKWebView = WKWebView()
    var delegate: Terms2Delegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(webView)
        setAnchorToSafeArea(webView)
        
        let addr = "http://www.iloveggbb.com/agreement/agreement3.html"
        if let url = URL(string: addr)
        {
            let req = URLRequest(url: url)
            webView.load(req)
        }
    }
    
    private func setAnchorToSafeArea(_ newView:UIView)
    {
        newView.translatesAutoresizingMaskIntoConstraints = false
        
        if let guide = self.webviewAreaView
        {
            newView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
            newView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
            newView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
            newView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        }
    }
    
    @IBAction func agreeTerms(_ sender: Any) {
        delegate?.agreeTerms2(data: "success")
        self.navigationController?.popViewController(animated: true)
    }
}
