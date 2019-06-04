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
import GoogleMaps
import GooglePlaces


class StoreThumbViewController: UIViewController {
    var itemInfo = IndicatorInfo(title: "storeThumb")
    var categoryList:[String]?
    var storeThumbList:[StoreThumb] = []
    public var storeType = 10
    var location = 200
    var sort = 101
    var kind = 0
    var locationManager = CLLocationManager()
    var isAgreeTermission = false
    {
        didSet(oldVal)
        {
            if(isAgreeTermission == false)
            {
                distance = 0
            }
        }
    }
    var distance = 0
    {
        didSet(oldVal)
        {
            if(distance == 500)
            {
                btnDistance.setTitle("500 m", for: .normal)
            }
            else if(distance == 1000)
            {
                btnDistance.setTitle("1 km", for: .normal)
            }
            else if(distance == 3000)
            {
                btnDistance.setTitle("3 km", for: .normal)
            }
            else if(distance == 5000)
            {
                btnDistance.setTitle("5 km", for: .normal)
            }
            else
            {
                btnDistance.setTitle("전체", for: .normal)
            }
        }
    }
    
    @IBOutlet var storeCollectionView: UICollectionView!
    @IBOutlet var btnArea: UIButton!
    @IBOutlet var btnFilter: UIButton!
    @IBOutlet var btnDistance: UIButton!
    
