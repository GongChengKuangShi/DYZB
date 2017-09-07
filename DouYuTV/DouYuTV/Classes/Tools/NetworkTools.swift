//
//  NetworkTools.swift
//  DouYuTV
//
//  Created by xrh on 2017/9/6.
//  Copyright © 2017年 xiangronghua. All rights reserved.
//

import UIKit
import Alamofire

enum MethodType {
    case GET
    case POST
}

class NetworkTools: NSObject {

    
    //参数的finishedCallback闭包在26行使用了，而使用的环境又是一个闭包，则需要加@escaping
    class func requestData(_ type : MethodType, URLString : String, parameters : [String : Any]? = nil, finishedCallback :  @escaping (_ result : Any) -> ()) {
        let method = type == .GET ? HTTPMethod.get : HTTPMethod.post
        Alamofire.request(URLString, method: method, parameters: parameters).responseJSON { (response) in
            guard let result = response.result.value else {
                print(response.result.error)
                return
            }
            finishedCallback(result)
        }
    }
}
