//
//  PXModel.swift
//  MasterSports
//
//  Created by --- on 2018/12/12.
//  Copyright © 2018 ---. All rights reserved.
//

import UIKit

class PXModel: NSObject {
    
    
}

//大师
class MasterModel: NSObject {
    
    var objectId:String?
    var icon:String?
    var video:String?
    var attention:String?
    var intro:String?
    var name:String?
    var masterId:String?
}

//活动
class ActiveModel: NSObject {
    
    var objectId:String?
    var bm:String?
    var icon:String?
    var describe:String?
    var name:String?
    var activeId:String?
    var time:String?
}


//比赛
class BSModel: NSObject {
    
    var intro:String?
    var icon:String?
    var address:String?
    var time:String?
    var name:String?
    var bsId:String?

}

//大师收藏
class MasterAttentionModel: NSObject {
    
    var masterId:String?
    var icon:String?
    var userId:String?
    var name:String?
}

//活动报名
class ActiveAttentionModel: NSObject {
    
    var activeId:String?
    var userId:String?
    var name:String?
}

//比赛报名
class BSBMModel: NSObject {
    
    var icon:String?
    var userId:String?
    var address:String?
    var time:String?
    var name:String?
    var bsId:String?
}

//数据请求
class HomePost: NSObject {
    
    //比赛请求接口
    static func post_bs(success:@escaping ((Array<BSModel>) ->()),failure:@escaping ((String) -> ())){
        
        let bquery:BmobQuery = BmobQuery.init(className: "bs")
        bquery.findObjectsInBackground { (array, error) in
            
            if error != nil{
                
                failure("数据请求失败")
            }else{
                
                let rArray:Array<BmobObject> = array as! Array<BmobObject>
                var homeArrays:Array<BSModel> = Array.init()
                for obj:BmobObject in rArray{
                    
                    let model:BSModel = BSModel()
                    model.bsId = obj.object(forKey: "bsId") as? String
                    model.name = obj.object(forKey: "name") as? String
                    model.icon = obj.object(forKey: "icon") as? String
                    model.intro = obj.object(forKey: "intro") as? String
                    model.address = obj.object(forKey: "address") as? String
                    let date:Date = obj.createdAt
                    model.time = self.dateConvertString(date: date, dateFormat: "yyyy-MM-dd hh:mm:ss")
                    homeArrays.append(model)
                }
                
                success(homeArrays)
            }
        }
    }
    
    //大师请求接口
    static func post_master(success:@escaping ((Array<MasterModel>) ->()),failure:@escaping ((String) -> ())){
        
        let bquery:BmobQuery = BmobQuery.init(className: "master")
        bquery.findObjectsInBackground { (array, error) in
            
            if error != nil{
                
                failure("数据请求失败")
            }else{
                
                let rArray:Array<BmobObject> = array as! Array<BmobObject>
                var homeArrays:Array<MasterModel> = Array.init()
                for obj:BmobObject in rArray{
                    
                    let model:MasterModel = MasterModel()
                    model.objectId = obj.objectId
                    model.masterId = obj.object(forKey: "masterId") as? String
                    model.name = obj.object(forKey: "name") as? String
                    model.icon = obj.object(forKey: "icon") as? String
                    model.intro = obj.object(forKey: "intro") as? String
                    model.attention = obj.object(forKey: "attention") as? String
                    model.video = obj.object(forKey: "video") as? String
                    homeArrays.append(model)
                }
                
                success(homeArrays)
            }
        }
    }
    
    
    //活动请求接口
    static func post_active(success:@escaping ((Array<ActiveModel>) ->()),failure:@escaping ((String) -> ())){
        
        let bquery:BmobQuery = BmobQuery.init(className: "active")
        bquery.findObjectsInBackground { (array, error) in
            
            if error != nil{
                
                failure("数据请求失败")
            }else{
                
                let rArray:Array<BmobObject> = array as! Array<BmobObject>
                var homeArrays:Array<ActiveModel> = Array.init()
                for obj:BmobObject in rArray{
                    
                    let model:ActiveModel = ActiveModel()
                    model.objectId = obj.objectId
                    model.activeId = obj.object(forKey: "activeId") as? String
                    model.name = obj.object(forKey: "name") as? String
                    model.icon = obj.object(forKey: "icon") as? String
                    model.describe = obj.object(forKey: "describe") as? String
                    model.bm = obj.object(forKey: "bm") as? String
                    let date:Date = obj.createdAt
                    model.time = self.dateConvertString(date: date, dateFormat: "yyyy-MM-dd hh:mm:ss")
                    homeArrays.append(model)
                }
                
                success(homeArrays)
            }
        }
    }
    
