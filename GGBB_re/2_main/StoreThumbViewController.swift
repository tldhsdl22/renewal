//
//  Test01.swift
//  GGBB_re
//
//  Created by 송시온 on 03/05/2019.
//  Copyright © 2019 송시온. All rights reserved.
//


import UIKit
import XLPagerTabStrip

class StoreThumbViewController: UIViewController {
    var itemInfo = IndicatorInfo(title: "storeThumb")
    var storeThumbList:[StoreThumb] = []
    
    @IBOutlet var storeCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = storeCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        storeThumbList = StoreThumb.getTestData()
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
        cell.data = storeThumbList[indexPath.row]
        
        cell.imageView.image = UIImage(named: "06_timer_1x")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
}

extension StoreThumbViewController: UICollectionViewDelegateFlowLayout
{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width / 2 - 15
        
        let sizes = CGSize(width: width, height: width * 1.5)
        
        return sizes
    }
}


