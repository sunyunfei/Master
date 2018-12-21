//
//  TrainCell.swift
//  Master
//
//  Created by 孙云飞 on 2018/12/19.
//  Copyright © 2018 syf. All rights reserved.
//

import UIKit

class TrainCell: UITableViewCell {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    var model:TrainModel?{
        
        didSet{
            
            showData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        OptionTools.setCurView(icon, 3, 0, UIColor.red)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //数据解析
    func showData(){
        
        icon.sd_setImage(with: URL.init(string: (model?.icon)!), completed: nil)
        nameLabel.text = model?.name
        addressLabel.text = "地址:" + (model?.address)!
    }
}
