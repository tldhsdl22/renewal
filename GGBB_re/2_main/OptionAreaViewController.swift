//
//  OptionAreaView.swift
//  GGBB_re
//
//  Created by 송시온 on 09/05/2019.
//  Copyright © 2019 송시온. All rights reserved.
//
import UIKit

class OptionAreaViewController: UIViewController {
    
    @IBOutlet var btn01: UIButton!
    @IBOutlet var btn02: UIButton!
    @IBOutlet var btn03: UIButton!
    @IBOutlet var btn04: UIButton!
    @IBOutlet var btn05: UIButton!
    @IBOutlet var btn06: UIButton!
    @IBOutlet var btnApply: UIButton!
    @IBOutlet var emptyArea: UIView!
    @IBOutlet var bottomNSLayout: NSLayoutConstraint!
    @IBOutlet var bottomView: UIView!
    
    var selectedAreaNum:Int = 200
    var selectColor:UIColor?
    var backColor:UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomNSLayout.constant = -(self.view.frame.height - bottomView.bounds.minY)

        selectColor = btn01.currentTitleColor
        backColor = btn01.backgroundColor
        
        btnApply.layer.cornerRadius = 10
        btn01.layer.cornerRadius = 10
        btn02.layer.cornerRadius = 10
        btn03.layer.cornerRadius = 10
        btn04.layer.cornerRadius = 10
        btn05.layer.cornerRadius = 10
        btn06.layer.cornerRadius = 10
        
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
        //self.dismiss(animated: true, completion: nil)
    }

    
    @IBAction func close(_ sender: Any) {
        isApply = true
        
        slideAnimate()
    }
    @IBAction func clickedBtn01(_ sender: Any) {
        selectBtn(index: 0)
    }
    @IBAction func clickedBtn02(_ sender: Any) {
        selectBtn(index: 1)
    }
    @IBAction func clickedBtn03(_ sender: Any) {
        selectBtn(index: 2)
    }
    
    @IBAction func clickedBtn04(_ sender: Any) {
        selectBtn(index: 3)
    }
    
    @IBAction func clickedBtn05(_ sender: Any) {
        selectBtn(index: 4)
    }

    @IBAction func clickedBtn06(_ sender: Any) {
        selectBtn(index: 5)
    }
    
    var isApply = false
    
    func slideAnimate()
    {
        if( bottomNSLayout.constant == 0 )
        {
            bottomNSLayout.constant = -(self.view.frame.height - bottomView.bounds.minY)

            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (_) in
                if(self.isApply == true)
                { self.performSegue(withIdentifier: "unwindToStoreThumbFromOptionAreaViewController", sender: self)
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
    
    
    
    func selectBtn(index:Int)
    {
        btn01.setTitleColor(selectColor, for: .normal)
        btn01.backgroundColor = backColor
        btn02.setTitleColor(selectColor, for: .normal)
        btn02.backgroundColor = backColor
        btn03.setTitleColor(selectColor, for: .normal)
        btn03.backgroundColor = backColor
        btn04.setTitleColor(selectColor, for: .normal)
        btn04.backgroundColor = backColor
        btn05.setTitleColor(selectColor, for: .normal)
        btn05.backgroundColor = backColor
        btn06.setTitleColor(selectColor, for: .normal)
        btn06.backgroundColor = backColor
        
        switch(index)
        {
        case 0:
            btn01.setTitleColor(Util.AppColor, for: .normal)
            btn01.backgroundColor = Util.AppColor.withAlphaComponent(0.2)
            selectedAreaNum = 200
            break
        case 1:
            btn02.setTitleColor(Util.AppColor, for: .normal)
            btn02.backgroundColor = Util.AppColor.withAlphaComponent(0.2)
            selectedAreaNum = 201
            break
        case 2:
            btn03.setTitleColor(Util.AppColor, for: .normal)
            btn03.backgroundColor = Util.AppColor.withAlphaComponent(0.2)
            selectedAreaNum = 202
            break
        case 3:
            btn04.setTitleColor(Util.AppColor, for: .normal)
            btn04.backgroundColor = Util.AppColor.withAlphaComponent(0.2)
            selectedAreaNum = 203
            break
        case 4:
            btn05.setTitleColor(Util.AppColor, for: .normal)
            btn05.backgroundColor = Util.AppColor.withAlphaComponent(0.2)
            selectedAreaNum = 204
            break
        case 5:
            btn06.setTitleColor(Util.AppColor, for: .normal)
            btn06.backgroundColor = Util.AppColor.withAlphaComponent(0.2)
            selectedAreaNum = 205
            break
        default:
            break
        }
    }
}
