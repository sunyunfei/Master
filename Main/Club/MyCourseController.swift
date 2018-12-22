//
//  ClubCourseController.swift
//  Sports
//
//  Created by 孙云飞 on 2018/12/21.
//  Copyright © 2018 syf. All rights reserved.
//

import UIKit
let course_cell:String = "MyCourseCell"
class MyCourseController: UITableViewController {

    var model:MyClubModel?
    var tableDatas:Array<CourseModel> = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.1)
        //self.tableView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 1))
        self.tableView.register(UINib.init(nibName: course_cell, bundle: nil), forCellReuseIdentifier: course_cell)
        loadData()
    }

    func loadData(){
        
        self.view.makeToastActivity(.center)
        
        ClubTools.post_clubCourse((model?.clubId)!,success: { (array) in
            
            self.view.hideToastActivity()
            
            self.tableDatas = array
            
            self.tableView.reloadData()
            
            
        }) { (error) in
            
            self.view.hideToastActivity()
            self.view.makeToast(error)
        }
    }
    
    //表的代理事件
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.tableDatas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MyCourseCell = tableView.dequeueReusableCell(withIdentifier: course_cell, for: indexPath) as! MyCourseCell
        cell.model = self.tableDatas[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
