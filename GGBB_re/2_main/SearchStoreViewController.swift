//
//  SearchStoreViewController.swift
//  GGBB_re
//
//  Created by 송시온 on 28/05/2019.
//  Copyright © 2019 송시온. All rights reserved.
//

import UIKit
import Alamofire

class SearchStoreViewController: UIViewController
{
    @IBOutlet var searchCollectionView: UICollectionView!
    @IBOutlet var txtView: UITextField!
    var storeThumbList:[SearchResult] = []
    
    var timer : Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        //getStoreInfo(query:"짜장면")
        //txtView.delegate = self
        
        // touchEvnet
        let singleTapGestureRecognizer =
            UITapGestureRecognizer(target: self, action: #selector(endEditing))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        searchCollectionView.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    @objc func endEditing()
    {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    private func getStoreInfo(query:String)
    {
        let kakaoId = UserInfo.getUserId() ?? ""
        let param = ["kakaoID":kakaoId, "query":query] as [String : Any]
        print(param)
        Alamofire.request("http://iloveggbb.com/app/search/searchQuery.php?", method: .post, parameters: param)
            .responseJSON {(response) in
                print(response)
                switch response.result
                {
                case .success(let obj):
                    print("succss1")
                    if let _ = obj as? [NSDictionary]
                    {
                        do
                        {
                            let jsonObj = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                            let data = try JSONDecoder().decode([SearchResult].self, from: jsonObj)
                            
                            self.storeThumbList = data
                            self.searchCollectionView.reloadData()
                            
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
    @IBAction func clickDismiss(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func textFieldDidChange(_ sender: Any) {
        timer?.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(searchStore), userInfo: nil, repeats: false)
    }
    
    @objc func searchStore()
    {
        getStoreInfo(query:txtView.text ?? "")
    }
    
    @IBAction func clickSearchBtn(_ sender: Any) {
        self.view.endEditing(true)
    }
}

extension SearchStoreViewController: UICollectionViewDataSource {
    
    override func viewDidAppear(_ animated: Bool) {
        //self.collectionView?.reloadData()
        // reload 한개만 하도록, 데이터 변경은 디테일에서 disappear될때 처리
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storeThumbList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchStoreCell", for: indexPath) as! SearchStoreCell
        cell.imageView.image = UIImage(named: "40_hotel_grey_1x")
        cell.data = storeThumbList[indexPath.row]
        cell.containerView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        cell.containerView.layer.borderWidth = 1
        //cell.initView()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = UIStoryboard(name: "StoreInfo", bundle: nil).instantiateViewController(withIdentifier: "StoreInfoViewController") as? StoreInfoViewController
        {
            //vc.storeInfo = storeThumbList[indexPath.row]
            vc.storeNum = storeThumbList[indexPath.row].num
            vc.storeType = storeThumbList[indexPath.row].type
            vc.storeTitle = storeThumbList[indexPath.row].name
            vc.storeLocation = storeThumbList[indexPath.row].location
            
            self.show(vc, sender: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        getStoreInfo(query:txtView.text ?? "")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
}

extension SearchStoreViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 6
        let sizes = CGSize(width: width, height: width * 0.9 + 80)
        return sizes
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}

extension SearchStoreViewController: UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        print("textFieldDidEndEditing")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("textFieldShouldBeginEditing")
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print("textFieldShouldClear")
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("textFieldShouldEndEditing")
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        print("textFieldShouldReturn")
        return true
    }
}

class SearchStoreCell: UICollectionViewCell {
    @IBOutlet var isLikeImage: UIImageView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var storeNameLabel: UILabel!
    @IBOutlet var viewLabel: UILabel!
    @IBOutlet var reviewLabel: UILabel!
    @IBOutlet var likeLabel: UILabel!
    
    var data:SearchResult {
        get {
            return data
        }
        set(newVal){
            var areaName = ""
            switch(newVal.location)
            {
            case "201":
                areaName = "의정부"
                break
            case "202":
                areaName = "동두천"
                break
            case "203":
                areaName = "양주"
                break
            case "204":
                areaName = "포천"
                break
            case "205":
                areaName = "노원"
                break
            default:
                break
            }
            self.distanceLabel.text = areaName
            self.storeNameLabel.text = newVal.name
            
            var strViewCnt = newVal.view
            let viewCnt = Int(strViewCnt) ?? 0
            if(viewCnt > 1000)
            {
                strViewCnt = String(viewCnt / 1000) + "K"
            }
            var strReviewCnt = newVal.review
            let reviewCnt = Int(strReviewCnt) ?? 0
            if(reviewCnt > 1000)
            {
                strReviewCnt = String(reviewCnt / 1000) + "K"
            }
            var strRecommendCnt = newVal.recommend
            let recommendCnt = Int(strRecommendCnt) ?? 0
            if(recommendCnt > 1000)
            {
                strRecommendCnt = String(recommendCnt / 1000) + "K"
            }
            
            self.viewLabel.text = strViewCnt
            self.reviewLabel.text = strReviewCnt
            self.likeLabel.text = strRecommendCnt
            //imageView.image = UIImage(named: "cm_image_white")
            imageView.image = UIImage(named: "no_img")
            
            imageView.cacheImage(urlString: newVal.thumbnail)
            
            if(newVal.isRec == "0")
            {
                isLikeImage.image = UIImage(named: "good")
            }
            else
            {
                isLikeImage.image = UIImage(named: "good_on")
            }
            
        }
    }
}
