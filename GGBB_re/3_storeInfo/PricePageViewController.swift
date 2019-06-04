//
//  PricePageViewController.swift
//  GGBB_re
//
//  Created by 송시온 on 15/05/2019.
//  Copyright © 2019 송시온. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire

class PricePageViewController: UIViewController
{
    public var num:String?
    public var type:String?
    
    public var itemInfo = IndicatorInfo(title: "")
    public var storeInfoDetail:StoreInfoDetail? = nil
    {
        didSet(oldVal)
        {
            updateDate.text = self.storeInfoDetail?.date
            priceTableView.reloadData()
        }
    }

    @IBOutlet var priceTableView: UITableView!
    @IBOutlet var updateDate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDetailData(num: num ?? "", type: type ?? "")
        
        priceTableView.allowsSelection = false
    }
    
    private func getDetailData(num:String, type:String)
    {
        let kakaoId = UserInfo.getUserId() ?? ""
        let param = ["num":num, "type":type, "kakaoID":kakaoId] as [String : Any]
        
        Alamofire.request("http://iloveggbb.com/app/main/store.php", method: .post, parameters: param)
            .responseJSON {(response) in
                switch response.result
                {
                case .success(let obj):
                    print("succss1")
                    if obj is NSDictionary
                    {
                        do
                        {
                            let jsonObj = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                            let data = try JSONDecoder().decode(StoreInfoDetail.self, from: jsonObj)
                            print(data.menu?.count ?? 0)
                            self.storeInfoDetail = data
                        }
                        catch
                        {
                            print("fail")
                            print(error.localizedDescription)
                        }
                    }
                    break
                case .failure(let error):
                    print("fail")
                    print(error.localizedDescription)
                    break
                }
                //print(response)
        }
    }
}

extension PricePageViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("StoreInfoDetailMenuCount: " + (String)(self.storeInfoDetail?.menu?.count ?? 0))
        return self.storeInfoDetail?.menu?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PricePageCell") as? PricePageCell
            else {
            return UITableViewCell()
        }
        
        var menuInfo = storeInfoDetail?.menu?[indexPath.row].menu ?? ":"
        
        //var arrMenuInfo = menuInfo.split(separator: ":")
        let arrMenuInfo = menuInfo.characters.split(separator: ":", omittingEmptySubsequences: true).map(String.init)
        
        cell.nameLabel.text = arrMenuInfo[0]
        if( arrMenuInfo[1].last == "원")
        {
            cell.priceLabel.text = arrMenuInfo[1]
        }
        else
        {
            cell.priceLabel.text = arrMenuInfo[1] + "원"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension PricePageViewController: IndicatorInfoProvider  {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}

class PricePageCell: UITableViewCell
{
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    
}
