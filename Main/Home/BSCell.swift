//
//  BSCell.swift
//  MasterSports
//
//  Created by --- on 2018/12/12.
//  Copyright © 2018 ---. All rights reserved.
//

import UIKit

class BSCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var model:BSModel?{
        
        didSet{
            
            showData()
        }
    }
    
    var model2:BSBMModel?{
        
        didSet{
            
            showData2()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btn.layer.cornerRadius = 30
        btn.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func clickBtn(_ sender: Any) {
        
        if !btn.isSelected{
            
            //报名
            //请求接口
            self.makeToastActivity(.center)
            HomePost.post_careBsBm((model)!, success: {
                self.hideToastActivity()
                self.makeToast("报名成功")
                
            }) { (error) in
                self.hideToastActivity()
                self.makeToast(error)
            }
        }else{
            
            //取消报名
            //post_deleteBS
            self.contentView.makeToastActivity(.center)
            HomePost.post_deleteBS((model2?.bsId)!, success: {
                
                self.contentView.hideToastActivity()
                NotificationCenter.default.post(name: NSNotification.Name.init("refresh"), object: nil)
            }) { (error) in
                
                self.contentView.hideToastActivity()
                self.contentView.makeToast(error)
            }
        }
    }
    
    
    func showData(){
        nameLabel.text = model?.name
        addressLabel.text = "地点: " + (model?.address)!
        timeLabel.text = "开始时间: " + (model?.time)!
        icon.sd_setImage(with: URL.init(string: (model?.icon)!), completed: nil)
        
    }
    
    func showData2(){
        nameLabel.text = model2?.name
        addressLabel.text = "地点: " + (model2?.address)!
        timeLabel.text = "开始时间: " + (model2?.time)!
        icon.sd_setImage(with: URL.init(string: (model2?.icon)!), completed: nil)
        
    }
}
