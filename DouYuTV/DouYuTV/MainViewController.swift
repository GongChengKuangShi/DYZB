//
//  MainViewController.swift
//  DouYuTV
//
//  Created by xiangronghua on 2017/9/4.
//  Copyright © 2017年 xiangronghua. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addChildVc(storyName: "Home")
        addChildVc(storyName: "Live")
        addChildVc(storyName: "Follow")
        addChildVc(storyName: "Profiel")
        
    }
    private func addChildVc(storyName: String) {
        //1、通过storyboard获取控制器
        let childVc = UIStoryboard(name: storyName, bundle: nil).instantiateInitialViewController()!
        //2、将childVc作为自控制器
        addChildViewController(childVc)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
