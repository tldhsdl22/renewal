//
//  GMapViewController.swift
//  GGBB_re
//
//  Created by 송시온 on 21/05/2019.
//  Copyright © 2019 송시온. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire

class StoreInfoGmapViewController:UIViewController
{
    @IBOutlet var mapView: UIView!
    @IBOutlet var storeCollectionView: UICollectionView!
    var storeType = ""
    var storeNum = ""
    
    var latitude:Float!
    var longitude:Float!
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var gMapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    
    var isAgreeTermission:Bool = false {
        didSet(oldVal)
        {
            print(isAgreeTermission)
            if(isAgreeTermission == true)
            {
                makePicker()
            }
        }
    }
    
    var storeList:[NearStore]?{
        didSet(oldVal)
        {
            if let list = storeList
            {
                for nearStore in list
                {
                    let x = CGFloat(NSString(string: nearStore.x ?? "0").floatValue)
                    let y = CGFloat(NSString(string: nearStore.y ?? "0").floatValue)
                    setMarker(lat: y, lng: x, title: nearStore.name ?? "")
                }
            }
            storeCollectionView.reloadData()
            selectStore(index: 0)
        }
    }
    
    
    // marker
    var markers = [GMSMarker]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMapView()
        setLayout()
        setLocationManger()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // permission check
        locationManager.requestWhenInUseAuthorization()
        goMyLocation()
    }
    
    
    private func makePicker()
    {
        clearMarkers()
        let location = getMyLocation()
        loadData(location: location)
    }
    
    // 데이터 가져오기
    private func loadData(location:CLLocation?)
    {
        guard let location = location else {
            return
        }
        
        let latitude = Float(location.coordinate.latitude)
        let longitude = Float(location.coordinate.longitude)
        
        let params = ["x":longitude, "y":latitude, "num":self.storeNum, "type": self.storeType, "distance":"100000"] as [String : Any]
        Alamofire.request("http://www.iloveggbb.com/nearStore/getStoreOnly.php", method: .post, parameters: params).responseJSON(completionHandler: ({ (response) in
            switch(response.result)
            {
            case .success(let obj):
                if obj is [NSDictionary]
                {
                    print("true1")
                    do
                    {
                        let serialized = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                        print(serialized)

                        let result = try JSONDecoder().decode([NearStore].self, from: serialized)
                        // 이부분 에러 (The data couldn’t be read because it isn’t in the correct format.) 이게 계속 나옴

                        // 데이터 타입 조사
                        self.storeList = result
                    }catch
                    {
                        print(error.localizedDescription)
                    }
                }
                else
                {
                    print("true444")
                    print("is Not Structed as Dictionary.")
                }
                break
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
        }))
    }
    
    private func setMapView()
    {
        // 맵 설정
        let camera = GMSCameraPosition.camera(withLatitude: 37.751365, longitude: 127.077625, zoom: 18.0)
        self.gMapView = GMSMapView.map(withFrame: self.mapView.bounds, camera: camera)
        self.mapView.addSubview(self.gMapView)
        Util.setAnchor(baseView: mapView, newView: gMapView)
        
        self.gMapView.delegate = self
    }
    
    private func clearMarkers() {
        gMapView.clear()
        markers.removeAll()
    }
    
    private func setMarker(lat:CGFloat, lng:CGFloat, title:String)
    {
        print(title + "/" + String(describing: lat) + ", " + String(describing: lng))
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lng))
        marker.title = title
        marker.map = gMapView
        marker.icon = UIImage(named:"map_marker")
        
        markers.append(marker)
    }
    
    private func setLayout()
    {
        storeCollectionView.backgroundColor = .clear
        storeCollectionView.backgroundView = UIView(frame: .zero)
        
    }
    
    func setLocationManger() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()
    }
    
    func goMyLocation()
    {
        if(isAgreeTermission == true)
        {
            let latitude = Float((locationManager.location?.coordinate.latitude)!)
            let longitude = Float((locationManager.location?.coordinate.longitude)!)
            let zoom = 18
            
            // 내위치로 카메라 이동
            let camera = GMSCameraPosition.camera(withLatitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude), zoom: Float(zoom))
            self.gMapView?.animate(to: camera)
        }
    }
    
    func getMyLocation() -> CLLocation?
    {
        if(isAgreeTermission == true)
        {
            return locationManager.location
        }
        else
        {
            return nil
        }
    }
    
    
    // 특정 객체 선택
    func selectStore(index:Int!){
        if markers.count > index {
            gMapView.selectedMarker = markers[index]
            let latitude = markers[index].position.latitude
            let longitude = markers[index].position.longitude
            let selectZoom = 19
            
            let camera = GMSCameraPosition.camera(withLatitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude), zoom: Float(selectZoom))
                self.gMapView?.animate(to: camera)
        }
    }
}

