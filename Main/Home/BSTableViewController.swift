//
//  BSTableViewController.swift
//  MasterSports
//
//  Created by 孙云飞 on 2018/12/17.
//  Copyright © 2018 孙云飞. All rights reserved.
//

import UIKit

class BSTableViewController: UITableViewController {
    var BSArrays:Array<BSModel> = Array()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "比赛"
        self.tableView.register(UINib.init(nibName: b_cell, bundle: nil), forCellReuseIdentifier: b_cell)
        self.tableView.tableFooterView = UIView.init()
        loadBS()
    }

    
    
    func loadBS(){
        
        if BSArrays.count > 0{
            
            BSArrays.removeAll()
        }
        
        self.view.makeToastActivity(.center)
        HomePost.post_bs(success: { (array) in
            self.view.hideToastActivity()
            self.BSArrays = array
            self.tableView.reloadData()
        }) { (error) in
            
            self.view.hideToastActivity()
            self.view.makeToast(error)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.BSArrays.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:BSCell = tableView.dequeueReusableCell(withIdentifier: b_cell, for: indexPath) as! BSCell
        cell.model = BSArrays[indexPath.row]
        cell.btn.tag = indexPath.row
        cell.selectionStyle = .none
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 160
    }
}
