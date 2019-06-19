//
//  SignViewController.swift
//  GGBB_re
//
//  Created by 송시온 on 15/05/2019.
//  Copyright © 2019 송시온. All rights reserved.
//

import UIKit
import Alamofire

class SignViewController: UIViewController {
    @IBOutlet var btnIdCheck: UIButton!
    @IBOutlet var inputId: UITextField!
    @IBOutlet var inputName: UITextField!
    @IBOutlet var inputPw1: UITextField!
    @IBOutlet var inputPw2: UITextField!
    @IBOutlet var labelIdCheck: UILabel!
    @IBOutlet var btnTerms1: ImageButton!
    @IBOutlet var btnTerms2: ImageButton!
    @IBOutlet var btnSignup: UIButton!
    @IBOutlet var myScrollView: UIScrollView!
    
    var responseIdCheck: JSONResponse? = nil {
        didSet(oldVal){
        }
        willSet(newVal){
            if let newValData = newVal
            {
                // 값이 변경되기 직전에 호출, newVal은 변경 될 새로운 값
                if(newValData.result == true)
                {
                    labelIdCheck.textColor = UIColor.blue
                }
                else
                {
                    labelIdCheck.textColor = UIColor.red
                }
                
                labelIdCheck.text = newValData.msg
            }
            else
            {
                labelIdCheck.textColor = UIColor.gray
                labelIdCheck.text = "아이디 중복확인 버튼을 눌러주세요"
            }
        }
    }
    
    var isTerms1:Bool = false {
        didSet(oldVal)
        {
        }
        willSet(newVal)
        {
            if(newVal == true)
            {
                btnTerms1.setTitleColor(.blue, for: .normal)
                btnTerms1.leftHandImage = UIImage(named:"check")
                btnTerms1.layer.borderColor = UIColor.blue.cgColor
            }
            else
            {
                btnTerms1.layer.borderColor = UIColor.red.cgColor
                btnTerms1.setTitleColor(.red, for: .normal)
                btnTerms1.leftHandImage = UIImage(named:"36_unchecked_1x")
            }
        }
    }
    
    
    var isTerms2:Bool = false {
        didSet(oldVal)
        {
        }
        willSet(newVal)
        {
            if(newVal == true)
            {
                btnTerms2.setTitleColor(.blue, for: .normal)
                btnTerms2.leftHandImage = UIImage(named:"check")
                btnTerms2.layer.borderColor = UIColor.blue.cgColor

            }
            else
            {
                btnTerms2.layer.borderColor = UIColor.red.cgColor
                btnTerms2.setTitleColor(.red, for: .normal)
                btnTerms2.leftHandImage = UIImage(named:"36_unchecked_1x")
            }
        }
    }
    
    var orgHeight:CGFloat!
    override func viewDidLoad() {
        super.viewDidLoad()
        orgHeight = self.view.frame.height
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // touchEvnet
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        myScrollView.addGestureRecognizer(singleTapGestureRecognizer)
    }
    @objc func endEditing()
    {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame = CGRect(x: 0,y: 0, width: self.view.frame.width, height: orgHeight - keyboardSize.height)
            
            loadViewIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame = CGRect(x: 0,y: 0, width: self.view.frame.width, height: orgHeight)
        loadViewIfNeeded()
    }

    
    
