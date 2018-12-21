//
//  TrainModel.swift
//  Master
//
//  Created by 孙云飞 on 2018/12/19.
//  Copyright © 2018 syf. All rights reserved.
//

import UIKit

class TrainModel: NSObject {

    var icon:String?
    var name:String?
    var address:String?
    var intro:String?
    var type:String?
    var time:String?
    var describe:String?
    var trainId:String?
}

class TrainBMModel: NSObject {
    
    var icon:String?
    var name:String?
    var userId:String?
    var trainId:String?
}

class TrainASKModel: NSObject {
    
    var replay:String?
    var userName:String?
    var ask:String?
    
}


class TrainTools: NSObject {
    
    //获取训练列表
    static func post_train(success:@escaping ((Array<TrainModel>) ->()),failure:@escaping ((String) -> ())){
        
        let bquery:BmobQuery = BmobQuery.init(className: "train")
        bquery.findObjectsInBackground { (array, error) in
            
            if error != nil{
                
                failure("数据请求失败")
            }else{
                
                let rArray:Array<BmobObject> = array as! Array<BmobObject>
                var mArrays:Array<TrainModel> = Array.init()
                for obj:BmobObject in rArray{
                    
                    let model:TrainModel = TrainModel()
                    model.trainId = obj.objectId
                    model.name = obj.object(forKey: "name") as? String
                    model.icon = obj.object(forKey: "icon") as? String
                    model.intro = obj.object(forKey: "intro") as? String
                    model.time = obj.object(forKey: "time") as? String
                    model.address = obj.object(forKey: "address") as? String
                    model.type = obj.object(forKey: "type") as? String
                    model.describe = obj.object(forKey: "describe") as? String
                    mArrays.append(model)
                }
                
                success(mArrays)
            }
        }
    }
    
    
    
    //获取报名的训练
    static func post_obtainCareTrain(success:@escaping ((Array<TrainBMModel>) ->()),failure:@escaping ((String) -> ())){

        let d:UserDefaults = UserDefaults.init()
        let account:String? = d.object(forKey: "location_user") as? String

        let bquery:BmobQuery = BmobQuery.init(className: "user_xl")
        bquery.whereKey("userId", equalTo: account)
        bquery.findObjectsInBackground { (array, error) in

            if error != nil{

                failure("数据请求失败")
            }else{

                let rArray:Array<BmobObject> = array as! Array<BmobObject>
                var mArrays:Array<TrainBMModel> = Array.init()
                for obj:BmobObject in rArray{

                    let model:TrainBMModel = TrainBMModel()

                    model.userId = obj.object(forKey: "userId") as? String
                    model.name = obj.object(forKey: "name") as? String
                    model.trainId = obj.object(forKey: "trainId") as? String
                    model.icon = obj.object(forKey: "icon") as? String
                    mArrays.append(model)
                }

                success(mArrays)
            }
        }
    }

    //报名训练
    static func post_careTrain(_ model:TrainModel,success:@escaping (() ->()),failure:@escaping ((String) -> ())){

        let d:UserDefaults = UserDefaults.init()
        let account:String? = d.object(forKey: "location_user") as? String

        //先判断数据是否已经有对应的数据了
        post_obtainCareTrain(success: { (array) in

            var flag:Bool = false
            for obj:TrainBMModel in array{

                if obj.trainId == model.trainId{

                    failure("已经报名成功了,无需再次报名")
                    flag = true
                    break
                }
            }

            if !flag{


                let obj:BmobObject = BmobObject.init(className: "train_bm")
                obj.setObject(model.trainId, forKey: "trainId")
                obj.setObject(model.icon, forKey: "icon")
                obj.setObject(model.name, forKey: "name")
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


    //获取提问
    static func post_tw(success:@escaping ((Array<TrainASKModel>) ->()),failure:@escaping ((String) -> ())){

        let bquery:BmobQuery = BmobQuery.init(className: "train_zx")
        bquery.findObjectsInBackground { (array, error) in

            if error != nil{

                failure("数据请求失败")
            }else{

                let rArray:Array<BmobObject> = array as! Array<BmobObject>
                var mArrays:Array<TrainASKModel> = Array.init()
                for obj:BmobObject in rArray{

                    let model:TrainASKModel = TrainASKModel()
                    model.userName = obj.object(forKey: "userName") as? String
                    model.replay = obj.object(forKey: "replay") as? String
                    model.ask = obj.object(forKey: "ask") as? String
                    mArrays.append(model)
                }

                success(mArrays)
            }
        }
    }


    //提交提问
    static func post_xltw(_ model:TrainASKModel,success:@escaping (() ->()),failure:@escaping ((String) -> ())){

        //materQuestion
        let obj:BmobObject = BmobObject.init(className: "train_zx")
        obj.setObject(model.ask, forKey: "ask")
        let d:UserDefaults = UserDefaults.init()
        let account:String? = d.object(forKey: "location_user") as? String
        obj.setObject(account, forKey: "userName")
        obj.saveInBackground { (flag, error) in
            if flag{

                success()

            }else{

                failure((error?.localizedDescription)!)
            }
        }
    }
    
}
