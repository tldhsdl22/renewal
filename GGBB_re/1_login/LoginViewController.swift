//
//  ViewController.swift
//  GGBB_re
//
//  Created by 송시온 on 2019. 4. 24..
//  Copyright © 2019년 송시온. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit
import Alamofire

class LoginViewController: UIViewController {
    
    @IBOutlet var loginKaKao: UIButton!
    @IBOutlet var loginFacebook: UIButton!
    @IBOutlet var loginCustom: UIButton!
    @IBOutlet var loginPass: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setBorder()
        buttonUnderLine()
        
        if(UserInfo.getUserName() != nil)
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "mainNav")
            self.show(vc, sender: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    
    private func buttonUnderLine()
    {
        let yourAttributes : [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.foregroundColor : UIColor.darkGray
        ]

        let attributeString = NSMutableAttributedString(string: "건너뛰기",
                                                        attributes: yourAttributes)
        loginPass.setAttributedTitle(attributeString, for: .normal)
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
                        if let _ = error as NSError? {
                            
                        } else if let me = me as KOUserMe? {
                            print("id: \(String(describing: me.id))")
                            print("nickname: \(String(describing: me.nickname))")
                            print("imgUrl: \(String(describing: me.thumbnailImageURL))")
                            
                            // 유저 정보 저장
                            UserInfo.setUserInfo(userId: me.id, name: me.nickname, thumb: me.thumbnailImageURL?.absoluteString)
                            
                            // 정상적인 값이면 페이지 이동
                            if(UserInfo.getUserName() != nil)
                            {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let vc = storyboard.instantiateViewController(withIdentifier: "mainNav")
                                self.show(vc, sender: nil)
                            }

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
                    let thumb = profile?.imageURL(forMode: .normal, size: CGSize(width: 300, height: 300))
                    UserInfo.setUserInfo(userId: profile?.userID, name: profile?.name, thumb: thumb?.absoluteString)
                    
                    // 페이지 이동
                    if(UserInfo.getUserName() != nil)
                    {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "mainNav")
                        self.show(vc, sender: nil)
                    }
                })
            }
        }
    }
    
    @IBAction func loginPass(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "mainNav")
        self.show(vc, sender: nil)
    }
    
    
    @IBAction func unwindToLogin(_ segue: UIStoryboardSegue){
        print("success logout")
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
