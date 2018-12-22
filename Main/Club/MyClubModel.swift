//
//  ClubModel.swift
//  Sports
//
//  Created by 孙云飞 on 2018/12/21.
//  Copyright © 2018 syf. All rights reserved.
//

import UIKit

class MyClubModel: NSObject {
    
    var icon:String?
    var name:String?
    var address:String?
    var intro:String?
    var time:String?
    var clubId:String?
    var video:String?
    var coach:String?
}

class CourseModel: NSObject {
    
    var name:String?
    var intro:String?
    var clubId:String?
    var coach:String?
    var courseId:String?
}


class CourseBMModel: NSObject {
    
    var name:String?
    var intro:String?
    var userId:String?
    var coach:String?
    var courseId:String?
}


//接口请求
class ClubTools: NSObject{
    
    //俱乐部
    static func post_club(success:@escaping ((Array<MyClubModel>) ->()),failure:@escaping ((String) -> ())){
        
        let bquery:BmobQuery = BmobQuery.init(className: "my_club")
        bquery.findObjectsInBackground { (array, error) in
            
            if error != nil{
                
                failure("数据请求失败")
            }else{
                
                let rArray:Array<BmobObject> = array as! Array<BmobObject>
                var mArrays:Array<MyClubModel> = Array.init()
                for obj:BmobObject in rArray{
                    
                    let model:MyClubModel = MyClubModel()
                    model.clubId = obj.objectId
                    model.name = obj.object(forKey: "name") as? String
                    model.icon = obj.object(forKey: "icon") as? String
                    model.intro = obj.object(forKey: "intro") as? String
                    
                    model.address = obj.object(forKey: "address") as? String
                    model.coach = obj.object(forKey: "coach") as? String
                    model.video = obj.object(forKey: "video") as? String
                    let date:Date = obj.createdAt
                    model.time = self.dateConvertString(date: date, dateFormat: "yyyy-MM-dd hh:mm:ss")
                    mArrays.append(model)
                }
                
                success(mArrays)
            }
        }
    }
    
    //获取俱乐部课程
    static func post_clubCourse(_ clubId:String,success:@escaping ((Array<CourseModel>) ->()),failure:@escaping ((String) -> ())){
        
        let bquery:BmobQuery = BmobQuery.init(className: "my_club_course")
        bquery.whereKey("clubId", equalTo: clubId)
        bquery.findObjectsInBackground { (array, error) in
            
            if error != nil{
                
                failure("数据请求失败")
            }else{
                
                let rArray:Array<BmobObject> = array as! Array<BmobObject>
                var mArrays:Array<CourseModel> = Array.init()
                for obj:BmobObject in rArray{
                    
                    let model:CourseModel = CourseModel()
                    
                    model.intro = obj.object(forKey: "intro") as? String
                    model.name = obj.object(forKey: "name") as? String
                    model.coach = obj.object(forKey: "coach") as? String
                    model.clubId = obj.object(forKey: "clubId") as? String
                    model.courseId = obj.objectId;
                    mArrays.append(model)
                }
                
                success(mArrays)
            }
        }
    }
    
    //根据课程id获取h课程
    static func post_clubCourseById(_ courseId:String,success:@escaping ((CourseModel) ->()),failure:@escaping ((String) -> ())){
        
        let bquery:BmobQuery = BmobQuery.init(className: "my_club_course")
        
        bquery.getObjectInBackground(withId: courseId) { (obj, error) in
            
            if error != nil{
                
                failure("数据请求失败")
            }else{
                
                let obj2:BmobObject = obj!
                
                let model:CourseModel = CourseModel()
                
                model.intro = obj2.object(forKey: "intro") as? String
                model.name = obj2.object(forKey: "name") as? String
                model.coach = obj2.object(forKey: "coach") as? String
                model.clubId = obj2.object(forKey: "clubId") as? String
                model.courseId = obj2.objectId;
                success(model)
            }
        }
        
    }
    
    //获取关注的课程
    static func post_careCourse(success:@escaping ((Array<CourseBMModel>) ->()),failure:@escaping ((String) -> ())){
        
        let d:UserDefaults = UserDefaults.init()
        let account:String? = d.object(forKey: "location_user") as? String
        
        let bquery:BmobQuery = BmobQuery.init(className: "club_bm")
        bquery.whereKey("userId", equalTo: account)
        bquery.findObjectsInBackground { (array, error) in
            
            if error != nil{
                
                failure("数据请求失败")
            }else{
                
                let rArray:Array<BmobObject> = array as! Array<BmobObject>
                var mArrays:Array<CourseBMModel> = Array.init()
                for obj:BmobObject in rArray{
                    
                    let model:CourseBMModel = CourseBMModel()
                    
                    model.intro = obj.object(forKey: "intro") as? String
                    model.name = obj.object(forKey: "name") as? String
                    model.coach = obj.object(forKey: "coach") as? String
                    model.userId = obj.object(forKey: "userId") as? String
                    model.courseId = obj.object(forKey: "courseId") as? String
                    mArrays.append(model)
                }
                
                success(mArrays)
            }
        }
    }
    
    
    //删除关注的课程
    static func post_deleteCareCourse(courseId:String,success:@escaping (() ->()),failure:@escaping ((String) -> ())){
        
        let d:UserDefaults = UserDefaults.init()
        let account:String? = d.object(forKey: "location_user") as? String
        
        let bquery:BmobQuery = BmobQuery.init(className: "club_bm")
        bquery.whereKey("userId", equalTo: account)
        bquery.whereKey("courseId", equalTo: courseId)
        bquery.findObjectsInBackground { (array, error) in
            
            if error != nil{
                
                failure("数据请求失败")
            }else{
                
                let rArray:Array<BmobObject> = array as! Array<BmobObject>
                for obj:BmobObject in rArray{
                    
                    obj.deleteInBackground({ (flag, error) in
                        
                        if flag {
                            
                            success()
                        }else{
                            
                            failure((error?.localizedDescription)!)
                        }
                    })
                }
            }
        }
    }
    
    //报名课程
    static func post_carecourse(_ model:CourseModel,success:@escaping (() ->()),failure:@escaping ((String) -> ())){
        
        let d:UserDefaults = UserDefaults.init()
        let account:String? = d.object(forKey: "location_user") as? String
        
        //先判断数据是否已经有对应的数据了
        post_careCourse(success: { (array) in
            
            var flag:Bool = false
            for obj:CourseBMModel in array{
                
                if obj.courseId == model.courseId{
                    
                    failure("已经报名成功了,无需再次报名")
                    flag = true
                    break
                }
            }
            
            if !flag{
                
                
                let obj:BmobObject = BmobObject.init(className: "club_bm")
                obj.setObject(model.courseId, forKey: "courseId")
                obj.setObject(model.intro, forKey: "intro")
                obj.setObject(model.name, forKey: "name")
                obj.setObject(account, forKey: "userId")
                obj.setObject(model.coach, forKey: "coach")
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
