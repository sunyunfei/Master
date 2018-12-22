//
//  ClubViewController.swift
//  Sports
//
//  Created by 孙云飞 on 2018/12/21.
//  Copyright © 2018 syf. All rights reserved.
//

import UIKit
let club_cell:String = "ClubCell"
class MyClubViewController: UITableViewController,ZCycleViewProtocol {
    func cycleViewDidScrollToIndex(_ index: Int) {
        
    }
    
    func cycleViewDidSelectedIndex(_ index: Int) {
        
        let story:UIStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let detail:MyDetailViewController = story.instantiateViewController(withIdentifier: "club_detail") as! MyDetailViewController
        detail.model = self.tableDatas[index]
        detail.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detail, animated: true)
    }
    //轮播图
    var cycleView:ZCycleView?
    var tableDatas:Array<MyClubModel> = Array()//表数据
    var scrollDatas:Array<MyClubModel> = Array()
    @IBOutlet weak var headView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "俱乐部"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.1)
        self.tableView.register(UINib.init(nibName: club_cell, bundle: nil), forCellReuseIdentifier: club_cell)
        
        cycleView = ZCycleView(frame: self.headView.bounds)
        cycleView?.delegate = self
        self.headView.addSubview(cycleView!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        loadData()
    }
    
    func loadData(){
        
        self.view.makeToastActivity(.center)
        
        ClubTools.post_club(success: { (array) in
            
            self.view.hideToastActivity()
            
            self.tableDatas = array
            
            //轮播图加载
            var imgArrays:Array<String> = Array()
            
            var count:Int = 0
            for model:MyClubModel in self.tableDatas{
                
                if count > 5{
                    
                    break;
                }
                
                self.scrollDatas.append(model)
                imgArrays.append(model.icon!)
                count = count + 1
            }
            
            self.cycleView?.setUrlsGroup(imgArrays)
            
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
        
        let cell:ClubCell = tableView.dequeueReusableCell(withIdentifier: club_cell, for: indexPath) as! ClubCell
        cell.model = self.tableDatas[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let story:UIStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let detail:MyDetailViewController = story.instantiateViewController(withIdentifier: "club_detail") as! MyDetailViewController
        detail.model = self.tableDatas[indexPath.row]
        detail.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detail, animated: true)
    }
}
