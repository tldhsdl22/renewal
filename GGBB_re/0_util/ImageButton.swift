//
//  ImageButton.swift
//  GGBB_re
//
//  Created by 송시온 on 15/05/2019.
//  Copyright © 2019 송시온. All rights reserved.
//

import UIKit

@IBDesignable
class ImageButton: UIButton {
    @IBInspectable var leftHandImage: UIImage? {
        didSet {
            leftHandImage = leftHandImage?.withRenderingMode(.alwaysOriginal)
            setupImages()
        }
    }
    @IBInspectable var rightHandImage: UIImage? {
        didSet {
            rightHandImage = rightHandImage?.withRenderingMode(.alwaysOriginal)
            setupImages()
        }
    }
    
    @IBInspectable var borderHandColor: UIColor? {
        didSet {
            setupImages()
        }
    }

    
    func setupImages() {
        let margin:CGFloat = 10
        if let leftImage = leftHandImage {
            let leftImageView = UIImageView(image: leftImage)
            let height = self.frame.height * 0.6
            let width = height
            let xPos = self.frame.width - self.frame.width + margin
            let yPos = (self.frame.height - height) / 2
            
            leftImageView.frame = CGRect(x: xPos, y: yPos, width: width, height: height)
            self.addSubview(leftImageView)
        }
        
        if let rightImage = rightHandImage {
            let rightImageView = UIImageView(image: rightImage)
            //rightImageView.tintColor = COLOR_BLUE
            
            let height = self.frame.height * 0.6
            let width = height * 0.25
            let xPos = self.frame.width - width - margin
            let yPos = (self.frame.height - height) / 2

            rightImageView.frame = CGRect(x: xPos, y: yPos, width: width, height: height)
            self.addSubview(rightImageView)
        }
 /*
        if let leftImage = leftHandImage {
            self.setImage(leftImage, for: .normal)
            self.imageView?.contentMode = .scaleAspectFill
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: self.frame.width - (self.imageView?.frame.width)!)
        }
        
        if let rightImage = rightHandImage {
            let rightImageView = UIImageView(image: rightImage)
            //rightImageView.tintColor = COLOR_BLUE
            
            let height = self.frame.height * 0.2
            let width = height
            let xPos = self.frame.width - width
            let yPos = (self.frame.height - height) / 2
            
            rightImageView.frame = CGRect(x: xPos, y: yPos, width: width, height: height)
            self.addSubview(rightImageView)
        }*/

        
        if let borderColor = borderHandColor {
            self.layer.borderColor = borderColor.cgColor
            self.layer.borderWidth = 1
            self.layer.cornerRadius = 5
        }
    }
}

