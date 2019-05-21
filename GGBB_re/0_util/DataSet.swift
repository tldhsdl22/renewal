//
//  DataSet.swift
//  GGBB_re
//
//  Created by 송시온 on 07/05/2019.
//  Copyright © 2019 송시온. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


public class StoreThumb:Codable
{
    var addr:String
    var coupon:String
    var date:String
    var detailShort:String
    var editor:String
    var gpsx:String
    var gpsy:String
    var holiday:String
    var intro:String
    var is19:String
    var isBeadal:String
    var isHide:String
    var isHot:String
    var isLoadMap:String
    var isNew:String
    var isRec:String
    var kind:String
    var location:String
    var name:String
    var num:String
    var open:String
    var parking:String
    var recommend:String
    var review:String
    var scrap:String
    var tel:String
    var thumbnail:String
    var type:String
    var view:String
}

class JSONResponse: Codable
{
    var result: Bool
    var msg: String
}

class ResultSign: Codable
{
    var result: String?
    var kakaoID: String?
    var message: String?
}


class ResultLogin: Codable
{
    var result: String?
    var message: String?
    var kakaoID: String?
    var userName: String?
    var thumbnail: String?
    var age: String?
    var location: String?
    var gender: String?
}
