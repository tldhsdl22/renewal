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

/*
  = 301;
  = 203;
  = "\Uc0ac\Uad70\Uc790\Uae40\Ubc25";
  = 285;
  = "\Uc624\Uc804 10\Uc2dc ~ \Uc624\Ud6c4 9\Uc2dc";
  = "\Uac00\Ub2a5";
  = 8;
  = 6;
  = 1;
  = "031-846-2292";
  = "http://www.iloveggbb.com/main/eat/285/img/thumbnail.JPG";
  = 10;
  = 3444;
 */
public class SearchResult:Codable
{
    var num:String //
    var type:String //
    var name:String //
    var addr:String //
    var keyword:String?
    var kind:String //
    var location:String //
    var tel:String //
    var parking:String //
    var editor:String //
    var open:String //
    var gpsx:String //
    var gpsy:String //
    var thumbnail:String //
    var date:String //
    var holiday:String //
    var intro:String //
    var coupon:String //
    var detailShort:String //
    var isLoadMap:String //
    var isHot:String //
    var is19:String //
    var view:String //
    var review:String //
    var recommend:String //
    var scrap:String //
    var isNew:String //
    var isBeadal:String //
    var isHide:String //
    var isRec:String //
}

public class StoreThumb:Codable
{
    var dist:String
    var intro:String
    var isBeadal:String
    var isHide:String
    var isHot:String
    var isLoadMap:String
    var isNew:String;
    var isRec:String;
    var location:String;
    var name:String;
    var num:String;
    var postTime:String;
    var recommend:String;
    var review:String;
    var storeName:String;
    var thumbnail:String;
    var type:String;
    var view:String;
    var x:String;
    var y:String;
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


class ResultSNSLogin: Codable
{
    var result: String?
    var message: String?
    var kakaoID: String?
    var userName: String?
    var userAge: String?
    var userRegion: String?
    var userGender: String?
    var userProfileImageUrl: String?
    var signDate: String?
}

class StoreInfoDetail: Codable
{
    var isRec: String?
    var isScrap: String?
    var img: [String]?
    var reviewList: [ReviewInfo]?
    var menu: [MenuInfo]?
    
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


class ReviewInfo: Codable
{
    var num: String?
    var storeNum: String?
    var type: String?
    var kakaoID: String?
    var review: String?
    var url: String?
    var date: String?
    var storeReview: String?
    var blind: String?
    var ip: String?
    var nickName: String?
}


class ReviewResult: Codable
{
    var result: String?
}



class RecommendResult: Codable
{
    var result: String?
    var message: String?
}


class MenuInfo: Codable
{
    var num: String?
    var storeNum: String?
    var type: String?
    var menu: String?
    var date: String?
}



class NearStore: Codable
{
    var dist: String?
    var location: String?
    var name: String?
    var num: String?
    var thumbnail: String?
    var type: String?
    var x: String?
    var y: String?
}
