//
//  TrainAskController.swift
//  Master
//
//  Created by 孙云飞 on 2018/12/19.
//  Copyright © 2018 syf. All rights reserved.
//

import UIKit

class TrainAskController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var datas:Array<TrainASKModel> = Array()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "提问"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.separatorColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.1)
        self.tableView.tableFooterView = UIView.init()
        
        load()
    }
    
    func load(){
        
        self.datas.removeAll()
        self.view.makeToastActivity(.center)
        TrainTools.post_tw(success: { (array) in
            
            self.view.hideToastActivity()
            self.datas = array
            
            self.tableView.reloadData()
        }) { (error) in
            
            self.view.hideToastActivity()
            self.view.makeToast(error)
        }
    }

    //咨询
    @IBAction func clickBtn(_ sender: Any) {
        
        //初始化UITextField
        var inputText:UITextField = UITextField();
        let msgAlertCtr = UIAlertController.init(title: "提示", message: "请输入提问", preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "确定", style:.default) { (action:UIAlertAction) ->() in
            if((inputText.text) != nil){
                print("你输入的是：\(String(describing: inputText.text))")
                
                self.view.makeToastActivity(.center)
                
                let xmodel:TrainASKModel = TrainASKModel()
                xmodel.ask = inputText.text
                
                TrainTools.post_xltw(xmodel, success: {
                    
                    self.view.hideToastActivity()
                    self.view.makeToast("提问成功")
                    self.load()
                }) { (error) in
                    
                    self.view.hideToastActivity()
                    self.view.makeToast(error)
                }
                
            }
        }
        
        let cancel = UIAlertAction.init(title: "取消", style:.cancel) { (action:UIAlertAction) -> ()in
            print("取消输入")
        }
        
        msgAlertCtr.addAction(ok)
        msgAlertCtr.addAction(cancel)
        //添加textField输入框
        msgAlertCtr.addTextField { (textField) in
            //设置传入的textField为初始化UITextField
            inputText = textField
            inputText.placeholder = "输入提问内容"
        }
        //设置到当前视图
        self.present(msgAlertCtr, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.numberOfLines = 0;
        cell.textLabel?.textColor = UIColor.lightGray
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.selectionStyle = .none
        let model:TrainASKModel = datas[indexPath.row]
        if let replay = model.replay{
            
            cell.textLabel?.text = (model.userName)! + " 提问: " + (model.ask)! + "\n\n" + "回复： " + replay
        }
        
        
        return cell;
    }
}
