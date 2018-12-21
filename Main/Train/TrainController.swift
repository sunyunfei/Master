//
//  TrainController.swift
//  Master
//
//  Created by 孙云飞 on 2018/12/19.
//  Copyright © 2018 syf. All rights reserved.
//

import UIKit
let train_cell = "TrainCell"
class TrainController: UITableViewController,ZCycleViewProtocol,UITextFieldDelegate {
    func cycleViewDidScrollToIndex(_ index: Int) {
        
    }
    
    func cycleViewDidSelectedIndex(_ index: Int) {
        
        let story:UIStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let detailVC:TrainDetailController = story.instantiateViewController(withIdentifier: "t_detail") as! TrainDetailController
        detailVC.hidesBottomBarWhenPushed = true
        detailVC.model = showAllData ? self.tableDatas[index] : self.tableDatas[index]
        self.navigationController?.pushViewController(detailVC, animated: true)
        
        self.view.endEditing(true)
    }
    
    //轮播图
    var cycleView:ZCycleView?
    
    var tableDatas:Array<TrainModel> = Array()//表数据
    var someDatas:Array<TrainModel> = Array()
    
    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var searchField: UITextField!
    
    var showAllData:Bool = true//是否展示全部数据
    override func viewDidLoad() {
        super.viewDidLoad()

        searchField.delegate = self
        self.tableView.register(UINib.init(nibName: train_cell, bundle: nil), forCellReuseIdentifier: train_cell)
        self.tableView.separatorColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.1)
        self.tableView.tableFooterView = UIView.init()
        
        cycleView = ZCycleView(frame: self.headView.bounds)
        cycleView?.delegate = self
        self.headView.addSubview(cycleView!)
        
        loadData()
    }
    
    private func loadData(){
        self.view.endEditing(true)
        self.tableDatas.removeAll()
        
        self.view.makeToastActivity(.center)
        TrainTools.post_train(success: { (array) in
            
            self.view.hideToastActivity()
            
            self.tableDatas = array
            //轮播图加载
            var imgArrays:Array<String> = Array()
            
            var count:Int = 0
            for model:TrainModel in self.tableDatas{
                
                if  count > 5 {
                    
                    break
                }
                
                if let i = model.icon{
                    
                    imgArrays.append(i)
                }
                
                count = count + 1
            }
            
            self.cycleView?.setUrlsGroup(imgArrays)
            
            self.tableView.reloadData()
        }) { (error) in
            
            self.view.hideToastActivity()
            self.view.makeToast(error)
        }
    }
    
    private func searchByKey(){
        self.view.endEditing(true)
        let str:String? = searchField.text
        
        showAllData = false
        
        if someDatas.count > 0{
            
            someDatas.removeAll()
        }
        
        if (tableDatas.count) < 0 {
            
            self.view.makeToast("没有训练的数据")
            return
        }
        
        if let s = str{
            
            //开始匹配
            for obj:TrainModel in (tableDatas){
                
                let flag:Bool = (obj.name?.contains(s))!
                if flag{
                    
                    someDatas.append(obj)
                }
            }
        }
        
        self.tableView.reloadData()
    }

    //显示全部数据
    @IBAction func clickShowAll(_ sender: Any) {
        showAllData = true
        loadData()
    }
    
    //进入咨询页
    @IBAction func clickAskBtn(_ sender: Any) {
        self.view.endEditing(true)
        let story:UIStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let askVC:TrainAskController = story.instantiateViewController(withIdentifier: "ask") as! TrainAskController
        askVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(askVC, animated: true)
    }
    
    
    //表的代理事件
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if showAllData{
            
            return self.tableDatas.count
        }else{
            
            return someDatas.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:TrainCell = tableView.dequeueReusableCell(withIdentifier: train_cell, for: indexPath) as! TrainCell
        cell.model = showAllData ? self.tableDatas[indexPath.row] : self.tableDatas[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        let story:UIStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let detailVC:TrainDetailController = story.instantiateViewController(withIdentifier: "t_detail") as! TrainDetailController
        detailVC.hidesBottomBarWhenPushed = true
        detailVC.model = showAllData ? self.tableDatas[indexPath.row] : self.tableDatas[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

}
