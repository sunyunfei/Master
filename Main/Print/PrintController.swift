//
//  STController.swift
//  Sports
//
//  Created by 孙云飞 on 2018/12/21.
//  Copyright © 2018 syf. All rights reserved.
//

import UIKit
let st_cell = "PrintCell"
class PrintController: UITableViewController {
    var tableDatas:Array<PrintModel> = Array()//表数据
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.separatorColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.1)
        //self.tableView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 1))
        self.tableView.register(UINib.init(nibName: st_cell, bundle: nil), forCellReuseIdentifier: st_cell)
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        loadData()
    }
    
    //创建
    @IBAction func clickCreateBtn(_ sender: Any) {
        
        //create
        let story:UIStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let detail:PrintCreateViewController = story.instantiateViewController(withIdentifier: "print_create") as! PrintCreateViewController
        detail.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    func loadData(){
        
        self.tableDatas.removeAll()
        self.tableView.reloadData()
        
        self.view.makeToastActivity(.center)
        
        PrintTools.post_st(success: { (array) in
            
            self.view.hideToastActivity()
            
            self.tableDatas = array
            self.tableView.reloadData()
            
            //获取评论
            for model:PrintModel in self.tableDatas{
                
                PrintTools.post_stpl((model.printId)!, success: { (array2) in
                    
                    var pl:String = ""
                    for pModel:PrintPLModel in array2{
                        
                        pl = pl + "\n" + (pModel.userName)! + "同学评论说: " + (pModel.content)!
                    }
                    
                    model.pl = pl
                    self.tableView.reloadData()
                }, failure: { (error) in
                    
                    
                })
            }
            
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
        
        let cell:PrintCell = tableView.dequeueReusableCell(withIdentifier: st_cell, for: indexPath) as! PrintCell
        cell.model = self.tableDatas[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let story:UIStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let detail:PrintDetailController = story.instantiateViewController(withIdentifier: "print_detail") as! PrintDetailController
        detail.model = self.tableDatas[indexPath.row]
        detail.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detail, animated: true)
    }
}
