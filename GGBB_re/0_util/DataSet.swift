//
//  DataSet.swift
//  GGBB_re
//
//  Created by 송시온 on 07/05/2019.
//  Copyright © 2019 송시온. All rights reserved.
//

import Foundation

public class StoreThumb
{
    public var imgSrc:String = ""
    public var distance:String = ""
    public var storeName:String = ""
    public var viewCnt:Int = 0
    public var reviewCnt:Int = 0
    public var likeCnt:Int = 0
    
    
    public static func getTestData() -> [StoreThumb]
    {
        var storeList:[StoreThumb] = []
        
        for num in 1...100
        {
            var item = StoreThumb()
            item.imgSrc = "test"
            item.distance = "test"
            item.storeName = "test"
            item.viewCnt = 100 * num
            item.reviewCnt = 222 * num
            item.likeCnt = 333 * num
            
            storeList.append(item)
        }
        
        return storeList
    }
}
