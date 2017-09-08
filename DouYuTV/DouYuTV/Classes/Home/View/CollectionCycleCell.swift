//
//  CollectionCycleCell.swift
//  DouYuTV
//
//  Created by xrh on 2017/9/8.
//  Copyright © 2017年 xiangronghua. All rights reserved.
//

import UIKit
import Kingfisher

class CollectionCycleCell: UICollectionViewCell {
    
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    //---定义模型属性
    var cycleModel : CycleModel? {
        didSet {
            titleLabel.text = cycleModel?.title
            guard let iconURL = NSURL(string: (cycleModel?.pic_url)!) else {
                return
            }
            iconImageView.kf.setImage(with: ImageResource(downloadURL: iconURL as URL))
        }
    }

    

}
