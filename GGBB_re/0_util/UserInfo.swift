//
//  UserInfo.swift
//  GGBB_re
//
//  Created by 송시온 on 10/05/2019.
//  Copyright © 2019 송시온. All rights reserved.
//

import Foundation

public class UserInfo
{
    static func setUserInfo(userId:String?, name:String?, thumb:String?)
    {
        UserDefaults.standard.set(userId, forKey: "id")
        UserDefaults.standard.set(name, forKey: "name")
        UserDefaults.standard.set(thumb, forKey: "thumb")
        UserDefaults.standard.synchronize()
    }
    
    static func getUserId() -> String?
    {
        return UserDefaults.standard.value(forKey: "id") as? String
    }
    
    static func getUserName() -> String?
    {
        return  UserDefaults.standard.value(forKey: "name") as? String
    }
    
    static func getUserThumb() -> String?
    {
        return UserDefaults.standard.value(forKey: "thumb") as? String
    }
    
    static func setUserInfo(loginInfo:ResultLogin)
    {
        UserDefaults.standard.set(loginInfo.userName, forKey: "name")
        UserDefaults.standard.set(loginInfo.kakaoID, forKey: "id")
        UserDefaults.standard.set(loginInfo.thumbnail, forKey: "thumb")
        UserDefaults.standard.synchronize()
    }
    
    static func clearUserInfo()
    {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key.description)
        }
    }
}
