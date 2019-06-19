//
//  RequestViewController.swift
//  GGBB_re
//
//  Created by 송시온 on 30/05/2019.
//  Copyright © 2019 송시온. All rights reserved.
//

import UIKit
import Alamofire

class RequestViewController: UIViewController {
    @IBOutlet var typeTable: UITableView!
    @IBOutlet var typeAreaView: UIView!
    
    @IBOutlet var telTextField: UITextField!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var contentTextView: UITextView!
    @IBOutlet var myScrollView: UIScrollView!
    
    
    var typeList = ["홍보 문의", "오류 문의", "기능 추가 요청", "불량 가게 신고", "기타"]
    var selectedText = ""
    
    var orgHeight:CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayer()
        
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
    
    private func setLayer()
    {
        typeTable.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        typeTable.layer.borderWidth = 1
        typeTable.layer.cornerRadius = 5
        
        contentTextView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        contentTextView.layer.borderWidth = 1
        contentTextView.layer.cornerRadius = 5
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
    
    
    
    @IBAction func pushQnA(_ sender: Any) {
        let title = titleTextField.text ?? ""
        var content = contentTextView.text ?? ""
        let kind = selectedText
        let tel = telTextField.text ?? ""
        
        if(title == "" || content == "" || kind == "" || tel == "")
        {
            let message = "모든 항목을 입력해주세요."
            
            let alert = UIAlertController(title: "문의 신청 실패", message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: { (action) in
            }))
            self.present(alert, animated: true, completion:{
            })
            return
        }
        
        content = "Tel:" + tel + ", " + content
        
        let kakaoId = UserInfo.getUserId() ?? ""
        let serviceType = 11

        let param = ["kakaoID":kakaoId, "serviceType":serviceType, "title":title, "content":content, "kind":kind] as [String:Any]
        Alamofire.request("http://www.iloveggbb.com/index2.php", method: .post, parameters: param).responseJSON { (response) in
                print(response)
                switch response.result
                {
                case .success(let obj):
                    print("succss1")
                   
                    let message = "문의가 정상적으로 접수되었습니다."
                    
                    let alert = UIAlertController(title: "문의 신청", message: message, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: { (action) in
                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(alert, animated: true, completion:{
                    })
                    
                    break
                case .failure(let error):
                    print("fail")
                    print(error.localizedDescription)
                    
                    let message = "접수에 실패하였습니다. 네트워크 상태를 확인해주세요."
                    
                    let alert = UIAlertController(title: "문의 신청 실패", message: message, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: { (action) in
                    }))
                    self.present(alert, animated: true, completion:{
                    })
                    break
                }
                //print(response)
        }
        
    }
    
}

extension RequestViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RequestTypeCell") as? RequestTypeCell
        {
            cell.selectedBackgroundView = nil
            cell.selectionStyle = .none
            
            cell.nameLabel.text = typeList[indexPath.row]
            if(typeList[indexPath.row] == selectedText)
            {
                cell.nameLabel.textColor = Util.AppColor
                cell.isSelectImage.image = UIImage(named: "36_checked_1x")
            }
            else
            {
                cell.nameLabel.textColor = .lightGray
                cell.isSelectImage.image = UIImage(named: "36_unchecked_1x")
            }
            
            return cell
        }
        else
        {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedText = typeList[indexPath.row]
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / CGFloat(typeList.count)
    }
}


extension RequestViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(textField == telTextField)
        {
            titleTextField.becomeFirstResponder()
        }
        else if(textField == titleTextField)
        {
            contentTextView.becomeFirstResponder()
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

class RequestTypeCell: UITableViewCell
{
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var isSelectImage: UIImageView!
}