    // 화면 이동 전에 동작하는 함수
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueTerms1" || segue.identifier == "segueTerms2" {
            if let vc : Terms1ViewController = segue.destination as? Terms1ViewController
            {
                vc.delegate = self
            }
            else if let vc : Terms2ViewController = segue.destination as? Terms2ViewController
            {
                vc.delegate = self
            }
        }
    }
    
    @IBAction func checkId(_ sender: Any)
    {
        checkUserId(id: inputId.text ?? "")
    }
    
    @IBAction func signup(_ sender: Any) {
        var msg = ""
        if(responseIdCheck == nil || responseIdCheck!.result == false)
        {
            msg = "아이디를 확인하시고 중복확인 버튼을 눌러주세요."
        }
        else if((inputPw1.text ?? "").count < 6 || (inputPw1.text ?? "").count > 20 || inputPw1.text != inputPw2.text)
        {
            msg = "비밀번호를 확인해주세요."
        }
        else if((inputName.text ?? "").count < 2 || (inputName.text ?? "").count > 20)
        {
            msg = "닉네임을 확인해주세요."
        }
        else if(isTerms1 == false || isTerms2 == false)
        {
            msg = "이용약관을 동의해주세요."
        }

        if( msg != "")
        {
            let alert = UIAlertController(title: "경고", message: msg, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            requestSign(inputId.text!, inputPw1.text!, inputName.text!)
        }
    }
    
    @IBAction func idChanged(_ sender: Any) {
        if (responseIdCheck != nil) {
            responseIdCheck = nil
        }
    }
    
    @IBAction func inputPass1(_ sender: Any) {
        if(inputPw1.text != nil && inputPw1.text!.count >= 6 && inputPw1.text!.count <= 20)
        {
            inputPw1.layer.borderColor = UIColor.blue.cgColor
        }
        else
        {
            inputPw1.layer.borderColor = UIColor.red.cgColor
        }
        inputPw1.layer.borderWidth = 1.0
        inputPw1.layer.cornerRadius = 5
        
        print(inputPw1.text)
    }
    
    @IBAction func inputPass2(_ sender: Any) {
        if(inputPw1.text == inputPw2.text && inputPw2.text != nil && inputPw2.text!.count >= 6 && inputPw2.text!.count <= 20)
        {
            inputPw2.layer.borderColor = UIColor.blue.cgColor
        }
        else
        {
            inputPw2.layer.borderColor = UIColor.red.cgColor
        }
        inputPw2.layer.borderWidth = 1.0
        inputPw2.layer.cornerRadius = 5
    }

    
    func checkUserId(id:String) {
    
        Alamofire.request("http://iloveggbb.com/app/login/checkId.php?id="+id, method: .post, parameters: nil)
            .responseJSON(completionHandler: {(response) in
                switch response.result
                {
                case .success(let obj):
                    if let _ = obj as? NSDictionary
                    {
                        do
                        {
                            let jsonObj = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                            let data = try JSONDecoder().decode(JSONResponse.self, from: jsonObj)
                            
                            //print(data.result)
                            self.responseIdCheck = data
                        }
                        catch
                        {
                            print("fail")
                            print(error.localizedDescription)
                        }
                    }
                    break
                case .failure(let error):
                    self.responseIdCheck = nil
                    print(error.localizedDescription)
                    break
                }
        })
    }
    
    private func requestSign(_ id:String, _ pw:String, _ name:String)
    {
        Alamofire.request("http://iloveggbb.com/app/login/signUp.php?id="+id + "&password=" + pw + "&nickname=" + name, method: .post, parameters: nil)
            .responseJSON(completionHandler: {(response) in
                switch response.result
                {
                case .success(let obj):
                    if let _ = obj as? NSDictionary
                    {
                        do
                        {
                            let jsonObj = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                            let data = try JSONDecoder().decode(ResultSign.self, from: jsonObj)
                            
                            if(data.result == "success")
                            {
                                /*
                                 let alert = UIAlertController(title: "가입 완료", message: data.message, preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                 */
                                self.navigationController?.popViewController(animated: true)
                            }
                            else
                            {
                                let alert = UIAlertController(title: "가입 실패", message: data.message, preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                        catch
                        {
                            print("fail")
                            print(error.localizedDescription)
                        }
                    }
                    break
                case .failure(let error):
                    self.responseIdCheck = nil
                    print(error.localizedDescription)
                    break
                }
            })
    }
}

extension SignViewController: Terms1Delegate, Terms2Delegate
{
    func agreeTerms1(data: String) {
        isTerms1 = true
    }
    
    func agreeTerms2(data: String) {
        isTerms2 = true
    }
}

extension SignViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(textField == inputPw1)
        {
            inputPw2.becomeFirstResponder()
        }
        else if(textField == inputPw2)
        {
            inputName.becomeFirstResponder()
        }
        else
        {
            textField.resignFirstResponder()
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
