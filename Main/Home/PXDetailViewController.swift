//
//  PXDetailViewController.swift
//  MasterSports
//
//  Created by --- on 2018/12/12.
//  Copyright © 2018 ---. All rights reserved.
//

import UIKit
import AVKit
class PXDetailViewController: RootViewController,UITableViewDelegate,UITableViewDataSource {
    //视频数据
    @IBOutlet weak var bgIcon: UIImageView!
    var playerVC: AVPlayerViewController?
    var isMaster:Bool = true//默认是大师详情
    var masterModel:MasterModel?
    var activeModel:ActiveModel?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var attentionLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var videoBtn: UIButton!
    @IBOutlet weak var footBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        if isMaster{
            self.title = "大师"
            playerVC = AVPlayerViewController()
            let remoteURL = NSURL(string: (masterModel?.video)!)
            let player:AVPlayer = AVPlayer.init(url: remoteURL! as URL)
            playerVC?.player = player
            
        }else{
            
            self.title = "活动"
        }
        
       
        setCurView(videoBtn, 20, 1, UIColor.red)
        setCurView(icon, 60, 2, UIColor.white)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView.init()
        tableView.separatorStyle = .none
        
        showData()
    }
    
    //显示数据
    func showData(){
        
        if isMaster {
            footBtn.setTitle("收藏大师", for: .normal)
            footBtn.backgroundColor = UIColor.orange
            //icon.kf.setImage(with: URL.init(string: (masterModel?.icon)!))
            icon.sd_setImage(with: URL.init(string: (masterModel?.icon)!), completed: nil)
            nameLabel.text = masterModel?.name
            attentionLabel.text = (masterModel?.attention)! + " 人已收藏"
            //bgIcon.kf.setImage(with: URL.init(string: (masterModel?.icon)!))
            bgIcon.sd_setImage(with: URL.init(string: (masterModel?.icon)!), completed: nil)
        }else{
            
            videoBtn.isHidden = true
            footBtn.setTitle("报名活动", for: .normal)
            //icon.kf.setImage(with: URL.init(string: (activeModel?.icon)!))
            icon.sd_setImage(with: URL.init(string: (activeModel?.icon)!), completed: nil)
            nameLabel.text = activeModel?.name
            attentionLabel.text = (activeModel?.bm)! + " 人已报名"
            //bgIcon.kf.setImage(with: URL.init(string: (activeModel?.icon)!))
            bgIcon.sd_setImage(with: URL.init(string: (activeModel?.icon)!), completed: nil)
        }
    }
    

    //点击底部按钮
    @IBAction func clickFootBtn(_ sender: Any) {
        
        if isMaster {
            
            //收藏大师
            
            self.view.makeToastActivity(.center)
            HomePost.post_careMaster(masterModel!, success: {
                
                self.view.hideToastActivity()
                self.view.makeToast("收藏成功")
            }) { (error) in
                
                self.view.hideToastActivity()
                self.view.makeToast(error)
            }
        }else{
            
            //报名活动
            self.view.makeToastActivity(.center)
            HomePost.post_bmActive(activeModel!, success: {
                
                self.view.hideToastActivity()
                self.view.makeToast("报名成功")
            }) { (error) in
                
                self.view.hideToastActivity()
                self.view.makeToast(error)
            }
        }
    }
    
    //点击看视频
    @IBAction func clickVideoBtn(_ sender: Any) {
        
        self.present(playerVC!, animated: true, completion: nil)
        playerVC?.player?.play()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if isMaster{
            
            cell.textLabel?.text = masterModel?.intro
        }else{
            
            cell.textLabel?.text = activeModel?.describe
        }
        cell.selectionStyle = .none
        cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
        cell.textLabel?.textColor = UIColor.lightGray
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    

}