    private let refreshControl = UIRefreshControl()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocationManger()
        
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)

        if #available(iOS 10.0, *) {
            storeCollectionView.refreshControl = refreshControl
        } else {
            storeCollectionView.addSubview(refreshControl)
        }

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
        
        getStoreInfo(type:storeType, location:location, sort:sort, kind:(storeType + 20) * 10 + kind, distance:self.distance)

        Util.setButtonImage(btn: btnArea, width:13, height:13)
        Util.setButtonImage(btn: btnFilter, width:15, height:15)
        //Util.setButtonImage(btn: btnDistance, width:17, height:20)
        
        btnFilter.layer.cornerRadius = 11
        btnDistance.layer.cornerRadius = 11
    }
    
    func setLocationManger() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
    }

    
    private func getStoreInfo(type:Int, location:Int, sort:Int, kind:Int, distance: Int)
    {
        let kakaoId = UserInfo.getUserId() ?? ""
        let latitude = Float((locationManager.location?.coordinate.latitude ?? CLLocationDegrees(floatLiteral: 0)))
        let longitude = Float((locationManager.location?.coordinate.longitude ?? CLLocationDegrees(floatLiteral: 0)))

        let param = ["kakaoID":kakaoId, "type":type, "location":location, "sort":sort, "kind":kind, "x":longitude, "y":latitude, "distance": distance] as [String : Any]
        //print(param)
        Alamofire.request("http://iloveggbb.com/app/main/getMainList.php", method: .post, parameters: param)
            .responseJSON {(response) in
                //print(response)
                switch response.result
                {
                case .success(let obj):
                    //print("succss1")
                    if let _ = obj as? [NSDictionary]
                    {
                        do
                        {
                            let jsonObj = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                            let data = try JSONDecoder().decode([StoreThumb].self, from: jsonObj)
                            
                            self.storeThumbList = data
                            self.storeCollectionView.reloadData()
                             self.refreshControl.endRefreshing()


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
    
    private func nameSetting()
    {
        var areaName = ""
        switch(location)
        {
        case 200:
            areaName = "지역 전체"
            break
        case 201:
            areaName = "의정부"
            break
        case 202:
            areaName = "동두천"
            break
        case 203:
            areaName = "양주"
            break
        case 204:
            areaName = "포천"
            break
        case 205:
            areaName = "노원"
            break
        default:
            break
        }
        
        btnArea.setTitle(areaName, for: .normal)
    }
    
    
    @objc private func refreshData(_ sender: Any) {
        // Fetch Weather Data
        getStoreInfo(type: storeType, location: location, sort: sort, kind: (storeType + 20) * 10 + kind, distance:self.distance)
    }
    
    
    
    @IBAction func showFilter(_ sender: Any) {
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "OptionFilterViewController") as? OptionFilterViewController
        {
            vc.arrKindName = self.categoryList
            self.show(vc, sender: self)
        }
    }
    
    
    
    @IBAction func unwindToStoreThumbFromOptionAreaViewController(_ segue: UIStoryboardSegue){
        print("unwindToStoreThumbFromOptionAreaViewController")
        if let vc = segue.source as? OptionAreaViewController {
            self.location = vc.selectedAreaNum
        }
        
        print((storeType + 20) * 10 + kind)
        getStoreInfo(type: storeType, location: location, sort: sort, kind: (storeType + 20) * 10 + kind, distance:self.distance)
        nameSetting()
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
        
        getStoreInfo(type: storeType, location: location, sort: sort, kind: (storeType + 20) * 10 + kind, distance:self.distance)
        nameSetting()
        btnFilter.setBackgroundImage(UIImage (named:"filter_on"), for: .normal)
    }
    
    @IBAction func unwindToStoreThumbFromOptionDistanceViewController(_ segue: UIStoryboardSegue){
        if let vc = segue.source as? OptionDistanceViewController {
            distance = vc.distance
        }
        
        getStoreInfo(type: storeType, location: location, sort: sort, kind: (storeType + 20) * 10 + kind, distance:self.distance)
        nameSetting()
    }
    
    @IBAction func showOptionArea(_ sender: Any) {
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "OptionAreaViewController") as? OptionAreaViewController
        {
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    @IBAction func showOptionDistance(_ sender: Any) {
        //locationManager.requestWhenInUseAuthorization()

        if(isAgreeTermission == true)
        {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "OptionDistanceViewController") as? OptionDistanceViewController
            {
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
                self.present(vc, animated: false, completion: nil)
            }
        }
        else
        {
            
            let message = "설정 -> 응답하라경기북부 앱 -> 위치 접근 권한을 허용으로 바꿔야 거리정보를 사용하실 수 있습니다."
            
            let alert = UIAlertController(title: "위치정보 거절", message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: { (action) in
                //self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion:{
                //self.navigationController?.dismiss(animated: true, completion: nil)
            })
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
        cell.imageView.image = UIImage(named: "no_img")
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
        
    }
}

extension StoreThumbViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 6
        let sizes = CGSize(width: width, height: width * 0.9 + 77)
        
        return sizes
    }
}

extension StoreThumbViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            print("Location WhenInUse")
            isAgreeTermission = true
            break
        case .denied:
            print("Location Denied")
            //gMapView.isMyLocationEnabled = false
            //locationManager.stopUpdatingLocation()
            isAgreeTermission = false
            /*
            let message = "설정 -> 응답하라경기북부 앱 -> 위치 접근 권한을 허용으로 바꿔야 거리정보를 사용하실 수 있습니다."
            
            let alert = UIAlertController(title: "위치정보 거절", message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: { (action) in
                //self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion:{
                //self.navigationController?.dismiss(animated: true, completion: nil)
            })*/
            
            break
        case .notDetermined:
            print("Location notDetermined")
            //gMapView.isMyLocationEnabled = false
            //locationManager.stopUpdatingLocation()
            isAgreeTermission = false
            /*
            let message = "설정 -> 응답하라경기북부 앱 -> 위치 접근 권한을 허용으로 바꿔야 거리정보를 사용하실 수 있습니다."

            let alert = UIAlertController(title: "위치정보 거절", message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: { (action) in
                //self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion:{
                //self.navigationController?.dismiss(animated: true, completion: nil)
            })
             */
            
            break
        case .restricted:
            print("Location restricted")
            break
        default:
            print("default")
            break
        }
    }
}