    //获取关注的大师
    static func post_obtainCareMaster(success:@escaping ((Array<MasterAttentionModel>) ->()),failure:@escaping ((String) -> ())){
        
        let d:UserDefaults = UserDefaults.init()
        let account:String? = d.object(forKey: "location_user") as? String
        
        let bquery:BmobQuery = BmobQuery.init(className: "master_attention")
        bquery.whereKey("userId", equalTo: account)
        bquery.findObjectsInBackground { (array, error) in
            
            if error != nil{
                
                failure("数据请求失败")
            }else{
                
                let rArray:Array<BmobObject> = array as! Array<BmobObject>
                var mArrays:Array<MasterAttentionModel> = Array.init()
                for obj:BmobObject in rArray{
                    
                    let model:MasterAttentionModel = MasterAttentionModel()
                    
                    model.masterId = obj.object(forKey: "masterId") as? String
                    model.name = obj.object(forKey: "name") as? String
                    model.icon = obj.object(forKey: "icon") as? String
                    model.userId = obj.object(forKey: "userId") as? String
                    mArrays.append(model)
                }
                
                success(mArrays)
            }
        }
    }
    
    //关注大师
    static func post_careMaster(_ model:MasterModel,success:@escaping (() ->()),failure:@escaping ((String) -> ())){
        
        let d:UserDefaults = UserDefaults.init()
        let account:String? = d.object(forKey: "location_user") as? String
        
        //先判断数据是否已经有对应的数据了
        post_obtainCareMaster(success: { (array) in
            
            var flag:Bool = false
            for obj:MasterAttentionModel in array{
                
                if obj.masterId == model.masterId{
                    
                    failure("已经关注过，无需再次关注")
                    flag = true
                    break
                }
            }
            
            if !flag{
                
                //materQuestion
                let obj:BmobObject = BmobObject.init(className: "master_attention")
                obj.setObject(model.masterId, forKey: "masterId")
                obj.setObject(model.icon, forKey: "icon")
                obj.setObject(model.name, forKey: "masterName")
                obj.setObject(account, forKey: "userId")
                obj.saveInBackground { (flag, error) in
                    if flag{
                        
                        let bmob:BmobObject = BmobObject.init(outDataWithClassName: "master", objectId: model.objectId)
                        if let str:String = model.attention{
                            
                            let count:Int = Int(str)!
                            bmob.setObject(String(count + 1), forKey: "attention")
                            bmob.updateInBackground(resultBlock: { (flag, error) in
                                
                                if flag{
                                    
                                    print("大师收藏人数+1")
                                }
                            })
                        }
                        
                        
                        success()
                        
                    }else{
                        
                        failure((error?.localizedDescription)!)
                    }
                }
            }
            
        }) { (error) in
            
            failure(error)
        }
        
    }
    
    //获取报名的活动
    static func post_obtainActive(success:@escaping ((Array<ActiveAttentionModel>) ->()),failure:@escaping ((String) -> ())){
        
        let d:UserDefaults = UserDefaults.init()
        let account:String? = d.object(forKey: "location_user") as? String
        
        let bquery:BmobQuery = BmobQuery.init(className: "active_bm")
        bquery.whereKey("userId", equalTo: account)
        bquery.findObjectsInBackground { (array, error) in
            
            if error != nil{
                
                failure("数据请求失败")
            }else{
                
                let rArray:Array<BmobObject> = array as! Array<BmobObject>
                var mArrays:Array<ActiveAttentionModel> = Array.init()
                for obj:BmobObject in rArray{
                    
                    let model:ActiveAttentionModel = ActiveAttentionModel()
                    
                    model.userId = obj.object(forKey: "userId") as? String
                    model.activeId = obj.object(forKey: "activeId") as? String
                    model.name = obj.object(forKey: "name") as? String
                    mArrays.append(model)
                }
                
                success(mArrays)
            }
        }
    }
    
