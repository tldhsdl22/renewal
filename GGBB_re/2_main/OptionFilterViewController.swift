//
//  OptionFilterViewController.swift
//  GGBB_re
//
//  Created by 송시온 on 10/05/2019.
//  Copyright © 2019 송시온. All rights reserved.
//

import UIKit

class OptionFilterViewController: UIViewController {
    @IBOutlet var filterTablewView: UITableView!
    @IBOutlet var foodTypeCollectionView: UICollectionView!
    @IBOutlet var areaTypeCollectionView: UICollectionView!
    @IBOutlet var filterArea1: UIView!
    @IBOutlet var filterArea2: UIView!
    @IBOutlet var filterArea3: UIView!
    @IBOutlet var collectionViewHeight: NSLayoutConstraint!

    
    let arrSorted = ["추천수 많은 순", "리뷰수 많은 순", "조회수 높은 순", "최신 순", "가까운 순"]
    var arrKindName:[String]?
    //var arrKindName = ["전체", "한식", "일식", "중식", "양식", "카페", "주점", "기타"]
    let arrKindImg = ["36_menu_all_normal", "36_menu_korea_normal", "36_menu_japan_normal", "36_menu_china_normal", "36_menu_america_normal", "36_menu_cafe_normal", "36_menu_drink_normal", "36_menu_other_normal"]
    let arrKindSelectedImg =  ["36_menu_all_selected", "36_menu_korea_selected", "36_menu_japan_selected", "36_menu_china_selected", "36_menu_america_selected", "36_menu_cafe_selected", "36_menu_drink_selected", "36_menu_other_selected"]
    
    let arrKindImg_sleep = ["40_bed_grey_1x", "40_hotel_grey_1x", "40_motel_grey_1x", "40_pension_grey_1x"]
    let arrKindSelectedImg_sleep =  [ "40_bed_white_1x", "40_hotel_white_1x", "40_motel_white_1x", "40_pension_white_1x"]


    let arrArea = ["지역 전체", "의정부", "동두천", "양주", "포천", "노원"]

    
    var preCell:OptionFilterTableCell?
    var orgColor:UIColor?
    
    
    var preAreaCell:OptionFilterAreaCell?
    var orgBackColor:UIColor?
    var orgTintColor:UIColor?
    
    var selectedSort:Int = 0
    var selectedKind:Int = 0
    var selectedArea:Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadViews()
        //foodTypeCollectionView.allowsMultipleSelection = true
        
        self.navigationItem.title = "필터"
        setLayout()
        
        
        let itemCnt = arrKindName?.count ?? 0
        if(itemCnt  > 4 )
        { collectionViewHeight.constant  = 200
        }
        else if (itemCnt > 0)
        {
            collectionViewHeight.constant  = 100
        }
        else
        {
            filterArea2.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reloadViews()
    }
    
    private func setLayout()
    {
        filterArea1.layer.borderColor = UIColor.lightGray.cgColor
        filterArea1.layer.borderWidth = 1
        
        filterArea2.layer.borderColor = UIColor.lightGray.cgColor
        filterArea2.layer.borderWidth = 1
        
        filterArea3.layer.borderColor = UIColor.lightGray.cgColor
        filterArea3.layer.borderWidth = 1
    }
    
    private func reloadViews()
    {
        filterTablewView.reloadData()
        foodTypeCollectionView.reloadData()
        areaTypeCollectionView.reloadData()
    }
    
    @IBAction func applyOption(_ sender: Any) {
        //self.dismiss(animated: true, completion: nil)
        //self.navigationController?.popViewController(animated: true)
        
        self.performSegue(withIdentifier: "unwindToStoreThumbFromOptionFilterViewController", sender: self)
    }
}

