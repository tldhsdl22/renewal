//
//  StoreCollectionViewCell.swift
//  GGBB_re
//
//  Created by 송시온 on 07/05/2019.
//  Copyright © 2019 송시온. All rights reserved.
//

import UIKit

class StoreThumbCollectionViewCell: UICollectionViewCell {
    @IBOutlet var containerView: UIView!
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
            self.distanceLabel.text = newVal.gpsx
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
            imageView.image = UIImage(named: "40_hotel_grey_1x")
            
            imageView.cacheImage(urlString: newVal.thumbnail)
            /*
            let url = URL(string: newVal.thumbnail)

            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                
                if error != nil {
                    print(error!)
                    return
                }
                
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data!)
                }
            }).resume()       */
            
            
        }
    }
}
