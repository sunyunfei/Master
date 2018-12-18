//
//  RegistryViewController.swift
//  Master
//
//  Created by --- on 2018/12/10.
//  Copyright © 2018 ---. All rights reserved.
//

import UIKit

class RegistryViewController: RootViewController {

    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var pwdField: UITextField!
    @IBOutlet weak var accountField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "注册"
        setCurView(registerBtn, 5, 1, UIColor.white)
        setCurView(centerView, 5, 1, UIColor.white)
    }
    

    @IBAction func clickRegistry(_ sender: Any) {
        
        //判断是否输入正确
        let account:String = accountField.text!
        let pwd:String = pwdField.text!
        
        if account.count <= 0 || pwd.count <= 0 {
            
            self.view.makeToast("请输入账号或者密码")
            return
        }else if account.count < 5 || pwd.count < 5 {
            
            self.view.makeToast("账号或者密码最少5位")
            return
        }
        
        self.view.makeToastActivity(.center)
        //请求bmob数据
        let bmob:BmobObject = BmobObject.init(className: "user")
        bmob.setObject(account, forKey: "account")
        bmob.setObject(pwd, forKey: "pwd")
        bmob.setObject(account, forKey: "name")
        bmob.setObject("http://i10.hoopchina.com.cn/hupuapp/bbs/966/16313966/thread_16313966_20180726164538_s_65949_o_w1024_h1024_62044.jpg?x-oss-process=image/resize,w_800/format,jpg", forKey: "icon")
        bmob.setObject("男", forKey: "sex")
        bmob.saveInBackground { (success, error) in
            
            if success{
                self.view.hideToastActivity()
                //注册成功，返回登录
                self.navigationController?.popViewController(animated: true)
            }else{
                self.view.hideToastActivity()
                self.view.makeToast("注册失败")
            }
        }
    }
    
    //取消键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
}
