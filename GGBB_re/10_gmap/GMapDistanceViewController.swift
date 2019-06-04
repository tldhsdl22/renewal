//
//  GMapOptionViewController.swift
//  GGBB_re
//
//  Created by 송시온 on 27/05/2019.
//  Copyright © 2019 송시온. All rights reserved.
//

import UIKit

class GMapDistanceViewController: UIViewController {
    @IBOutlet var slider: UISlider!
    @IBOutlet var labelDistance: UILabel!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var bottomNSLayout: NSLayoutConstraint!
    @IBOutlet var emptyArea: UIView!
    @IBOutlet var applyBtn: UIButton!
    
    public var distance = 0
    var isApply = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomNSLayout.constant = -(self.view.frame.height - bottomView.bounds.minY)
        applyBtn.layer.cornerRadius = 10

        setDistanceLabel()
        addViewClickAction()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        slideAnimate()
    }
    
    func addViewClickAction()
    {
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(customDismiss))
        self.emptyArea.addGestureRecognizer(gesture)
    }

    @objc func customDismiss()
    {
        slideAnimate()
    }
    
    @IBAction func close(_ sender: Any) {
        isApply = true
        slideAnimate()
    }
    
    @IBAction func moveSlider(_ sender: Any) {
        setDistanceLabel()
    }
    
    func setDistanceLabel()
    {
        self.slider.value = roundf(self.slider.value)
        let current = Int(slider.value) //UISlider(sender)의 value를 Int로 캐스팅해서 current라는 변수로 보낸다.
        
        if(current == 0)
        {
            labelDistance.text = "500 m" // value의 text가 나타내는것은 current의 값이다.
            distance = 500
        }
        else if(current == 1)
        {
            labelDistance.text = "1 km" // value의 text가 나타내는것은 current의 값이다.
            distance = 1000
        }
        else if(current == 2)
        {
            labelDistance.text = "3 km" // value의 text가 나타내는것은 current의 값이다.
            distance = 3000
        }
        else if(current == 3)
        {
            labelDistance.text = "5 km" // value의 text가 나타내는것은 current의 값이다.
            distance = 5000
        }
        else
        {
            labelDistance.text = "전체" // value의 text가 나타내는것은 current의 값이다.
            distance = 0
        }
        
//        distance = labelDistance.text ?? ""
    }
    
    
    func slideAnimate()
    {
        if( bottomNSLayout.constant == 0 )
        {
            bottomNSLayout.constant = -(self.view.frame.height - bottomView.bounds.minY)
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (_) in
                
                if(self.isApply == true)
                {
                    self.performSegue(withIdentifier: "unwindToGMapViewControllerbFromGMapDistanceViewController", sender: self)
                }
                else
                {
                    self.dismiss(animated: false, completion: nil)
                }
                
            })
        }
        else
        {
            bottomNSLayout.constant = 0
            UIView.animate(withDuration: 0.5, delay:0, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
}

