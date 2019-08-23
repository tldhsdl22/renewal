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
        
        orgHeight = self.view.frame.height
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:
            UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    var orgHeight:CGFloat = 0
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            self.view.layoutIfNeeded()
            self.view.frame = CGRect(x: 0,y: 0, width: self.view.frame.width, height: self.orgHeight - keyboardSize.height)
            
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.layoutIfNeeded()
        self.view.frame = CGRect(x: 0,y: 0, width: self.view.frame.width, height: self.orgHeight)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
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


extension CustomLoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(textField == inputId)
        {
            inputPw.becomeFirstResponder()
            //inputPw.isFocused = true
        }
        else
        {
            textField.resignFirstResponder()
            login(self)
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing")
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("textFieldShouldBeginEditing")
        return true
    }
    
}
