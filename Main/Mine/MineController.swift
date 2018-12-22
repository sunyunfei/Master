//
//  MineController.swift
//  MasterSports
//
//  Created by --- on 2018/12/13.
//  Copyright © 2018 ---. All rights reserved.
//

import UIKit

class MineController: UITableViewController {

    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var setBtn: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        setCurView(icon, 5, 1, UIColor.darkGray)
        
        setCurView(nameLabel, 3, 0.5, UIColor.red)
        setCurView(sexLabel, 3, 0.5, UIColor.red)
        setCurView(setBtn, 20, 1, UIColor.red)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //显示数据
        let user:UserModel? = OptionTools.obtainUser()
        if let u:UserModel = user {
            
            if let s = u.icon{
                
                //icon.kf.setImage(with: URL.init(string: (u.icon)!))
                icon.sd_setImage(with: URL.init(string: (u.icon)!), completed: nil)
            }
            nameLabel.text = "名称:" + (u.name)!
            sexLabel.text = "性别:" + (u.sex)!
        }
    }

    // 推出登录
    @IBAction func clickOutBtn(_ sender: Any) {
        
        //本地数据删除
        let d:UserDefaults = UserDefaults.init()
        d.removeObject(forKey: "location_user")
        d.synchronize()
        OptionTools.presentLoginVC()
    }
    
    func setCurView(_ view:UIView,_ round:CGFloat,_ width:CGFloat,_ color:UIColor){
        
        view.layer.cornerRadius = round
        view.layer.masksToBounds = true
        view.layer.borderWidth = width
        view.layer.borderColor = color.cgColor
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            let vc:MineShowTableViewController = MineShowTableViewController()
            vc.hidesBottomBarWhenPushed = true
            vc.row = indexPath.row
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else{
            
            if indexPath.row == 0{
                
                //清除缓存
                //let size = SDImageCache.shared().getSize()
                SDImageCache.shared().clearDisk(onCompletion: nil)
                self.headView.makeToast("清除缓存成功")

            }else{
                
                //反馈
                let story:UIStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
                let vc:FeedbackViewController = story.instantiateViewController(withIdentifier: "fk") as! FeedbackViewController
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
