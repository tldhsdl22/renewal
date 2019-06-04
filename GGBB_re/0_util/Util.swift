//
//  util.swift
//  GGBB_re
//
//  Created by 송시온 on 03/05/2019.
//  Copyright © 2019 송시온. All rights reserved.
//

import Foundation
import UIKit

public class Util
{
    public static var AppColor:UIColor {
        return UIColor(red: 237/255, green: 96/255, blue: 76/255, alpha: 1)
    }
    public static var ColorOrange:UIColor {
        let orange = UIColor(red: 243/255, green: 143/255, blue: 89/255, alpha: 1.0)
        return orange
    }
    public static var ColorRed:UIColor {
        let red = UIColor(red: 255/255, green: 140/255, blue: 140/255, alpha: 1.0)
        return red
    }
    public static var ColorBlue:UIColor {
        let blue = UIColor(red: 140/255, green: 205/255, blue: 255/255, alpha: 1.0)
        return blue
    }
    
    
    public static func setButtonImage(btn:UIButton, width:Int, height:Int){
        let imgSize = CGSize(width: width + 8, height: height)
        UIGraphicsBeginImageContext(imgSize)
        
        var thumbnailRect = CGRect.zero
        thumbnailRect.origin = CGPoint(x: 0, y: 0)
        thumbnailRect.size.width = CGFloat(width)
        thumbnailRect.size.height = CGFloat(height)
        
        var img = btn.imageView?.image
        img?.draw(in: thumbnailRect)
        btn.setImage(img, for: UIControl.State.normal)
        
        let sizeImg = UIGraphicsGetImageFromCurrentImageContext()
        btn.setImage(sizeImg, for: UIControl.State.normal)
        UIGraphicsEndImageContext()
        btn.contentVerticalAlignment = .center
        btn.contentMode = .center
    }
    
    public static func setAnchor(baseView:UIView, newView:UIView)
    {
        newView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            let guide = baseView.safeAreaLayoutGuide
            newView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
            newView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
            newView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
            newView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        } else {
            NSLayoutConstraint(item: newView,
                               attribute: .top,
                               relatedBy: .equal,
                               toItem: baseView, attribute: .top,
                               multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: newView,
                               attribute: .leading,
                               relatedBy: .equal, toItem: baseView,
                               attribute: .leading,
                               multiplier: 1.0,
                               constant: 0).isActive = true
            NSLayoutConstraint(item: newView, attribute: .trailing,
                               relatedBy: .equal,
                               toItem: baseView,
                               attribute: .trailing,
                               multiplier: 1.0,
                               constant: 0).isActive = true
            NSLayoutConstraint(item: newView, attribute: .bottom,
                               relatedBy: .equal,
                               toItem: baseView,
                               attribute: .bottom,
                               multiplier: 1.0,
                               constant: 0).isActive = true
        }

    }
}



let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func cacheImage(urlString: String){
        let url = URL(string: urlString)
        
        //image = self.image//UIImage(named:"no_img")
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        if( url != nil)
        {
            URLSession.shared.dataTask(with: url!) {
                data, response, error in
                if let response = data {
                    DispatchQueue.main.async {
                        let imageToCache = UIImage(data: data!)
                        if imageToCache != nil
                        {
                            imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
                            self.image = imageToCache
                        }
                    }
                }
                }.resume()
            }
    }
}

