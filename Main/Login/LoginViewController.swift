//
//  LoginViewController.swift
//  Master
//
//  Created by --- on 2018/12/10.
//  Copyright © 2018 ---. All rights reserved.
//

import UIKit

class LoginViewController: RootViewController {

    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var pwdField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var accountField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "登录"
        
        setCurView(loginBtn, 5, 1, UIColor.white)
        setCurView(registerBtn, 5, 1, UIColor.white)
        setCurView(centerView, 5, 1, UIColor.white)
    }
    

    //跳转注册
    @IBAction func clickRegistryBtn(_ sender: Any) {
        
        let story:UIStoryboard = UIStoryboard.init(name: "Login", bundle: nil)
        let vc:RegistryViewController = story.instantiateViewController(withIdentifier: "registry") as! RegistryViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //登录事件
    @IBAction func clickLogin(_ sender: Any) {
        
        //判断是否输入正确
        
        let account:String = accountField.text!
        let pwd:String = pwdField.text!
        
        if account.count <= 0 || pwd.count <= 0 {
            
            self.view.makeToast("请输入账号或者密码")
            return
        }
        
        self.view.makeToastActivity(.center)
        //请求bmob数据
        let bquery:BmobQuery = BmobQuery(className: "user")
        bquery.whereKey("account", equalTo: account)
        bquery.findObjectsInBackground { (array, error) in
            
            if error != nil{
                
                //失败了
                self.view.hideToastActivity()
                self.view.makeToast("没有此用户")
            }else{
                
                if (array?.count)! > 0 {
                    let obj:BmobObject = array?[0] as! BmobObject
                    let pwd2:String = obj.object(forKey: "pwd") as! String
                    //判断是否相等
                    if pwd2 == pwd{
                        
                        
                        let model:UserModel = UserModel()
                        model.name = obj.object(forKey: "name") as? String
                        model.account = account
                        model.icon = obj.object(forKey: "icon") as? String
                        model.sex = obj.object(forKey: "sex") as? String
                        model.userId = obj.objectId
                        OptionTools.saveUser(model)
                        
                        //说明登录成功
                        //存储账号
                        let d:UserDefaults = UserDefaults.init()
                        d.set(account, forKey: "location_user")
                        d.synchronize()
                        //退出
                        self.view.hideToastActivity()
                        self.dismiss(animated: true, completion: nil)
                    }else{
                        self.view.hideToastActivity()
                        self.view.makeToast("账号或者密码错误")
                    }
                }else{
                    
                    self.view.hideToastActivity()
                    self.view.makeToast("登录失败")
                }
            }
        }
    }
    
    
    //取消键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
}
