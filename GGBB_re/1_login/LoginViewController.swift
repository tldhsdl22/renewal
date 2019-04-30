//
//  ViewController.swift
//  GGBB_re
//
//  Created by 송시온 on 2019. 4. 24..
//  Copyright © 2019년 송시온. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var login4: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setBorder()
    }
    
    private func setBorder()
    {
        login4.layer.addBorder([.top, .bottom, .left, .right], color: UIColor.gray, width: 1.0, radius: 10)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CALayer {
    func addBorder(_ arr_edge: [UIRectEdge], color: UIColor, width: CGFloat, radius: CGFloat) {
        for edge in arr_edge {
            let border = CALayer()
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
                break
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
                break
            case UIRectEdge.right:
                border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
                break
            default:
                break
            }
            border.cornerRadius = radius
            border.backgroundColor = color.cgColor;
            self.addSublayer(border)
        }
    }
}
