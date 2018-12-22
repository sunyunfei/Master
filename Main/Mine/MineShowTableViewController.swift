//
//  MineShowTableViewController.swift
//  Master
//
//  Created by 孙云飞 on 2018/12/22.
//  Copyright © 2018 syf. All rights reserved.
//

import UIKit

class MineShowTableViewController: UITableViewController {

    var row:Int?
    
    var datas:Array<ActiveModel> = Array()
    var stDatas:Array<PrintModel> = Array()
    var kcDatas:Array<CourseModel> = Array()
    var bsDatas:Array<BSBMModel> = Array()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = UIColor.white

        self.tableView.register(UINib.init(nibName: a_cell, bundle: nil), forCellReuseIdentifier: a_cell)
        self.tableView.register(UINib.init(nibName: b_cell, bundle: nil), forCellReuseIdentifier: b_cell)
        self.tableView.register(UINib.init(nibName: st_cell, bundle: nil), forCellReuseIdentifier: st_cell)
        self.tableView.register(UINib.init(nibName: course_cell, bundle: nil), forCellReuseIdentifier: course_cell)
        self.tableView.register(UINib.init(nibName: b_cell, bundle: nil), forCellReuseIdentifier: b_cell)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshMyData), name: NSNotification.Name.init("refresh"), object: nil)
        
        refreshMyData()
    }
    
    //数据刷新
    @objc func refreshMyData(){
        
        if row == 0 {
            
            self.tableView.estimatedRowHeight = 100
            self.tableView.rowHeight = UITableView.automaticDimension
            
            //晒图
            loadSTModel()
        }else if row == 1{
            //活动
            loadHomeModel()
            
        }else if row == 2{
            
            //课程
            loadCourseModel()
        }else{
            
            //比赛
            loadBSModel()
        }
    }
    
    //post_homeById
    //活动请求
    func loadHomeModel(){
        
        self.datas.removeAll()
        self.view.makeToastActivity(.center)
        HomePost.post_obtainActive(success: { (array) in
            self.view.hideToastActivity()
            self.tableView.reloadData()
            //循环请求
            for model:ActiveAttentionModel in array{
                
                HomePost.post_homeById(activeId: (model.activeId)!, success: { (model) in
                    
                    self.datas.append(model)
                    self.tableView.reloadData()
                }, failure: { (error) in
                    
                    
                })
            }
        }) { (error) in
            
            self.view.hideToastActivity()
            self.view.makeToast(error)
        }
    }
    
    //晒图请求
    func loadSTModel(){
        
        self.view.makeToastActivity(.center)
        //post_stbyId
        PrintTools.post_stbyId(success: { (array) in
            self.view.hideToastActivity()
            self.stDatas = array
            self.tableView.reloadData()
        }) { (error) in
            
            self.view.hideToastActivity()
            self.view.makeToast(error)
        }
    }
    
    
    //课程请求
    func loadCourseModel(){
        
        self.kcDatas.removeAll()
        //post_careCourse
        self.view.makeToastActivity(.center)
        ClubTools.post_careCourse(success: { (array) in
            
            self.view.hideToastActivity()
            self.tableView.reloadData()
            for model:CourseBMModel in array{
                
                //post_clubCourseById
                ClubTools.post_clubCourseById((model.courseId)!, success: { (model) in
                    
                    self.kcDatas .append(model)
                    self.tableView.reloadData()
                }, failure: { (error) in
                    
                    
                })
            }
            
        }) { (error) in
            
            self.view.hideToastActivity()
            self.view.makeToast(error)
        }
    }
    
    //加载比赛
    func loadBSModel(){
        self.bsDatas.removeAll()
        self.view.makeToastActivity(.center)
        HomePost.post_obtainBsBm(success: { (array) in
        
            self.view.hideToastActivity()
            self.bsDatas = array
            self.tableView.reloadData()
        }) { (error) in
            
            self.view.hideToastActivity()
            self.view.makeToast(error)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if row == 0 {
            
            return self.stDatas.count
        }else if row == 1{
            
            return self.datas.count
        }else if row == 2{
            
            return self.kcDatas.count
        }else{
            
            return self.bsDatas.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if row == 0 {
            //晒图
            let cell:PrintCell = tableView.dequeueReusableCell(withIdentifier: st_cell, for: indexPath) as! PrintCell
            cell.mineVC = true
            cell.model = self.stDatas[indexPath.row]
            cell.selectionStyle = .none
            return cell
        }else if row == 1{
            //活动
            let cell:ActiveCell = tableView.dequeueReusableCell(withIdentifier: a_cell, for: indexPath) as! ActiveCell
            cell.cancelBtn.isHidden = false
            cell.model = self.datas[indexPath.row]
            cell.selectionStyle = .none
            return cell
            
        }else if row == 2{
            //课程
            let cell:MyCourseCell = tableView.dequeueReusableCell(withIdentifier: course_cell, for: indexPath) as! MyCourseCell
            cell.bmBtn.isSelected = true
            cell.model = self.kcDatas[indexPath.row]
            cell.selectionStyle = .none
            
            return cell
        }else{
            
            //比赛
            let cell:BSCell = tableView.dequeueReusableCell(withIdentifier: b_cell, for: indexPath) as! BSCell
            cell.model2 = bsDatas[indexPath.row]
            cell.btn.isSelected = true
            cell.btn.tag = indexPath.row
            cell.selectionStyle = .none
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if row == 0 {
            
            return UITableView.automaticDimension
        }else if row == 1{
            
            return 150
        }else if row == 2{
            
            return 120
        }else{
            
            return 160
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        if row == 0 {
            //晒图
            let story:UIStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            let detail:PrintDetailController = story.instantiateViewController(withIdentifier: "print_detail") as! PrintDetailController
            detail.model = self.stDatas[indexPath.row]
            detail.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(detail, animated: true)
            
        }else if row == 1{
            
            //活动
            let story:UIStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            let detail:PXDetailViewController = story.instantiateViewController(withIdentifier: "px_detail") as! PXDetailViewController
            detail.activeModel = self.datas[indexPath.row]
            detail.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(detail, animated: true)
            
        }
    }

}
