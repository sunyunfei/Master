//
//  TrainDetailController.swift
//  Master
//
//  Created by 孙云飞 on 2018/12/19.
//  Copyright © 2018 syf. All rights reserved.
//

import UIKit

class TrainDetailController: UITableViewController {

    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var icon: UIImageView!
    var model:TrainModel?
    var datas:Array<String> = Array()
    override func viewDidLoad() {
        super.viewDidLoad()

        icon.sd_setImage(with: URL.init(string: (model?.icon)!), completed: nil)
        
        datas.append("训练名称：" + (model?.name)!)
        datas.append("训练类型：" + (model?.type)!)
        datas.append("训练时间：" + (model?.time)!)
        datas.append("训练地址：" + (model?.address)!)
        datas.append("训练介绍：\n" + (model?.intro)!)
        datas.append("训练详情：\n" + (model?.describe)!)
        
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.separatorColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.1)
        
        self.tableView.reloadData()
    }

   
    @IBAction func clickBMBtn(_ sender: Any) {
        
        self.view.makeToastActivity(.center)
        TrainTools.post_careTrain(model!, success: {
            
            self.view.hideToastActivity()
            self.headView.makeToast("报名成功")
        }) { (error) in
            
            self.view.hideToastActivity()
            self.headView.makeToast(error)
        }
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
