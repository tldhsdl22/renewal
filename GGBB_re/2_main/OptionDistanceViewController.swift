//
//  OptionDistanceViewController.swift
//  GGBB_re
//
//  Created by 송시온 on 09/05/2019.
//  Copyright © 2019 송시온. All rights reserved.
//

import UIKit

class OptionDistanceViewController: UIViewController {
    @IBOutlet var slider: UISlider!
    @IBOutlet var labelDistance: UILabel!
    public var distance = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDistanceLabel()
    }
    
    @IBAction func close(_ sender: Any) {
        //self.dismiss(animated: true, completion: nil)
        
        self.performSegue(withIdentifier: "unwindToStoreThumbFromOptionDistanceViewController", sender: self)
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
        }
        else if(current == 1)
        {
            labelDistance.text = "1 km" // value의 text가 나타내는것은 current의 값이다.
        }
        else if(current == 2)
        {
            labelDistance.text = "3 km" // value의 text가 나타내는것은 current의 값이다.
        }
        else if(current == 3)
        {
            labelDistance.text = "5 km" // value의 text가 나타내는것은 current의 값이다.
        }
        else
        {
            labelDistance.text = "전체" // value의 text가 나타내는것은 current의 값이다.
        }
        
        distance = labelDistance.text ?? ""
    }
}