// tableview
extension OptionFilterViewController: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSorted.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionFilterTableCell", for: indexPath) as! OptionFilterTableCell
        cell.nameLabel.text = arrSorted[indexPath.row]
        cell.checkImageView.image = UIImage(named: "36_unchecked_1x")
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    // cell 크기
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    // 셀이 선택되면
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tmpCell = preCell as? OptionFilterTableCell
        if (tmpCell != nil)
        {
            tmpCell?.nameLabel.textColor = orgColor
        }
        
        if let cell = tableView.cellForRow(at: indexPath) as? OptionFilterTableCell
        {
            if( cell != preCell )
            {
                preCell?.checkImageView.image = UIImage(named: "36_unchecked_1x")

                preCell = cell
                orgColor = cell.nameLabel.textColor
                
            }
            
            cell.checkImageView.image = UIImage(named: "36_checked_1x")
            cell.nameLabel.textColor = Util.AppColor
            selectedSort = indexPath.section * 4 + (indexPath.row + 1)
        }
    }
}


extension OptionFilterViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == self.foodTypeCollectionView)
        {
            return arrKindName?.count ?? 0
        }
        else
        {
            return 6
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == self.foodTypeCollectionView)
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OptionFilterFoodTypeCell", for: indexPath) as! OptionFilterFoodTypeCell
            cell.nameLabel.text = arrKindName?[indexPath.row]
            
            if(arrKindName?.contains("한식") ?? false)
            {
                cell.imageView.image = UIImage(named: arrKindImg[indexPath.row])
            }
            else if(arrKindName?.contains("호텔") ?? false)
            {
                cell.imageView.image = UIImage(named: arrKindImg_sleep[indexPath.row])
            }

            
            cell.backView.layer.cornerRadius = cell.backView.frame.width / 2
            cell.backView.backgroundColor = UIColor.groupTableViewBackground


            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OptionFilterAreaCell", for: indexPath) as! OptionFilterAreaCell
            cell.nameLabel.text = arrArea[indexPath.row]
            
            cell.backView.layer.cornerRadius = cell.backView.frame.height / 2
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(collectionView == self.foodTypeCollectionView)
        {
            let itemCnt = arrKindName?.count ?? 0
            let rowCnt = CGFloat(integerLiteral:itemCnt/4)
            let size = CGSize(width: ((collectionView.frame.width) / 4) - 10, height: collectionView.frame.height / rowCnt - 10)
            return size
        }
        else
        {
            let size = CGSize(width: ((collectionView.frame.width) / 3) - 10, height: collectionView.frame.height / 2 - 10)
            return size
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? OptionFilterFoodTypeCell
        {
            cell.backView.backgroundColor = UIColor.groupTableViewBackground
            if(arrKindName?.contains("한식") ?? false)
            {
                cell.imageView.image = UIImage(named: arrKindSelectedImg[indexPath.row])
            }
            else if(arrKindName?.contains("호텔") ?? false)
            {
                cell.imageView.image = UIImage(named: arrKindSelectedImg_sleep[indexPath.row])
            }

            cell.nameLabel.textColor = UIColor.lightGray
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView == self.foodTypeCollectionView)
        {
            if let cell = collectionView.cellForItem(at: indexPath) as? OptionFilterFoodTypeCell
            {
                selectedKind = indexPath.section * 4 + (indexPath.row + 1)
                cell.backView.backgroundColor = Util.AppColor
                
                if(arrKindName?.contains("한식") ?? false)
                {
                    cell.imageView.image = UIImage(named: arrKindSelectedImg[indexPath.row])
                }
                else if(arrKindName?.contains("호텔") ?? false)
                {
                    cell.imageView.image = UIImage(named: arrKindSelectedImg_sleep[indexPath.row])
                }
                cell.nameLabel.textColor = Util.AppColor
            }
        }
        else
        {
            if let cell = collectionView.cellForItem(at: indexPath) as? OptionFilterAreaCell
            {
                
                if(preAreaCell != nil)
                {
                    preAreaCell?.nameLabel.textColor = orgTintColor
                    preAreaCell?.backView.backgroundColor = orgBackColor
                }
                if(preAreaCell != cell)
                {
                    preAreaCell = cell
                    orgBackColor = cell.backView.backgroundColor
                    orgTintColor = cell.nameLabel.textColor
                }
                
                cell.nameLabel.textColor = Util.AppColor
                cell.backView.backgroundColor = Util.AppColor.withAlphaComponent(0.2)
                
                selectedArea = indexPath.section * 3 + (indexPath.row + 1)
            }
        }
    }
}
