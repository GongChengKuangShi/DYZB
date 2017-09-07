//
//  UIBarbuttonItem.swift
//  DouYuTV
//
//  Created by xiangronghua on 2017/9/4.
//  Copyright © 2017年 xiangronghua. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    /*
    class func creatItem(imageName: String, heightImageName: String, size: CGSize) -> UIBarButtonItem {
        
        let button = UIButton()
        
        button.setImage(UIImage(named: imageName), for: .normal)
        button.setImage(UIImage(named: heightImageName), for: .selected)
        
        button.frame = CGRect(origin: CGPoint.zero, size: size)
        return UIBarButtonItem(customView: button)
    }
    */
    
    //便利构造函数: (1) convenience开头 (2) 在构造函数中必须明确调用一个设计的构造函数（self）
    convenience init(imageName: String, heightImageName: String = "", size: CGSize = CGSize.zero) {
        
        let button = UIButton()
    
        button.setImage(UIImage(named: imageName), for: .normal)
        if heightImageName != "" {
            button.setImage(UIImage(named: heightImageName), for: .selected)
        }
        
        if size == CGSize.zero {
            button.sizeToFit()
        } else {

            button.frame = CGRect(origin: CGPoint.zero, size: size)
        }
        
        
        
        self.init(customView: button)
    }
    
}
