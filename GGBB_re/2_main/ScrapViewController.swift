//
//  SearchStoreViewController.swift
//  GGBB_re
//
//  Created by 송시온 on 28/05/2019.
//  Copyright © 2019 송시온. All rights reserved.
//

import UIKit
import Alamofire

class ScrapViewController: UIViewController
{
    @IBOutlet var searchCollectionView: UICollectionView!
    var storeThumbList:[SearchResult] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getStoreInfo()
    }
    
    private func getStoreInfo()
    {
        let kakaoId = UserInfo.getUserId() ?? ""
        //let param = ["kakaoID":kakaoId] as [String : Any]
        let param = ["kakaoID":kakaoId] as [String : Any]
        print(param)
        Alamofire.request("http://iloveggbb.com/app/scrap/get.php", method: .post, parameters: param)
            .responseJSON {(response) in
                switch response.result
                {
                case .success(let obj):
                    if let objList = obj as? [NSDictionary]
                    {
                        var resultData = [SearchResult]()
                        for item in objList
                        {
                            do
                            {
                                let jsonObj = try JSONSerialization.data(withJSONObject: item, options: .prettyPrinted)
                                let data = try JSONDecoder().decode(SearchResult.self, from: jsonObj)
                                resultData.append(data)
                            }
                            catch{
                                print("fail")
                                print(error.localizedDescription)
                            }
                        }
                        self.storeThumbList = resultData
                        self.searchCollectionView.reloadData()
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
    
    @IBAction func deleteScrap(_ sender: UIButton) {
        let kakaoId = UserInfo.getUserId() ?? ""
        let selectedItem = storeThumbList[sender.tag]
        let param = ["kakaoID":kakaoId, "storeNum":selectedItem.num, "storeType":selectedItem.type] as [String : Any]
        
        Alamofire.request("http://iloveggbb.com/app/scrap/delete.php", method: .post, parameters: param)
            .responseJSON {(response) in
                switch response.result
                {
                case .success(let _):
                    self.storeThumbList.remove(at: sender.tag)
                    self.searchCollectionView.reloadData()
                    break
                case .failure(let error):
                    print("fail")
                    print(error.localizedDescription)
                    break
                }
                //print(response)
        }

    }
}

extension ScrapViewController: UICollectionViewDataSource {
    
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScrapStoreCell", for: indexPath) as! ScrapStoreCell
        cell.imageView.image = UIImage(named: "40_hotel_grey_1x")
        cell.data = storeThumbList[indexPath.row]
        cell.containerView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        cell.containerView.layer.borderWidth = 1
        //cell.initView()
        cell.deleteBtn.tag = indexPath.row
        
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
    
    
}

extension ScrapViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 6
        let sizes = CGSize(width: width, height: width * 0.9 + 80)
        return sizes
    }
}

class ScrapStoreCell: UICollectionViewCell {
    @IBOutlet var isLikeImage: UIImageView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var storeNameLabel: UILabel!
    @IBOutlet var viewLabel: UILabel!
    @IBOutlet var reviewLabel: UILabel!
    @IBOutlet var likeLabel: UILabel!
    @IBOutlet var deleteBtn: UIButton!

    var data:SearchResult {
        get {
            return self.data
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
