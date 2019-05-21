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
    
    var preCell:UITableViewCell?
    var orgColor:UIColor?
    
    
    var preAreaCell:OptionFilterAreaCell?
    var orgBackColor:UIColor?
    var orgTintColor:UIColor?
    
    var selectedSort:Int = 0
    var selectedKind:Int = 0
    var selectedArea:Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterTablewView.reloadData()
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionFilterTableCell", for: indexPath) as! OptionFilterTableCell
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = .clear
        cell.selectedBackgroundView = bgColorView
        
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
                preCell = cell
                orgColor = cell.nameLabel.textColor
            }
            
            cell.nameLabel.textColor = Util.AppColor
            selectedSort = indexPath.section * 4 + (indexPath.row + 1)
        }
        
        
        
        //let bgColorView = UIView()
        //bgColorView.backgroundColor = .red
        //cell.selectedBackgroundView = bgColorView
        
        
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
            return 8
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
            
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OptionFilterAreaCell", for: indexPath) as! OptionFilterAreaCell
            return cell
        }        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(collectionView == self.foodTypeCollectionView)
        {
            let size = CGSize(width: ((collectionView.frame.width) / 4) - 10, height: collectionView.frame.height / 2 - 10)
            return size
        }
        else
        {
            let size = CGSize(width: ((collectionView.frame.width) / 3) - 10, height: collectionView.frame.height / 2 - 10)
            return size
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView == self.foodTypeCollectionView)
        {
            if let cell = collectionView.cellForItem(at: indexPath) as? OptionFilterFoodTypeCell
            {
                let innerView = UIView()
                innerView.backgroundColor = .red
                cell.selectedBackgroundView = innerView
                
                selectedKind = indexPath.section * 4 + (indexPath.row + 1)
            }
        }
        else
        {
            if let cell = collectionView.cellForItem(at: indexPath) as? OptionFilterAreaCell
            {
                
                if(preAreaCell != nil)
                {
                    preAreaCell?.nameLabel.textColor = orgTintColor
                    preAreaCell?.nameLabel.backgroundColor = orgBackColor
                }
                if(preAreaCell != cell)
                {
                    preAreaCell = cell
                    orgBackColor = cell.nameLabel.backgroundColor
                    orgTintColor = cell.nameLabel.textColor
                }
                
                cell.nameLabel.textColor = Util.AppColor
                cell.nameLabel.backgroundColor = Util.AppColor.withAlphaComponent(0.2)
                
                selectedArea = indexPath.section * 3 + (indexPath.row + 1)
            }
        }
    }
}
