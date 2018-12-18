//
//  SetController.swift
//  MasterSports
//
//  Created by --- on 2018/12/13.
//  Copyright © 2018 ---. All rights reserved.
//

import UIKit
import Photos
class SetController: UITableViewController {

    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var sexBtn: UISegmentedControl!
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var icon: UIImageView!
    var iconStr:String = ""
    var user:UserModel?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "修改个人信息"
        
        OptionTools.setCurView(icon, 38, 0.5, UIColor.red)
        
        OptionTools.setCurView(submitBtn, 8, 1, UIColor.red)
        
        //显示数据
        user = OptionTools.obtainUser()
        if let u:UserModel = user {
            
            //icon.kf.setImage(with: URL.init(string: (u.icon)!))
            icon.sd_setImage(with: URL.init(string: (u.icon)!), completed: nil)
            iconStr = (u.icon)!
            inputField.text = u.name
            if (u.sex)! == "男" {
                sexBtn.selectedSegmentIndex = 0
            }else{
                sexBtn.selectedSegmentIndex = 1
            }
        }
        
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(clickIcon))
        
        icon.isUserInteractionEnabled = true
        icon.addGestureRecognizer(tap)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hidesBottomBarWhenPushed = true
    }

    //选择投降
    @objc func clickIcon(){
        
        let album = JDAlbumGroupController()
        album.selectImgsClosure1 = { [weak self] (assets: [PHAsset]) in
            
            for index in 0..<assets.count {
                
                self?.getLitImage(asset: assets[index], callback: { (image) in
                    self?.icon.image = image
                    //上传
                    let data:Data? = image?.pngData()
                    
                    if let d = data{
                        
                        self?.view.makeToastActivity(.center)
                        UserTools.post_data(d, success: { (name) in
                            
                            self?.view.hideToastActivity()
                            self?.user?.icon = name
                        }, failure: { (error) in
                            
                            self?.view.hideToastActivity()
                            self?.view.makeToast(error)
                        })
                    }
                })
            }
        }
        
        let nav = UINavigationController(rootViewController: album)
        
        self.present(nav, animated: true, completion: nil)
    }
    
    //提交
    @IBAction func clickSubmitBtn(_ sender: Any) {
        
        //判断姓名是否有
        let name:String = (inputField.text)!
        if name.count <= 0 {
            
            self.view.makeToast("请输入姓名")
            return
        }
        
        //开始上传
        var sex:String = "男"
        if sexBtn.selectedSegmentIndex == 1 {
            sex = "女"
        }
        if let u = user{
            
            u.sex = sex
            u.name = name
            self.view.makeToastActivity(.center)
            UserTools.post_updateUser(u, success: {
                self.view.hideToastActivity()
                
                self.navigationController?.popViewController(animated: true)
            }) { (error) in
                
                self.view.hideToastActivity()
                self.view.makeToast(error)
            }
        }
        
        
    }
    
    
    
    
    typealias ImgCallBackType = (UIImage?)->()
    //获取缩略图
    private func getLitImage(asset: PHAsset,callback: @escaping ImgCallBackType){
        PHImageManager.default().requestImage(for: asset,
                                              targetSize: CGSize(width: 100, height: 100) , contentMode: .aspectFill,
                                              options: nil, resultHandler: {
                                                (image, _: [AnyHashable : Any]?) in
                                                if image != nil{
                                                    callback(image)
                                                }
                                                
        })
        
    }
}
