//
//  StoreCollectionViewCell.swift
//  GGBB_re
//
//  Created by 송시온 on 07/05/2019.
//  Copyright © 2019 송시온. All rights reserved.
//

import UIKit

class StoreThumbCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var storeNameLabel: UILabel!
    @IBOutlet var viewLabel: UILabel!
    @IBOutlet var reviewLabel: UILabel!
    @IBOutlet var likeLabel: UILabel!
    
    var data:StoreThumb {
        get {
            return data
        }
        set(newVal){
            self.distanceLabel.text = newVal.distance
            self.storeNameLabel.text = newVal.storeName
            self.viewLabel.text = String(newVal.viewCnt)
            self.reviewLabel.text = String(newVal.reviewCnt)
            self.likeLabel.text = String(newVal.likeCnt)
        }
    }
    
    
}
