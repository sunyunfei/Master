//
//  ClubDetailViewController.swift
//  Sports
//
//  Created by 孙云飞 on 2018/12/21.
//  Copyright © 2018 syf. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
class MyDetailViewController: UITableViewController {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var bgIcon: UIImageView!
    var model:MyClubModel?
    var datas:Array<String> = Array()
    @IBOutlet weak var nameLabel: UILabel!
    
    /** 播放器 */
    var playerVC: AVPlayerViewController?
    override func viewDidLoad() {
        super.viewDidLoad()

        playerVC = AVPlayerViewController()
        let remoteURL = NSURL(string: (model?.video)!)
        let player = AVPlayer(url: remoteURL! as URL)
        playerVC?.player = player
        icon.sd_setImage(with: URL.init(string: (model?.icon)!), completed: nil)
        bgIcon.sd_setImage(with: URL.init(string: (model?.icon)!), completed: nil)
        
        OptionTools.setCurView(icon, 60, 1, UIColor.red)
        nameLabel.text = model?.name
        datas.append("时间：" + (model?.time)!)
        datas.append("教练人数：" + (model?.coach)!)
        datas.append("地址：" + (model?.address)!)
        datas.append("介绍：\n" + (model?.intro)!)
        
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.separatorColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.1)
        
        self.tableView.reloadData()
    }
    
    //播放视频
    @IBAction func clickVideoBtn(_ sender: Any) {
        
        self.present(playerVC!, animated: true, completion: nil)
        playerVC?.player?.play()
    }
    
    //跳转课程页
    @IBAction func clickCourseBtn(_ sender: Any) {
        
        //club_course
        let detail:MyCourseController = MyCourseController()
        detail.model = self.model
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.numberOfLines = 0;
        cell.textLabel?.textColor = UIColor.lightGray
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.selectionStyle = .none
        cell.textLabel?.text = datas[indexPath.row]
        
        return cell;
    }
    
}
