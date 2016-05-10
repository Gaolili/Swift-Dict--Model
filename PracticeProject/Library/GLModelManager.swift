//
//  GLModelManager.swift
//  PracticeProject
//
//  Created by gaolili on 16/5/6.
//  Copyright © 2016年 mRocker. All rights reserved.
//

import UIKit
/**
 *   模型协议，返回的字段对应模型的字段
 */
@objc public protocol GLModelProtocol{
    /* 将服务器返回的字段，对应为某个字段 
       例如服务器返回 {id:123}
     static func propertyMappingDict() -> [String : String]! {
        return ["user_id":"id"]
     }
    */
    
 optional   static  func propertyMappingDict() -> [String:String]!
}

public class GLModelManager:NSObject{
    
    private static let instance = GLModelManager()
    public class var shareManager : GLModelManager{
         return instance
    }
        /// 模型缓存 [类名：模型信息字典]
    var clssPropertyCache = [String:[String:String]]()
    
    //MARK: - 字典转化为模型
    /**
     字典转化为模型
     
     - parameter dict: 字典
     - parameter cls:  模型的类
     
     - returns: 模型
     */
    func gl_objectWithDictionary(dict:NSDictionary,cls:AnyClass) -> AnyObject? {
        // 动态获取命名空间
        let propertyList = classPropertyList(cls)
        let obj:AnyObject = (cls as! NSObject.Type).init()
        
        let proMapDict = cls.propertyMappingDict?()
        for (k,_) in propertyList {
            let value = dict[k]
            if let pro :String = proMapDict?[k] {
                obj.setValue(dict[pro], forKey: k)
            }else{
                obj.setValue(value, forKey: k)
            }
            
          }
      return obj
        
    }
    //MARK: - 数组转为模型数组
    /**
     数组转为模型数组
     
     - parameter array: 数组
     - parameter cls:   模型类型
     
     - returns: 模型数组
     */
    func gl_objectWithArray(array:NSArray ,cls:AnyClass) ->[AnyObject]? {
        var list = [AnyObject]()
        for value in array {
            let type = "\(value.classForCoder)"
            if type == "NSDictionary" {
                if  let subObj:AnyObject = gl_objectWithDictionary(value as! NSDictionary, cls: cls) {
                    list.append(subObj)
                }
            }else if type == "NSArray" {
                if let subObj:AnyObject = gl_objectWithArray(value as! NSArray, cls: cls) {
                    list.append(subObj)
                }
            }
        }
        if list.count > 0 {
            return list
        }
        return nil
    }
    
    //MARK: - 模型转为字典
    /// 模型转为字典
    
    func  gl_DictionaryWithObject(obj:AnyObject) -> [String:AnyObject]? {
        
        // 1. 获取模型的属性列表
        let objDict = classPropertyList(obj.classForCoder)
        
        var result = [String:AnyObject]()
        
        
        for (k,v) in objDict {
            var value:AnyObject? = obj.valueForKey(k)
            if value == nil {
                value = NSNull()
            }
            if v.isEmpty || value === NSNull() {
                result[k] =  value
            }else{
                let type = "\(value?.classForCoder)"
                var subValue : AnyObject?
                if type == "NSArray" {
                    subValue = gl_arrayWithObje(value! as! [AnyObject])
                } else {
                    subValue = gl_DictionaryWithObject(value!)
                }
                if subValue == nil {
                    subValue = NSNull()
                }
                result[k] = subValue
            }
 
        }
        
        if result.count > 0 {
            return result
        }else{
            return nil
        }
    }
    
   //MARK: - 模型数组转字典数组
    /**
     模型数组转字典数组
     
     - parameter array: 模型数组
     
     - returns: 字典数组
     */
    func gl_arrayWithObje(array:[AnyObject]) -> [AnyObject]? {
        var result = [AnyObject]()
        
        for value in array {
            let type = "\(value.classForCoder)"
            
            var subValue: AnyObject?
            if type == "NSArray" {
                subValue = gl_arrayWithObje(value as! [AnyObject])
            } else {
                subValue = gl_DictionaryWithObject(value)
            }
            if subValue != nil {
                result.append(subValue!)
            }
        }
        
        if result.count > 0 {
            return result
        } else {
            return nil
        }

    }
    
    
    //MARK: - 获取某个类的全部属性
     // 获取某个类的全部属性
    func classPropertyList(cls:AnyClass) -> [String:String] {
        if let cache = clssPropertyCache["\(cls)"] {
             return cache
        }
        // 属性列表
        var count: UInt32 = 0
        let propertys = class_copyPropertyList(cls, &count)
        
        var infoDict = [String:String]()
        for i in 0..<count {
            let property = propertys[Int(i)]
            
            // 属性名称
            let cname = property_getName(property)
            let name = String.fromCString(cname)!
            infoDict[name] = ""
            
        }
        free(propertys)
        // 写入缓冲池
        clssPropertyCache["\(cls)"] = infoDict
        return infoDict
     }
}


 