//
//  RecommendViewModel.swift
//  DouYuTV
//
//  Created by xrh on 2017/9/7.
//  Copyright © 2017年 xiangronghua. All rights reserved.
//

import UIKit

class RecommendViewModel {//如果用不到父类的东西，那么可以不继承，这样可以使得项目更加轻量级

    lazy var anchorGroup : [AnchorGroup] = [AnchorGroup]()
    lazy var bigDataGroup: AnchorGroup = AnchorGroup()//热门
    lazy var protyDataGroup: AnchorGroup = AnchorGroup()//颜值
}


// -- 发送网络请求
extension RecommendViewModel {
    func requestData(finishCallback : @escaping () -> ()) {
        
        //0、定义参数
        let paramaters = ["limit" : "4", "offset" : "0", "time" : NSDate.getCurrentTime()]
        
        //Swift 3.0 GCD的常用方法:http://www.jianshu.com/p/be5a277e1f96   或者：http://www.jianshu.com/p/8442576377a8
        //------  创建Group队列---------（当发送异步请求的时候,要保证所有的接口都请求好数据，并且得按顺序添加进入model中，好进行赋值）
        let dGroup = DispatchGroup()
        
        //1、请求推荐数据
        
        //------ 加入组中 -----
        dGroup.enter()
        
        
        NetworkTools.requestData(.GET, URLString: "http://capi.douyucdn.cn/api/v1/getbigDataRoom", parameters: ["time" : NSDate.getCurrentTime()]) { (result) in
//            print(result)
            
            //1、将result转为字典类型
            guard let resultDict = result as? [String : NSObject] else {return}
            
            //2、根据data的key，获取数据
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else {return}
            
            //3、将数组转成模型对象
            //设置组的属性
            self.bigDataGroup.tag_name = "热门"
            self.bigDataGroup.icon_name = "home_header_hot"
            //获取主播的数据
            for dict in dataArray {
                let anchor = AnchorModel(dict: dict)
                self.bigDataGroup.anchers.append(anchor)
            }
            
            //-------离开组---------
            dGroup.leave()
        }
        
        
        
        
        //2、颜值数据
        
        //------ 加入组中 -----
        dGroup.enter()
        
        NetworkTools.requestData(.GET, URLString: "http://capi.douyucdn.cn/api/v1/getVerticalRoom", parameters: paramaters) { (result) in
            
//            print(result)
            
            //1、将result转为字典类型
            guard let resultDict = result as? [String : NSObject] else {return}
            
            //2、根据data的key，获取数据
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else {return}
            
            //3、将数组转成模型对象
            
            //设置组的属性
            self.protyDataGroup.tag_name = "颜值"
            self.protyDataGroup.icon_name = "home_header_phone"
            //获取主播的数据
            for dict in dataArray {
                let anchor = AnchorModel(dict: dict)
                self.protyDataGroup.anchers.append(anchor)
            }
            
            
            //-------离开组---------
            dGroup.leave()
        }

        
        
        //3、后面部分的游戏数据
        
        //------ 加入组中 -----
        dGroup.enter()
        
        NetworkTools.requestData(.GET, URLString: "http://capi.douyucdn.cn/api/v1/getHotCate", parameters: paramaters) { (result) in
//            print(result)
            
            //1、将result转为字典类型
            guard let resultDict = result as? [String : NSObject] else {return}
            
            //2、根据data的key，获取数据
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else {return}
            
            //3、将数组转成模型对象
            for dict in dataArray {
                let group = AnchorGroup(dict: dict)
                self.anchorGroup.append(group)
            }
            
            
            //-------离开组---------
            dGroup.leave()
            
        }
        
        //所有数据都请求到之后进行排序
        dGroup.notify(queue: .main) {

            self.anchorGroup.insert(self.protyDataGroup, at: 0)
            self.anchorGroup.insert(self.bigDataGroup, at: 0)
        
            finishCallback()
        }

    }
}
