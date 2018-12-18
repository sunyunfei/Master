//
//  PXSearchTableViewController.swift
//  MasterSports
//
//  Created by --- on 2018/12/17.
//  Copyright © 2018 ---. All rights reserved.
//

import UIKit

class PXSearchTableViewController: UITableViewController,UISearchBarDelegate {
    var datas:Array<ActiveModel>?
    var showDatas:Array<ActiveModel> = Array()
    @IBOutlet weak var search: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.title = "搜索活动列表"
        tableView.register(UINib.init(nibName: a_cell, bundle: nil), forCellReuseIdentifier: a_cell)
        tableView.separatorStyle = .none
        search.delegate = self
    }

    //搜索点击
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        
        
        let str:String? = search.text
        
        
        if showDatas.count > 0{
            
            showDatas.removeAll()
        }
        
        if (datas?.count)! < 0 {
            
            return
        }
        
        if let s = str{
            
            //开始匹配
            for obj:ActiveModel in (datas)!{
                
                let flag:Bool = (obj.name?.contains(s))!
                if flag{
                    
                    showDatas.append(obj)
                }
            }
        }
        
        self.view.endEditing(true)
        self.tableView.reloadData()
    }
    
    
    //表的代理事件
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.showDatas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ActiveCell = tableView.dequeueReusableCell(withIdentifier: a_cell, for: indexPath) as! ActiveCell
        cell.model = self.showDatas[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let story:UIStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let detail:PXDetailViewController = story.instantiateViewController(withIdentifier: "px_detail") as! PXDetailViewController
        detail.hidesBottomBarWhenPushed = true
        detail.isMaster = false
        detail.activeModel = showDatas[indexPath.row]
        self.navigationController?.pushViewController(detail, animated: true)
    }

}
