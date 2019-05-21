//
//  Test01.swift
//  GGBB_re
//
//  Created by 송시온 on 03/05/2019.
//  Copyright © 2019 송시온. All rights reserved.
//


import UIKit
import XLPagerTabStrip
import Alamofire

class StoreThumbViewController: UIViewController {
    var itemInfo = IndicatorInfo(title: "storeThumb")
    var storeThumbList:[StoreThumb] = []
    public var storeType = 10
    var location = 200
    var sort = 101
    var kind = 0
    
    @IBOutlet var storeCollectionView: UICollectionView!
    @IBOutlet var btnArea: UIButton!
    @IBOutlet var btnFilter: UIButton!
    @IBOutlet var btnDistance: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = storeCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        // type 10 ~ 60
        // 먹자, 놀자, 자자, 쇼핑, 지하상가

        // location 200 ~ 205
        // 전체, 의정부, 노원, 양주, 동두천, 포천
        
        // sort 101 ~ 104
        //추천, 최신, 리뷰, 조회
        
        // kind 301 ~ 701(0으로 끝나면 전체)
        // (타입 + 20) * 10 + 종류
        
        getStoreInfo(type:storeType, location:location, sort:sort, kind:(storeType + 20) * 10 + kind)

        Util.setButtonImage(btn: btnArea, width:13, height:13)
        Util.setButtonImage(btn: btnFilter, width:15, height:15)
        Util.setButtonImage(btn: btnDistance, width:17, height:20)
        
        btnFilter.layer.cornerRadius = 11
        btnDistance.layer.cornerRadius = 11
    }
    
    private func getStoreInfo(type:Int, location:Int, sort:Int, kind:Int)
    {
        let kakaoId = UserInfo.getUserId() ?? ""
        let param = ["kakaoID":kakaoId, "type":type, "location":location, "sort":sort, "kind":kind] as [String : Any]
        
        Alamofire.request("http://iloveggbb.com/app/main/mainList.php", method: .post, parameters: param)
            .responseJSON {(response) in
                switch response.result
                {
                case .success(let obj):
                    print("succss1")
                    if let _ = obj as? [NSDictionary]
                    {
                        do
                        {
                            let jsonObj = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                            let data = try JSONDecoder().decode([StoreThumb].self, from: jsonObj)
                            
                            self.storeThumbList = data
                            self.storeCollectionView.reloadData()

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
    
    
    @IBAction func unwindToStoreThumbFromOptionAreaViewController(_ segue: UIStoryboardSegue){
        print("unwindToStoreThumbFromOptionAreaViewController")
        if let vc = segue.source as? OptionAreaViewController {
            self.location = vc.selectedAreaNum
        }
        
        getStoreInfo(type: storeType, location: location, sort: sort, kind: (storeType + 20) * 10 + kind)
    }
    
    
    @IBAction func unwindToStoreThumbFromOptionFilterViewController(_ segue: UIStoryboardSegue){
        print("unwindToStoreThumbFromOptionFilterViewController")
        
        if let vc = segue.source as? OptionFilterViewController
        {
            if( vc.selectedArea > 0 )
            {
                self.location = 200 + ( vc.selectedArea - 1 )
            }
            
            if( vc.selectedKind > 0 )
            {
                self.kind = vc.selectedKind
            }
            
            
            if( vc.selectedSort > 0 )
            {
                self.sort = 100 + vc.selectedSort
            }
        }
        
        getStoreInfo(type: storeType, location: location, sort: sort, kind: (storeType + 20) * 10 + kind)

    }
    
    @IBAction func unwindToStoreThumbFromOptionDistanceViewController(_ segue: UIStoryboardSegue){
        if let vc = segue.source as? OptionDistanceViewController {
            btnDistance.setTitle(vc.distance, for: .normal)
        }
        
        getStoreInfo(type: storeType, location: location, sort: sort, kind: (storeType + 20) * 10 + kind)
    }

    

    
    
    @IBAction func showOptionArea(_ sender: Any) {
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "OptionAreaViewController") as? OptionAreaViewController
        {
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func showOptionDistance(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "OptionDistanceViewController") as? OptionDistanceViewController
        {
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            self.present(vc, animated: true, completion: nil)
        }
    }
}

extension StoreThumbViewController: IndicatorInfoProvider  {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}


// Tableview datasource
var reuseIdentifier = "StoreThumbCollectionViewCell"
extension StoreThumbViewController: UICollectionViewDataSource {
    
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! StoreThumbCollectionViewCell
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
            self.show(vc, sender: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
}

extension StoreThumbViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 6
        let sizes = CGSize(width: width, height: width * 0.9 + 80)        
        return sizes
    }
}


