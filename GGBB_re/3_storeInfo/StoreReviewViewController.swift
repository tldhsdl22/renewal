//
//  StoreReviewViewController.swift
//  GGBB_re
//
//  Created by 송시온 on 15/05/2019.
//  Copyright © 2019 송시온. All rights reserved.
//

import UIKit
import Alamofire

class StoreReviewViewController: UIViewController
{
    var num:String?
    var type:String?
    var storeInfoDetail:StoreInfoDetail?
    {
        didSet(oldVal)
        {
            reviewList = [ReviewInfo]()
            
            if let allReviewList = storeInfoDetail?.reviewList
            {
                for review in allReviewList
                {
                    if review.blind == "0"
                    {
                        reviewList.append(review)
                    }
                }
            }
            
            reviewTableView.reloadData()
        }
    }
    var reviewList = [ReviewInfo]()

    @IBOutlet var reviewTableView: UITableView!
    @IBOutlet var sendBtn: UIButton!
    @IBOutlet var reviewField: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        getDetailData(num: self.num ?? "", type:self.type ?? "")
        
        reviewTableView.allowsSelection = false
        
        
        orgHeight = self.view.frame.height
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:
            UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
       
        // touchEvnet
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        reviewTableView.addGestureRecognizer(singleTapGestureRecognizer)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    var orgHeight:CGFloat = 0
    
    @objc func endEditing()
    {
        self.view.endEditing(true)
    }
    
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
    
    
    
    private func getDetailData(num:String, type:String)
    {
        let kakaoId = UserInfo.getUserId() ?? ""
        let param = ["num":num, "type":type, "kakaoID":kakaoId] as [String : Any]
        Alamofire.request("http://iloveggbb.com/app/main/store.php", method: .post, parameters: param)
            .responseJSON {(response) in
                switch response.result
                {
                case .success(let obj):
                    print("succss1")
                    if obj is NSDictionary
                    {
                        do
                        {
                            let jsonObj = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                            let data = try JSONDecoder().decode(StoreInfoDetail.self, from: jsonObj)
                            print(data.menu?.count ?? 0)
                            self.storeInfoDetail = data
                        }
                        catch
                        {
                            print("fail")
                            print(error.localizedDescription)
                        }
                    }
                    break
                case .failure(let error):
                    print("fail")
                    print(error.localizedDescription)
                    break
                }
                //print(response)
        }
    }
    
    
    @IBAction func sendReview(_ sender: Any) {
        self.sendBtn.isEnabled = false
        
        let kakaoId = UserInfo.getUserId() ?? ""
        if kakaoId == ""
        {
            let alert = UIAlertController(title: "사용 불가", message: "로그인 후 사용할 수 있는 기능입니다.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.sendBtn.isEnabled = true
            return
        }
        
        let serviceType = "10" // 댓글 서비스는 10번
        let review = self.reviewField.text
        let param = ["kakaoID":kakaoId , "serviceType":serviceType , "storeNum":self.num  ?? "", "type":self.type  ?? "", "review":review ?? ""] as [String:Any]
        
        if( review == "" )
        {
            self.sendBtn.isEnabled = true
            return
        }
        
        Alamofire.request("http://www.iloveggbb.com/index2.php", method: .post, parameters: param)
            .responseJSON {(response) in
                print(response)
                switch response.result
                {
                case .success(let obj):
                    print("succss1")
                    if obj is NSDictionary
                    {
                        do
                        {
                            let jsonObj = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                            let data = try JSONDecoder().decode(ReviewResult.self, from: jsonObj)
                            if data.result == "success"
                            {
                                self.getDetailData(num: self.num ?? "", type: self.type ?? "")
                                self.reviewField?.text = ""
                            }
                            else
                            {
                                let alert = UIAlertController(title: "댓글달기 실패", message: "서버 연결상태가 좋지 않습니다.", preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                        catch
                        {
                            print("fail")
                            print(error.localizedDescription)
                            
                            let alert = UIAlertController(title: "댓글달기 실패", message: "서버 연결상태가 좋지 않습니다.", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                    break
                case .failure(let error):
                    print("fail")
                    print(error.localizedDescription)
                    break
                }
                //print(response)
                
                self.sendBtn.isEnabled = true
        }
    }
}

extension StoreReviewViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StoreReviewCell") as? StoreReviewCell
            else {
                return UITableViewCell()
        }
        let reviewInfo = reviewList[indexPath.row]
        cell.thumbImg.cacheImage(urlString: reviewInfo.url ?? "")
        cell.nameLabel.text = reviewInfo.nickName
        cell.dateLabel.text = reviewInfo.date
        cell.contentsLabel.text = reviewInfo.review
        cell.thumbImg.layer.cornerRadius = cell.thumbImg.frame.width / 2
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
}


extension StoreReviewViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        self.sendReview(self)
        
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



class StoreReviewCell: UITableViewCell
{
    @IBOutlet var thumbImg: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var contentsLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
}
