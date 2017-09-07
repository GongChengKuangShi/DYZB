 //
//  AnchorModel.swift
//  DouYuTV
//
//  Created by xrh on 2017/9/7.
//  Copyright © 2017年 xiangronghua. All rights reserved.
//

import UIKit

class AnchorModel: NSObject {

    //房间ID
    var room_id : Int = 0
    
    //房间图片的URL
    var vertical_src : String = ""
    
    //判断是手机直播，还是电脑直播
    //0:电脑直播 1:手机直播
    var isVertical : Int = 0
    
    //房间名称
    var room_name : String = ""
    
    //主播名称
    var nickname : String = ""
    
    //观看人数
    var online : Int = 0
    
    //所在城市
    var anchor_city : String = ""
    
    init(dict : [String : NSObject]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {//字典中有些没用到的数据，这个方法可以避免报错
        
    }
}
