//
//  CollectionHeaderView.swift
//  DouYuTV
//
//  Created by xrh on 2017/9/7.
//  Copyright © 2017年 xiangronghua. All rights reserved.
//

import UIKit

class CollectionHeaderView: UICollectionReusableView {

  
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    
    // 定义模型属性
    var group : AnchorGroup? {
        didSet {
            titleLabel.text = group?.tag_name
            iconImageView.image = UIImage(named:group?.icon_name ?? "home_header_normal")
        }
    }
}
