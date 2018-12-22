//
//  ActiveCell.swift
//  MasterSports
//
//  Created by --- on 2018/12/12.
//  Copyright © 2018 ---. All rights reserved.
//

import UIKit

class ActiveCell: UITableViewCell {

    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var introLabel: UILabel!
    
    var model:ActiveModel?{
        
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
    
    //取消报名
    @IBAction func clickCancelBtn(_ sender: Any) {
        
        //取消  post_deleteCareCourse
        self.contentView.makeToastActivity(.center)
        HomePost.post_deleteActive((model?.activeId)!, success: {
            
            self.contentView.hideToastActivity()
            NotificationCenter.default.post(name: NSNotification.Name.init("refresh"), object: nil)
        }) { (error) in
            
            self.contentView.hideToastActivity()
            self.contentView.makeToast(error)
        }
    }
    
    func showData(){
        
        nameLabel.text = model?.name
        introLabel.text = model?.describe
        timeLabel.text = model?.time
        icon.sd_setImage(with: URL.init(string: (model?.icon)!), completed: nil)
    }
    
}
