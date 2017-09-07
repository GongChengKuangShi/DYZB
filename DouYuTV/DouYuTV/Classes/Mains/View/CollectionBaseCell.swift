//
//  CollectionBaseCell.swift
//  DouYuTV
//
//  Created by xrh on 2017/9/7.
//  Copyright © 2017年 xiangronghua. All rights reserved.
//

import UIKit
import Kingfisher

//图片加载框架：http://www.jianshu.com/p/55bbfbdf78de

class CollectionBaseCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var onlineButton: UIButton!
    
    var anchor : AnchorModel? {
        didSet {
            //校验模型是否有值
            guard let anchor = anchor else {return}
            //取出在线人数的文字
            var onlineStr : String = ""
            if anchor.online >= 10000 {
                onlineStr = "\(Int(anchor.online / 10000))万在线"
            } else {
                onlineStr = "\(anchor.online)万在线"
            }
            onlineButton.setTitle(onlineStr, for: .normal)
            
            nickNameLabel.text = anchor.nickname
            
            
            guard let iconURL = NSURL(string: anchor.vertical_src) else {
                return
            }
            iconImageView.kf.setImage(with: ImageResource(downloadURL: iconURL as URL))
        }
    }
}
