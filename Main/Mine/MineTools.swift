//
//  MineTools.swift
//  Master
//
//  Created by 孙云飞 on 2018/12/22.
//  Copyright © 2018 syf. All rights reserved.
//

import UIKit

class MineTools: NSObject {

    
    
    //创建
    static func post_createFK(_ str:String,success:@escaping (() ->()),failure:@escaping ((String) -> ())){
        
        //materQuestion
        let obj:BmobObject = BmobObject.init(className: "feed_back")
        obj.setObject(str, forKey: "content")
        let user:UserModel? = OptionTools.obtainUser()
        obj.setObject(user?.userId, forKey: "userId")
        obj.saveInBackground { (flag, error) in
            if flag{
                
                success()
                
            }else{
                
                failure((error?.localizedDescription)!)
            }
        }
    }
}
