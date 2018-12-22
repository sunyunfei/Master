//
//  STModel.swift
//  Sports
//
//  Created by 孙云飞 on 2018/12/21.
//  Copyright © 2018 syf. All rights reserved.
//

import UIKit

class PrintModel: NSObject {
    var userName:String?
    var intro:String?
    var icon:String?
    var printId:String?
    var time:String?
    var userId:String?
    var pl:String?
}

//评论数据
class PrintPLModel: NSObject {
    var userName:String?
    var content:String?
    var printId:String?
    var time:String?
}


class PrintTools: NSObject {
    
    //晒图列表
    static func post_st(success:@escaping ((Array<PrintModel>) ->()),failure:@escaping ((String) -> ())){
        
        let bquery:BmobQuery = BmobQuery.init(className: "print")
        bquery.findObjectsInBackground { (array, error) in
            
            if error != nil{
                
                failure("数据请求失败")
            }else{
                
                let rArray:Array<BmobObject> = array as! Array<BmobObject>
                var mArrays:Array<PrintModel> = Array.init()
                for obj:BmobObject in rArray{
                    
                    let model:PrintModel = PrintModel()
                    model.intro = obj.object(forKey: "intro") as? String
                    model.userName = obj.object(forKey: "userName") as? String
                    model.icon = obj.object(forKey: "icon") as? String
                    model.printId = obj.objectId
                    
                    let date:Date = obj.createdAt
                    model.time = self.dateConvertString(date: date, dateFormat: "yyyy-MM-dd hh:mm:ss")
                    mArrays.append(model)
                }
                
                success(mArrays)
            }
        }
    }
    
    //晒图列表
    static func post_stbyId(success:@escaping ((Array<PrintModel>) ->()),failure:@escaping ((String) -> ())){
        
        let bquery:BmobQuery = BmobQuery.init(className: "print")
        let user:UserModel? = OptionTools.obtainUser()
        bquery.whereKey("userId", equalTo: user?.userId)
        bquery.findObjectsInBackground { (array, error) in
            
            if error != nil{
                
                failure("数据请求失败")
            }else{
                
                let rArray:Array<BmobObject> = array as! Array<BmobObject>
                var mArrays:Array<PrintModel> = Array.init()
                for obj:BmobObject in rArray{
                    
                    let model:PrintModel = PrintModel()
                    model.intro = obj.object(forKey: "intro") as? String
                    model.userName = obj.object(forKey: "userName") as? String
                    model.icon = obj.object(forKey: "icon") as? String
                    model.printId = obj.objectId
                    
                    let date:Date = obj.createdAt
                    model.time = self.dateConvertString(date: date, dateFormat: "yyyy-MM-dd hh:mm:ss")
                    mArrays.append(model)
                }
                
                success(mArrays)
            }
        }
    }
    
    //创建
    static func post_createST(_ model:PrintModel,success:@escaping (() ->()),failure:@escaping ((String) -> ())){
        
        //materQuestion
        let obj:BmobObject = BmobObject.init(className: "print")
        obj.setObject(model.intro, forKey: "intro")
        obj.setObject(model.icon, forKey: "icon")
        let user:UserModel? = OptionTools.obtainUser()
        if let u:UserModel = user {
            
            if let s = u.name{
                
                obj.setObject(s, forKey: "userName")
                
            }
        }
        obj.setObject(user?.userId, forKey: "userId")
        obj.saveInBackground { (flag, error) in
            if flag{
                
                success()
                
            }else{
                
                failure((error?.localizedDescription)!)
            }
        }
    }
    
    
    //晒图评论
    static func post_stpl(_ printId:String,success:@escaping ((Array<PrintPLModel>) ->()),failure:@escaping ((String) -> ())){
        
        let bquery:BmobQuery = BmobQuery.init(className: "print_pl")
        bquery.whereKey("printId", equalTo: printId)
        bquery.findObjectsInBackground { (array, error) in
            
            if error != nil{
                
                failure("数据请求失败")
            }else{
                
                let rArray:Array<BmobObject> = array as! Array<BmobObject>
                var mArrays:Array<PrintPLModel> = Array.init()
                for obj:BmobObject in rArray{
                    
                    let model:PrintPLModel = PrintPLModel()
                    model.content = obj.object(forKey: "content") as? String
                    model.userName = obj.object(forKey: "userName") as? String
                    model.printId = obj.objectId
                    
                    let date:Date = obj.createdAt
                    model.time = self.dateConvertString(date: date, dateFormat: "yyyy-MM-dd hh:mm:ss")
                    mArrays.append(model)
                }
                
                success(mArrays)
            }
        }
    }
    
    
    //提交评论
    static func post_createpl(_ model:PrintPLModel,success:@escaping (() ->()),failure:@escaping ((String) -> ())){
        
        let user:UserModel? = OptionTools.obtainUser()
        
        let obj:BmobObject = BmobObject.init(className: "print_pl")
        obj.setObject(model.content, forKey: "content")
        obj.setObject(model.printId, forKey: "printId")
        obj.setObject(user?.name, forKey: "userName")
        
        obj.saveInBackground { (flag, error) in
            if flag{
                
                success()
                
            }else{
                
                failure((error?.localizedDescription)!)
            }
        }
        
    }
    
    /// - Returns: 日期字符串
    static func dateConvertString(date:Date, dateFormat:String="yyyy-MM-dd HH:mm:ss") -> String {
        let timeZone = TimeZone.init(identifier: "UTC")
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: date)
        return date.components(separatedBy: " ").first!
    }
}
