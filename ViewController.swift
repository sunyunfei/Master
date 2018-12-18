//
//  ViewController.swift
//  Master
//
//  Created by --- on 2018/12/10.
//  Copyright © 2018 ---. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func setCurView(_ view:UIView,_ round:CGFloat,_ width:CGFloat,_ color:UIColor){
        
        view.layer.cornerRadius = round
        view.layer.masksToBounds = true
        view.layer.borderWidth = width
        view.layer.borderColor = color.cgColor
    }
    
}

