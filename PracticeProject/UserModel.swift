//
//  UserModel.swift
//  PracticeProject
//
//  Created by gaolili on 16/5/6.
//  Copyright © 2016年 mRocker. All rights reserved.
//

import UIKit

class UserModel:NSObject ,GLModelProtocol {
    var age:Int64 = 0
    var phone:String?
    
    static func propertyMappingDict() -> [String : String]! {
        return ["age":"user_age"]
    }
}
