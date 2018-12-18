//
//  OptionTools.swift
//  Master
//
//  Created by --- on 2018/12/10.
//  Copyright © 2018 ---. All rights reserved.
//

import UIKit
//用户信息存储路径
let accountPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! + ("account.ar")
class OptionTools: NSObject {

    
    //存储用户信息
    static func saveUser(_ user:UserModel){
    
        NSKeyedArchiver.archiveRootObject(user, toFile: accountPath)
    }
    
    //获取用户信息
    static func obtainUser() ->UserModel{
        
        let user:UserModel = NSKeyedUnarchiver.unarchiveObject(withFile: accountPath) as! UserModel
        return user
    }
    
    
    
    //弹出登录界面
    static func presentLoginVC(){
        
        //判断是否需要登录
        /*
         let d:UserDefaults = UserDefaults.init()
         let account:String? = d.object(forKey: "location_user") as? String
         if let a = account{
         
         if a.count > 0{
         
         //已经登陆了，无需再次登录
         return;
         }
         }
         */
        
        let story:UIStoryboard = UIStoryboard.init(name: "Login", bundle: nil)
        let login:LoginViewController = story.instantiateViewController(withIdentifier: "login") as! LoginViewController
        let nav:UINavigationController = UINavigationController.init(rootViewController: login)
        
        obtainTopVC()?.present(nav, animated: true, completion: nil)
    }
    
    //获取顶部视图
    static func obtainTopVC() ->UIViewController?{
        
        var window = UIApplication.shared.keyWindow
        //是否为当前显示的window
        if window?.windowLevel != UIWindow.Level.normal{
            let windows = UIApplication.shared.windows
            for  windowTemp in windows{
                if windowTemp.windowLevel == UIWindow.Level.normal{
                    window = windowTemp
                    break
                }
            }
        }
        
        let vc = window?.rootViewController
        return getTopVC(withCurrentVC: vc)
    }
    
    ///根据控制器获取 顶层控制器
    static func getTopVC(withCurrentVC VC :UIViewController?) -> UIViewController? {
        
        if VC == nil {
            print("找不到顶层控制器")
            return nil
        }
        
        if let presentVC = VC?.presentedViewController {
            //modal出来的 控制器
            return getTopVC(withCurrentVC: presentVC)
        }
        else if let tabVC = VC as? UITabBarController {
            // tabBar 的跟控制器
            if let selectVC = tabVC.selectedViewController {
                return getTopVC(withCurrentVC: selectVC)
            }
            return nil
        } else if let naiVC = VC as? UINavigationController {
            // 控制器是 nav
            return getTopVC(withCurrentVC:naiVC.visibleViewController)
        }
        else {
            // 返回顶控制器
            return VC
        }
    }
    
    
    
   static func setCurView(_ view:UIView,_ round:CGFloat,_ width:CGFloat,_ color:UIColor){
        
        view.layer.cornerRadius = round
        view.layer.masksToBounds = true
        view.layer.borderWidth = width
        view.layer.borderColor = color.cgColor
    }
}
