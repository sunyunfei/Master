//
//  MasterCell.swift
//  MasterSports
//
//  Created by --- on 2018/12/12.
//  Copyright © 2018 ---. All rights reserved.
//

import UIKit

class MasterCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var model:MasterModel?{
        
        didSet{
            
            showData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //显示数据
    func showData(){
        
        nameLabel.text = model?.name
        introLabel.text = model?.intro
        icon.sd_setImage(with: URL.init(string: (model?.icon)!), completed: nil)
    }
}
