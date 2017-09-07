//
//  HomeViewController.swift
//  DouYuTV
//
//  Created by xiangronghua on 2017/9/4.
//  Copyright © 2017年 xiangronghua. All rights reserved.
//

import UIKit

private let kTitleViewH: CGFloat = 40

class HomeViewController: UIViewController {

    // --- 懒加载
    lazy var pageTitleView: PageTitleView = {[weak self] in
        let titleFame = CGRect(x: 0, y: sStatusBarH + kNavigationBarH, width: kScreenW, height: kTitleViewH)
        let titles = ["推荐", "游戏", "娱乐", "趣玩"]
        let titleView = PageTitleView(frame: titleFame, titles: titles)
        titleView.delegate = self!
        return titleView
    }()

    lazy var pageContentView: PageContentView = {[weak self] in
        let contentH = kScreenH - sStatusBarH - kNavigationBarH - kTitleViewH - kTabbarH
        let contentFrame = CGRect(x: 0, y: sStatusBarH + kNavigationBarH + kTitleViewH, width: kScreenW, height: contentH)
        
        // 确定所有的子控制器
        var childVCs = [UIViewController]()
        childVCs.append(RecommentdViewController())
        for i in 0..<3 {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor(r: CGFloat(arc4random_uniform(255)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)))
            childVCs.append(vc)
        }
        
        let contentView = PageContentView(frame: contentFrame, childVcs: childVCs, parentViewController: self)
        contentView.delegate = self
        return contentView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
}

//MARK - 设置UI界面
extension HomeViewController {
    
    func setupUI() {
        //不需要调整内边距
        automaticallyAdjustsScrollViewInsets = false
        
        setupNavigationBar()
        
        //加载TitleView
        view.addSubview(pageTitleView)
        
        //-- 添加ContentView
        view.addSubview(pageContentView)
        pageContentView.backgroundColor = UIColor.purple
    }
    
    private func setupNavigationBar() {
        
        //设置左侧
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "logo")
        
        //设置右侧
        let size = CGSize(width: 45, height: 45)
        let histaryItem = UIBarButtonItem(imageName: "image_my_history", heightImageName: "Image_my_history_click", size: size)
        let searchItem = UIBarButtonItem(imageName: "btn_search", heightImageName: "btn_search_clicked", size: size)
        let qrcodeItem = UIBarButtonItem(imageName: "Image_scan", heightImageName: "Image_scan_click", size: size)
//        let histaryItem = UIBarButtonItem.creatItem(imageName: "image_my_history", heightImageName: "Image_my_history_click", size: size)
//        let searchItem = UIBarButtonItem.creatItem(imageName: "btn_search", heightImageName: "btn_search_clicked", size: size)
//        let qrcodeItem = UIBarButtonItem.creatItem(imageName: "Image_scan", heightImageName: "Image_scan_click", size: size)
        UINavigationBar.appearance().tintColor = UIColor.orange
        navigationItem.rightBarButtonItems = [histaryItem, searchItem, qrcodeItem]
    }
}


// 遵守协议
extension HomeViewController : PageTitleViewDelegate {
    func pageTitleView(titleView: PageTitleView, selectedIndex index: Int) {
        pageContentView.setupCurrentIndex(currentIndex: index)
    }
}

extension HomeViewController : PageContentViewDelegate {
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setTitleWithProgress(progress: progress, sourceIndex: sourceIndex, targetIndx: targetIndex) 
    }
}
