//
//  CollectionGameCell.swift
//  DouYuTV
//
//  Created by xrh on 2017/9/8.
//  Copyright © 2017年 xiangronghua. All rights reserved.
//

import UIKit
import Kingfisher

class CollectionGameCell: UICollectionViewCell {

    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    //定义模型属性
    var group : AnchorGroup? {
        didSet {
            titleLabel.text = group?.tag_name
            
            guard let iconURL = NSURL(string: group?.icon_url
                ?? "") else {return}
//            iconImageView.kf.setImage(with: ImageResource(downloadURL: iconURL as URL))
            iconImageView.kf.setImage(with: ImageResource(downloadURL: iconURL as URL), placeholder: UIImage(named: "home_more_btn"), options: nil, progressBlock: nil, completionHandler: nil)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
