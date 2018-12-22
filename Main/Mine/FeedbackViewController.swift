//
//  FeedbackViewController.swift
//  Master
//
//  Created by 孙云飞 on 2018/12/22.
//  Copyright © 2018 syf. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController,UITextViewDelegate {

    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        OptionTools.setCurView(submitBtn, 32, 1, UIColor.red)
    }
    

    //提交
    @IBAction func clickBtn(_ sender: Any) {
        
        let str:String = textView.text
        if str.count <= 0{
            
            self.view.makeToast("请输入反馈内容")
            return
        }
        
        
        //请求接口
        self.view.makeToastActivity(.center)
        MineTools.post_createFK(str, success: {
            
            self.view.hideToastActivity()
            self.view.makeToast("反馈提交成功，我们会认真对待，谢谢。")
        }) { (error) in
            
            self.view.hideToastActivity()
            self.view.makeToast(error)
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