    //报名活动
    static func post_bmActive(_ model:ActiveModel,success:@escaping (() ->()),failure:@escaping ((String) -> ())){
        
        let d:UserDefaults = UserDefaults.init()
        let account:String? = d.object(forKey: "location_user") as? String
        
        //先判断数据是否已经有对应的数据了
        post_obtainActive(success: { (array) in
            
            var flag:Bool = false
            for obj:ActiveAttentionModel in array{
                
                if obj.activeId == model.activeId{
                    
                    failure("已经报名过这个活动了")
                    flag = true
                    break
                }
            }
            
            if !flag{
                
                //materQuestion
                let obj:BmobObject = BmobObject.init(className: "active_bm")
                obj.setObject(model.activeId, forKey: "activeId")
                obj.setObject(model.name, forKey: "name")
                obj.setObject(account, forKey: "userId")
                obj.saveInBackground { (flag, error) in
                    if flag{
                        
                        success()
                        
                        let bmob:BmobObject = BmobObject.init(outDataWithClassName: "active", objectId: model.objectId)
                        if let str:String = model.bm{
                            
                            let count:Int = Int(str)!
                            bmob.setObject(String(count + 1), forKey: "bm")
                            bmob.updateInBackground(resultBlock: { (flag, error) in
                                
                                if flag{
                                    
                                    print("活动报名人数+1")
                                }
                            })
                        }
                        
                    }else{
                        
                        failure((error?.localizedDescription)!)
                    }
                }
            }
            
        }) { (error) in
            
            failure(error)
        }
        
    }
    
    //比赛报名
    //获取报过的
    static func post_obtainBsBm(success:@escaping ((Array<BSBMModel>) ->()),failure:@escaping ((String) -> ())){
        
        let d:UserDefaults = UserDefaults.init()
        let account:String? = d.object(forKey: "location_user") as? String
        
        let bquery:BmobQuery = BmobQuery.init(className: "bs_bm")
        bquery.whereKey("userId", equalTo: account)
        bquery.findObjectsInBackground { (array, error) in
            
            if error != nil{
                
                failure("数据请求失败")
            }else{
                
                let rArray:Array<BmobObject> = array as! Array<BmobObject>
                var mArrays:Array<BSBMModel> = Array.init()
                for obj:BmobObject in rArray{
                    
                    let model:BSBMModel = BSBMModel()
                    
                    model.bsId = obj.object(forKey: "bsId") as? String
                    model.name = obj.object(forKey: "name") as? String
                    model.icon = obj.object(forKey: "icon") as? String
                    model.userId = obj.object(forKey: "userId") as? String
                    model.time = obj.object(forKey: "time") as? String
                    model.address = obj.object(forKey: "address") as? String
                    mArrays.append(model)
                }
                
                success(mArrays)
            }
        }
    }
    
    //关注大师
    static func post_careBsBm(_ model:BSModel,success:@escaping (() ->()),failure:@escaping ((String) -> ())){
        
        let d:UserDefaults = UserDefaults.init()
        let account:String? = d.object(forKey: "location_user") as? String
        
        //先判断数据是否已经有对应的数据了
        post_obtainBsBm(success: { (array) in
            
            var flag:Bool = false
            for obj:BSBMModel in array{
                
                if obj.bsId == model.bsId{
                    
                    failure("已经报名过了")
                    flag = true
                    break
                }
            }
            
            if !flag{
                
                //materQuestion
                let obj:BmobObject = BmobObject.init(className: "bs_bm")
                obj.setObject(model.bsId, forKey: "bsId")
                obj.setObject(model.icon, forKey: "icon")
                obj.setObject(model.name, forKey: "name")
                obj.setObject(model.address, forKey: "address")
                obj.setObject(model.time, forKey: "time")
                obj.setObject(account, forKey: "userId")
                obj.saveInBackground { (flag, error) in
                    if flag{
                        
                        success()
                        
                    }else{
                        
                        failure((error?.localizedDescription)!)
                    }
                }
            }
            
        }) { (error) in
            
            failure(error)
        }
        
    }
    
    
    
    
    
    /// - Returns: 日期字符串
    static func dateConvertString(date:Date, dateFormat:String="yyyy-MM-dd") -> String {
        let timeZone = TimeZone.init(identifier: "UTC")
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: date)
        return date.components(separatedBy: " ").first!
    }
}
