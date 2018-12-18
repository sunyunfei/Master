//
//  PXViewController.swift
//  MasterSports
//
//  Created by --- on 2018/12/12.
//  Copyright © 2018 ---. All rights reserved.
//

import UIKit

let m_cell = "MasterCell"
let a_cell = "ActiveCell"
let b_cell = "BSCell"
class PXViewController: UITableViewController,ZCycleViewProtocol {
    func cycleViewDidScrollToIndex(_ index: Int) {
        
        
    }
    
    func cycleViewDidSelectedIndex(_ index: Int) {
        
        if segBtn.selectedSegmentIndex == 0 || segBtn.selectedSegmentIndex == 1{
            
            //px_detail
            let story:UIStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            let detail:PXDetailViewController = story.instantiateViewController(withIdentifier: "px_detail") as! PXDetailViewController
            detail.hidesBottomBarWhenPushed = true
            if segBtn.selectedSegmentIndex == 0{
                
                detail.isMaster = true
                detail.masterModel = masterArrays[index]
            }else{
                
                detail.isMaster = false
                detail.activeModel = activeArrays[index]
            }
            self.navigationController?.pushViewController(detail, animated: true)
        }
    }
    

    @IBOutlet weak var segBtn: UISegmentedControl!//标签按钮
    @IBOutlet weak var headView: UIView!//顶部视图
    //数据
    var activeArrays:Array<ActiveModel> = Array()
    var masterArrays:Array<MasterModel> = Array()
    //轮播图
    var cycleView:ZCycleView?
    override func viewDidLoad() {
        super.viewDidLoad()

        cycleView = ZCycleView(frame: self.headView.bounds)
        cycleView?.delegate = self
        self.headView.addSubview(cycleView!)
        
        self.tableView.separatorColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.1)
        self.tableView.register(UINib.init(nibName: m_cell, bundle: nil), forCellReuseIdentifier: m_cell)
        self.tableView.register(UINib.init(nibName: a_cell, bundle: nil), forCellReuseIdentifier: a_cell)
        
        self.tableView.tableFooterView = UIView.init()
        
        self.segBtn.selectedSegmentIndex = 1;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //判断是否需要登录
        let d:UserDefaults = UserDefaults.init()
        let acc:String? = d.object(forKey: "location_user") as? String
        if let account:String = acc{
            
            self.clickTagEvent(segBtn)
            
        }else{
            
            //需要登录
            OptionTools.presentLoginVC()
        }
    }
    
    //进入比赛
    @IBAction func clickBSBtn(_ sender: Any) {
        
        let bs:BSTableViewController = BSTableViewController()
        bs.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(bs, animated: true)
        
    }
    @IBAction func clickSearchBtn(_ sender: Any) {
        
        let story:UIStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let search:PXSearchTableViewController = story.instantiateViewController(withIdentifier: "search") as! PXSearchTableViewController
        search.hidesBottomBarWhenPushed = true
        search.datas = activeArrays
        self.navigationController?.pushViewController(search, animated: true)
    }
    //点击事件
    @IBAction func clickTagEvent(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0{
            
            loadMaster()
            
        }else{
            
            loadActive()
        }
    }
    
    
    func refreshData(){
        
        var imgArrays:Array<String> = Array()
        var titleArrays:Array<String> = Array()
        
        if segBtn.selectedSegmentIndex == 0{
            
            for obj:MasterModel in masterArrays{
                
                imgArrays.append((obj.icon)!)
                titleArrays.append((obj.name)!)
            }
            
        }else{
            
            for obj:ActiveModel in activeArrays{
                
                imgArrays.append((obj.icon)!)
                titleArrays.append((obj.name)!)
            }
        }
        
        cycleView?.setUrlsGroup(imgArrays, titlesGroup: titleArrays, attributedTitlesGroup: nil)
        self.tableView.reloadData()
    }
    
    //数据请求
    func loadActive(){
        
        if activeArrays.count > 0{
            
            refreshData()
            return
        }
        
        self.view.makeToastActivity(.center)
        HomePost.post_active(success: { (array) in
            
            self.view.hideToastActivity()
            self.activeArrays = array
            self.refreshData()
        }) { (error) in
            self.view.hideToastActivity()
            self.view.makeToast(error)
        }
        
    }

    func loadMaster(){
        
        if masterArrays.count > 0{
            
            refreshData()
            return
        }
        
        self.view.makeToastActivity(.center)
        HomePost.post_master(success: { (array) in
            self.view.hideToastActivity()
            self.masterArrays = array
            self.refreshData()
        }) { (error) in
            
            self.view.hideToastActivity()
            self.view.makeToast(error)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if segBtn.selectedSegmentIndex == 0{
            
            return self.masterArrays.count
        }else{
            
            return self.activeArrays.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if segBtn.selectedSegmentIndex == 0{
            
            let cell:MasterCell = tableView.dequeueReusableCell(withIdentifier: m_cell, for: indexPath) as! MasterCell
            cell.model = masterArrays[indexPath.row]
            cell.selectionStyle = .none
            return cell
        }else{
            
            let cell:ActiveCell = tableView.dequeueReusableCell(withIdentifier: a_cell, for: indexPath) as! ActiveCell
            cell.model = activeArrays[indexPath.row]
            cell.selectionStyle = .none
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if segBtn.selectedSegmentIndex == 0{
            
            return 70
        }else{
            
            return 150
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //px_detail
        let story:UIStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let detail:PXDetailViewController = story.instantiateViewController(withIdentifier: "px_detail") as! PXDetailViewController
        detail.hidesBottomBarWhenPushed = true
        if segBtn.selectedSegmentIndex == 0{
            
            detail.isMaster = true
            detail.masterModel = masterArrays[indexPath.row]
        }else{
            
            detail.isMaster = false
            detail.activeModel = activeArrays[indexPath.row]
        }
        self.navigationController?.pushViewController(detail, animated: true)
    }
}
