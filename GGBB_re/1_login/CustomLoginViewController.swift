//
//  CustomLoginViewController.swift
//  GGBB_re
//
//  Created by 송시온 on 16/05/2019.
//  Copyright © 2019 송시온. All rights reserved.
//

import UIKit
import Alamofire

class CustomLoginViewController: UIViewController
{
    @IBOutlet var inputId: UITextField!
    @IBOutlet var inputPw: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func login(_ sender: Any) {
        var params = Dictionary<String, Any>()
        params["id"] = inputId.text
        params["password"] = inputPw.text
        let url = "http://iloveggbb.com/app/login/login.php"
        
        Alamofire.request(url, method: .post, parameters: params, encoding:  URLEncoding(destination: .queryString)).responseJSON(
            completionHandler: { (response) in
                switch(response.result)
                {
                case .success(let data):
                    print(data)
                    if let _ = data as? NSDictionary
                    {
                        do
                        {
                            let jsonObj = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                            let classObj = try JSONDecoder().decode(ResultLogin.self, from: jsonObj)
                            if(classObj.result != nil && classObj.result == "success")
                            {
                                
                                // 데이터 저장
                                UserInfo.setUserInfo(loginInfo: classObj)
                                
                                // 페이지 이동
                                 let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                 if let vc = storyboard.instantiateViewController(withIdentifier: "mainNav") as? UINavigationController {
                                    self.show(vc, sender: nil)
                                 }
                            }
                            else
                            {
                                let alert = UIAlertController(title: "가입 실패", message: classObj.message, preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                        catch
                        {
                            print(error.localizedDescription)
                        }
                    }
                    break
                case .failure(let _):
                    break
                default:
                    break
                }
        })
        
    }
}
