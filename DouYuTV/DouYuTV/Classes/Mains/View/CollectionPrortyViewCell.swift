//
//  CollectionPrortyViewCell.swift
//  DouYuTV
//
//  Created by xrh on 2017/9/6.
//  Copyright © 2017年 xiangronghua. All rights reserved.
//

import UIKit

class CollectionPrortyViewCell: CollectionBaseCell {

    


    @IBOutlet weak var cityButton: UIButton!
    

   override var anchor : AnchorModel? {
        didSet {
      
            //降属性传递给父类
            super.anchor = anchor
            cityButton.setTitle(anchor?.anchor_city, for: .normal)
        }
    }
}
