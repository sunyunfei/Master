//
//  CourseCell.swift
//  Sports
//
//  Created by 孙云飞 on 2018/12/21.
//  Copyright © 2018 syf. All rights reserved.
//

import UIKit

class MyCourseCell: UITableViewCell {

    @IBOutlet weak var bmBtn: UIButton!
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var cocahLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    var model:CourseModel?{
        
        didSet{
            
            show();
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        introLabel.minimumScaleFactor = 0.4
        introLabel.adjustsFontSizeToFitWidth = true
        OptionTools.setCurView(bmBtn, 32, 1, UIColor.red)
        bmBtn.setTitle("取消", for: .selected)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    //数据处理
    func show(){
        
        nameLabel.text = model?.name
        cocahLabel.text = model?.intro
        introLabel.text = "课程主教练:" + (model?.coach)!
    }
    
    // 报名
    @IBAction func clickBmBtn(_ sender: Any) {
        
        self.contentView.makeToastActivity(.center)
        if bmBtn.isSelected{
            
            //取消  post_deleteCareCourse
            ClubTools.post_deleteCareCourse(courseId: (model?.courseId)!, success: {
                
                self.contentView.hideToastActivity()
                NotificationCenter.default.post(name: NSNotification.Name.init("refresh"), object: nil)
            }) { (error) in
                
                self.contentView.hideToastActivity()
                self.contentView.makeToast(error)
            }
            
        }else{
            //报名
            self.contentView.makeToastActivity(.center)
            ClubTools.post_carecourse(model!, success: {
                
                self.contentView.hideToastActivity()
                self.contentView.makeToast("报名成功")
            }) { (error) in
                
                self.contentView.hideToastActivity()
                self.contentView.makeToast(error)
            }
        }
    }
    
}