extension StoreInfoGmapViewController:UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storeList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreInfoGMapCollectionViewCell", for: indexPath) as? StoreInfoGMapCollectionViewCell
        {
            cell.setLayout()
            cell.data = storeList?[indexPath.row]
            
            return cell
        }
        else
        {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        print(currentPage)
        
        selectStore(index: currentPage)
    }
}


extension StoreInfoGmapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            print("Location WhenInUse")
            gMapView.isMyLocationEnabled = true
            //locationManager.startUpdatingLocation()
            isAgreeTermission = true
            goMyLocation()
            break
        case .denied:
            print("Location Denied")
            //gMapView.isMyLocationEnabled = false
            //locationManager.stopUpdatingLocation()
            isAgreeTermission = false
            
            let message = "설정 -> 응답하라경기북부 앱 -> 위치 접근 권한을 허용으로 바꿔야 사용하실 수 있습니다."
            
            let alert = UIAlertController(title: "위치정보 거절", message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: { (action) in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion:{
                //self.navigationController?.dismiss(animated: true, completion: nil)
            })
            
            break
        case .notDetermined:
            print("Location notDetermined")
            //gMapView.isMyLocationEnabled = false
            //locationManager.stopUpdatingLocation()
            isAgreeTermission = false
            
            let message = "설정 -> 응답하라경기북부 앱 -> 위치 접근 권한을 허용으로 바꿔야 사용하실 수 있습니다."
            
            let alert = UIAlertController(title: "위치정보 거절", message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: { (action) in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion:{
                //self.navigationController?.dismiss(animated: true, completion: nil)
            })
            break
        case .restricted:
            print("Location restricted")
            //gMapView.isMyLocationEnabled = false
            //locationManager.stopUpdatingLocation()
            //isLocation = false
            break
        default:
            print("default")
            //isLocation = false
            break
        }
        //reload()
    }
    /*
     func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
     //위치가 업데이트될때마다
     if let coor = manager.location?.coordinate {
     locationManager.requestWhenInUseAuthorization()
     
     /*
     let center = CLLocationCoordinate2D(latitude: coor.latitude , longitude: coor.longitude)
     let rad = CLLocationDistance(1000)
     let circle = GMSCircle(position: center, radius: rad)
     circle.map = mapView
     */
     }
     }
     */
}



extension StoreInfoGmapViewController:GMSMapViewDelegate
{
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        var indexNum = 0
        for mark in markers {
            if marker == mark {
                break
            }
            indexNum += 1
        }
        storeCollectionView.scrollToItem(at: IndexPath(row: indexNum, section: 0), at: .left, animated: true)
        
        return false
    }
}



class StoreInfoGMapCollectionViewCell:UICollectionViewCell
{
    @IBOutlet var containerView: UIView!
    @IBOutlet var thumbImgView: UIImageView!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    var data:NearStore? {
        didSet(oldVal)
        {
            if let newVal = data as? NearStore
            {
                thumbImgView.cacheImage(urlString: newVal.thumbnail ?? "")
                titleLabel.text = newVal.name ?? ""
                
                
                let dist = NSString(string:newVal.dist ?? "0").floatValue
                
                var strDist = ""
                
                if (dist < 1000)
                {
                    strDist = String(Int(dist)) + "m"
                }
                else
                {
                    strDist = String(format: "%.1fkm", arguments: [(dist / 1000)])
                }
                
                distanceLabel.text = strDist
            }
        }
    }
    
    public func setLayout()
    {
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        containerView.layer.borderWidth = 1
    }
}
