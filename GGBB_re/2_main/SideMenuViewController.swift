//
//  SideMenuViewController.swift
//  GGBB_re
//
//  Created by 송시온 on 13/05/2019.
//  Copyright © 2019 송시온. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController
{
    @IBOutlet var leftAnchor: NSLayoutConstraint!
    @IBOutlet var sideMenuWidth: NSLayoutConstraint!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var profileName: UILabel!
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var scrapView: UIView!
    @IBOutlet var requestView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenuWidth.constant = self.view.frame.width * 3 / 4
        leftAnchor.constant = -sideMenuWidth.constant
        
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        
        addViewClickAction()
        
        loadProfile()
        
        attachClickEvent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        slideAnimate()
    }
    
    private func attachClickEvent()
    {
        // 스크랩 이동
        let scrap_gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goScrap))
        scrap_gesture.numberOfTapsRequired = 1
        scrapView?.isUserInteractionEnabled = true
        scrapView?.addGestureRecognizer(scrap_gesture)
        
        
        // 문의하기 이동
        let request_gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goRequest))
        request_gesture.numberOfTapsRequired = 1
        requestView?.isUserInteractionEnabled = true
        requestView?.addGestureRecognizer(request_gesture)
    }
    
    @objc private func goScrap()
    {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ScrapViewController") as? ScrapViewController
        {
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (result) in
                self.presentingViewController?.show(vc, sender: self.presentingViewController)
                self.leftAnchor.constant = -self.sideMenuWidth.constant
                
                self.dismiss(animated: false, completion: nil)
            })
        }
    }
    
    @objc private func goRequest()
    {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "RequestViewController") as? RequestViewController
        {
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (result) in
                self.presentingViewController?.show(vc, sender: self.presentingViewController)
                self.leftAnchor.constant = -self.sideMenuWidth.constant
                
                self.dismiss(animated: false, completion: nil)
            })
        }
    }
    
    private func loadProfile()
    {
        let name = UserInfo.getUserName() as String?
        let thumb = UserInfo.getUserThumb() as String?
        
        if(name != nil)
        {
            btnLogin.setTitle("로그아웃", for: .normal)
            
            if(name != nil && name != "")
            {
                profileName.text = name!
            }

            
            if(thumb != nil && thumb != "")
            {
                let url = URL(string: thumb!)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                    
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self.profileImage.image = UIImage(data: data!)
                    }
                }).resume()
            }
        }
    }
    
    func slideAnimate()
    {
        leftAnchor.constant = 0

        UIView.animate(withDuration: 0.5, delay:0, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    private func dismissCustom()
    {
        leftAnchor.constant = -sideMenuWidth.constant
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        }, completion: { (result) in
            self.dismiss(animated: false, completion: nil)
        })

    }
    
    // 여백 공간 누르면 닫히기
    @IBOutlet var emptyArea: UIView!
    func addViewClickAction()
    {
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(checkAction(sender:)))
        self.emptyArea.addGestureRecognizer(gesture)
    }

    @objc func checkAction(sender : UITapGestureRecognizer) {
        dismissCustom()
    }
    
    @IBAction func clickCloseBtn(_ sender: Any) {
        dismissCustom()
    }
    
    @IBAction func logout(_ sender: Any) {
        UserInfo.clearUserInfo()
        
        self.performSegue(withIdentifier: "unwindToLogin", sender: self)
    }
    
    @IBAction func clickMainBtn(_ sender: Any) {
        dismissCustom()
    }
}
