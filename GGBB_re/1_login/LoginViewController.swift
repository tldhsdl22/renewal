//
//  ViewController.swift
//  GGBB_re
//
//  Created by 송시온 on 2019. 4. 24..
//  Copyright © 2019년 송시온. All rights reserved.
//

import UIKit
import FBSDKLoginKit


class LoginViewController: UIViewController {
    
    @IBOutlet var loginKaKao: UIButton!
    @IBOutlet var loginFacebook: UIButton!
    @IBOutlet var loginCustom: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setBorder()
    }
    
    private func setBorder()
    {
        loginKaKao.layer.cornerRadius = 5
        loginFacebook.layer.cornerRadius = 5
        
        loginCustom.layer.borderWidth = 1.0
        loginCustom.layer.borderColor = UIColor.lightGray.cgColor
        loginCustom.layer.cornerRadius = 5

        
        //login4.layer.addBorder([.top, .bottom, .left, .right], color: UIColor.gray, width: 1.0, radius: 10)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func kakaoLogin(_ sender: Any) {
        if let session = KOSession.shared() {
            session.close()
            session.open(completionHandler: { (error) in
                if session.isOpen() == true {
                    //self.getUserInfoFromKakaoTalk()
                    
                    KOSessionTask.signupTask(withProperties: nil, completionHandler: { (success, error) in
                        if(success) {
                            print("success")
                        }
                        else {
                            print("fail")
                        }
                    })
                    //userMeTaskWithCompletion
                    KOSessionTask.userMeTask(completion: { (error, me) in
                        if let error = error as NSError? {
                            
                        } else if let me = me as KOUserMe? {
                            print("id: \(String(describing: me.id))")
                            print("nickname: \(String(describing: me.nickname))")
                            print("imgUrl: \(String(describing: me.thumbnailImageURL))")
                        } else {
                            print("has no id")
                        }
                    })
                }
                else {
                    print("oepn Error: \(error!)")
                }
            })
        }
    }
    
    @IBAction func facebookLogin(_ sender: Any) {
        
        let loginManager = LoginManager()
        loginManager.logIn(permissions: [.publicProfile], viewController: self) { (LoginResult) in
            switch LoginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("user cancelled login")
            case .success(granted: _, declined: _, token: _): // 로그인 성공
                print("login")
                
                //  프로필 가져오기
                Profile.loadCurrentProfile(completion: {(profile, error) in
                    print(profile?.name)
                    print(profile?.userID)
                    
                    var thumb:FBProfilePictureView = FBProfilePictureView()
                    thumb.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
                    thumb.profileID = profile?.userID ?? ""
                    
                    self.view.addSubview(thumb)
                    
                })
            }
        }
    }
}

extension CALayer {
    func addBorder(_ arr_edge: [UIRectEdge], color: UIColor, width: CGFloat, radius: CGFloat) {
        for edge in arr_edge {
            let border = CALayer()
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
                break
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
                break
            case UIRectEdge.right:
                border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
                break
            default:
                break
            }
            //border.cornerRadius = radius
            border.backgroundColor = color.cgColor;
            self.addSublayer(border)
        }
    }
}
