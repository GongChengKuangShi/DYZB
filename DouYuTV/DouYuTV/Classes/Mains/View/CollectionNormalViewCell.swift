//
//  CollectionNormalViewCell.swift
//  DouYuTV
//
//  Created by xrh on 2017/9/6.
//  Copyright © 2017年 xiangronghua. All rights reserved.
//

import UIKit


class CollectionNormalViewCell: CollectionBaseCell {


    @IBOutlet weak var roomNameLabel: UILabel!
    
    //定义模型属性
    override var anchor : AnchorModel? {
        didSet {
            super.anchor = anchor
            roomNameLabel.text = anchor?.room_name
        }
    }

}
