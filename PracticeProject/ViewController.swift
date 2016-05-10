//
//  ViewController.swift
//  PracticeProject
//
//  Created by gaolili on 16/4/25.
//  Copyright © 2016年 mRocker. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    lazy  var textView:UITextView = {
        let tx = UITextView()
        tx.text = "请输入要转换的字典或数组字典进行转换！"
        tx.layer.borderWidth = 1
        tx.layer.borderColor = UIColor.blackColor().CGColor
          return tx
    }()
   
   lazy var dicToObjBtn:UIButton = {
      let btn = UIButton()
      btn.setTitle("字典转为模型", forState: .Normal)
      btn.titleLabel?.font = UIFont.systemFontOfSize(10)
      btn.layer.borderWidth = 1
      btn.layer.borderColor = UIColor.redColor().CGColor
      btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
      btn.tag = 100
      return btn
    }()
    
    lazy var objToDicBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("模型转为字典", forState: .Normal)
        btn.titleLabel?.font = UIFont.systemFontOfSize(10)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.redColor().CGColor
        btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        btn.tag = 101
        return btn
    }()
    
    lazy var arrToObjBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("数组字典转为数组模型", forState: .Normal)
        btn.titleLabel?.font = UIFont.systemFontOfSize(10)
        btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.redColor().CGColor
        btn.tag = 102
        return btn
    }()
    
    lazy var objToArrBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("模型转为数组字典", forState: .Normal)
        btn.titleLabel?.font = UIFont.systemFontOfSize(10)
        btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.redColor().CGColor
        btn.tag = 103
        return btn
    }()
    
    lazy var resultLabel:UILabel = {
        let lab = UILabel()
        lab.numberOfLines = 0
        lab.layer.borderWidth = 1
        lab.layer.borderColor = UIColor.redColor().CGColor
        return lab
    
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(textView)
        self.view.addSubview(dicToObjBtn)
        self.view.addSubview(objToDicBtn)
        self.view.addSubview(arrToObjBtn)
        self.view.addSubview(objToArrBtn)
        self.view.addSubview(resultLabel)
      }
   
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let ViewW = CGRectGetWidth(UIScreen.mainScreen().bounds) - 50
        textView.frame = CGRectMake(10, 100, CGRectGetWidth(UIScreen.mainScreen().bounds) - 20, 100)
        dicToObjBtn.frame = CGRectMake(10, CGRectGetMaxY(textView.frame) + 20, ViewW/4 , 30)
        objToDicBtn.frame = CGRectMake(CGRectGetMaxX(dicToObjBtn.frame) + 10, CGRectGetMaxY(textView.frame) + 20, ViewW/4  , 30)
        arrToObjBtn.frame = CGRectMake(CGRectGetMaxX(objToDicBtn.frame) + 10, CGRectGetMaxY(textView.frame) + 20, ViewW/4  , 30)
        objToArrBtn.frame = CGRectMake(CGRectGetMaxX(arrToObjBtn.frame) + 10, CGRectGetMaxY(textView.frame) + 20, ViewW/4  , 30)
        resultLabel.frame = CGRectMake(10, CGRectGetMaxY(objToArrBtn.frame) + 10, CGRectGetWidth(UIScreen.mainScreen().bounds) - 20, 200)
        
        dicToObjBtn.addTarget(self, action: #selector(ViewController.clickBtnAction(_:)), forControlEvents: .TouchUpInside)
        objToDicBtn.addTarget(self, action: #selector(ViewController.clickBtnAction(_:)), forControlEvents: .TouchUpInside)
        arrToObjBtn.addTarget(self, action: #selector(ViewController.clickBtnAction(_:)), forControlEvents: .TouchUpInside)
        objToArrBtn.addTarget(self, action: #selector(ViewController.clickBtnAction(_:)), forControlEvents: .TouchUpInside)
    }
    
    
    func clickBtnAction(btn:UIButton) {
        if textView.text.characters.count == 0 {
            return
        }
        
        switch btn.tag {
          case 100:
            let userDic = ["user_age":11,"phone":"1034546546451431"]
            let model =  dictToObject(userDic) as! UserModel
            textView.text = "\(userDic)"
            resultLabel.text = "转换结果:\n" + " user.age =\(model.age)\n" + "  user.phone= \(model.phone!)"
            
         case 101:
            let userDic = ["user_age":11,"phone":"1034546546451431"]
            let model =  dictToObject(userDic) as! UserModel
            let modelDic = objectToDic(model)
            textView.text = "\(model)"
            resultLabel.text = "转换结果:\n" + " Dict =\(modelDic)\n"
            
        case 102:
            let userDic = [["user_age":11,"phone":"1034546546451431"],["user_age":12,"phone":"1000000000"]]
            let modelArr =  arrDictToObject(userDic) as![UserModel]
            textView.text = "\(userDic)"
            resultLabel.text = "转换结果:\n" + " one model age  =\(modelArr.first?.age)\n" + " two model age  =\(modelArr.last?.age)\n"
            
        case 103:
            let userDic = [["user_age":11,"phone":"1034546546451431"],["user_age":12,"phone":"1000000000"]]
            let modelArr =  arrDictToObject(userDic) as![UserModel]
            let modelDict = arrObjectToArrDict(modelArr)
            textView.text = "\(modelArr)"
            resultLabel.text = "转换结果:\n" + " modelDict  =\(modelDict!)\n"
        
         default:
             print("default")
        }
    }
    
    
    func dictToObject(dic:[String:AnyObject]) -> AnyObject? {
        let modelTool = GLModelManager.shareManager
        let model = modelTool.gl_objectWithDictionary(dic, cls: UserModel.self) as! UserModel
        return model

    }
    
    func objectToDic(obj:AnyObject) -> [String:AnyObject]? {
        let modelTool = GLModelManager.shareManager
        let model = modelTool.gl_DictionaryWithObject(obj)
        return model
    }
    
    
    func arrDictToObject(array:NSArray ) -> [AnyObject]? {
        let modelTool = GLModelManager.shareManager
        let arr = modelTool.gl_objectWithArray(array, cls: UserModel.self) as! [UserModel]
        return arr
    }
    
    func arrObjectToArrDict(obj:[AnyObject]) -> [AnyObject]? {
        let modelTool = GLModelManager.shareManager
        let arr = modelTool.gl_arrayWithObje(obj)
        return arr
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

