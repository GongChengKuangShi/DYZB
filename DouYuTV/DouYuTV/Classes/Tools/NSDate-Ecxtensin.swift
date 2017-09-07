//
//  NSDate-Ecxtensin.swift
//  DouYuTV
//
//  Created by xrh on 2017/9/7.
//  Copyright © 2017年 xiangronghua. All rights reserved.
//

import Foundation

extension NSDate {
    class func getCurrentTime() -> String {
        
        let nowDate = NSDate()
        let interval = Int(nowDate.timeIntervalSince1970)
        return "\(interval)"
    }
}
