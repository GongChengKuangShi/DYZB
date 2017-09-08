//
//  RecommentdViewController.swift
//  DouYuTV
//
//  Created by xrh on 2017/9/6.
//  Copyright © 2017年 xiangronghua. All rights reserved.
//

//抓取数据（抓包）:http://study.163.com/course/courseLearn.htm?courseId=1003309014&from=study#/learn/video?lessonId=1004015396&courseId=1003309014

//课件地址: http://study.163.com/course/courseLearn.htm?courseId=1003309014&from=study#/learn/video?lessonId=1004020290&courseId=1003309014

import UIKit

private let kItemMargin : CGFloat = 10
private let kItemW = (kScreenW - 3 * kItemMargin) / 2
private let kNormalItemH = kItemW * 3 / 4
private let kPrortyItemH = kItemW * 4 / 3

private let kHeaderViewH : CGFloat = 50
private let kGameViewH   : CGFloat  = 90

private let kCycleViewH = kScreenW * 3 / 8

private let kNormalCellID = "kNormalCellID"
private let kHeaderViewID = "kHeaderViewID"
private let kPrortyCellID = "kPrortyCellID"

class RecommentdViewController: UIViewController {

    // -- 懒加载
    lazy var recommendVM : RecommendViewModel = RecommendViewModel()
    
    lazy var collectionView : UICollectionView = { [unowned self] in
        //1、创建布局
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kItemW, height: kNormalItemH)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = kItemMargin
        layout.headerReferenceSize = CGSize(width: kScreenW, height: kHeaderViewH)
        layout.sectionInset = UIEdgeInsets(top: 0, left: kItemMargin, bottom: 0, right: kItemMargin)
        
        //2、创建UICollectionView
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        collectionView.register(UINib(nibName: "CollectionNormalViewCell", bundle: nil), forCellWithReuseIdentifier: kNormalCellID)
        collectionView.register(UINib(nibName: "CollectionPrortyViewCell", bundle: nil), forCellWithReuseIdentifier: kPrortyCellID)
        
        collectionView.register(UINib(nibName:"CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kHeaderViewID)
        
        return collectionView
    }()
    
    lazy var cycleView : RecommandCycleView = {
        let cycleView = RecommandCycleView.recommandCycleView()
        cycleView.frame = CGRect(x: 0, y: -(kCycleViewH + kGameViewH), width: kScreenW, height: kCycleViewH)
        return cycleView
    }()
    
    lazy var gameView : RecommandGameView = {
        let gameView = RecommandGameView.recommandGameView()
        gameView.frame = CGRect(x: 0, y: -kGameViewH, width: kScreenW, height: kGameViewH)
        
        return gameView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        //设置UI界面
        setupUI()
        
        //数据请求
        loadData()
    }

}


//MARK:-- 设置UI界面内容
extension RecommentdViewController {
    func setupUI() {
        view.addSubview(collectionView)
        
        //添加cycleView
        collectionView.addSubview(cycleView)
        
        //添加gameView进入collectionView
        collectionView.addSubview(gameView)
        
        //设置collectView的内边距
        collectionView.contentInset = UIEdgeInsetsMake(kCycleViewH + kGameViewH, 0, 0, 0)
        
        
    }
}

//MARK: 遵守UIcollectionView的代理协议
extension RecommentdViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return recommendVM.anchorGroup.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let group = recommendVM.anchorGroup[section]
        
        return group.anchers.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //取出模型
        let group = recommendVM.anchorGroup[indexPath.section]
        let ancher = group.anchers[indexPath.item]
        
        var cell : CollectionBaseCell!
        
        if indexPath.section == 1 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPrortyCellID, for: indexPath) as! CollectionPrortyViewCell
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellID , for: indexPath) as! CollectionNormalViewCell
        }
        
        cell.anchor = ancher
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        //1、取出section的HeaderView
        let headView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kHeaderViewID, for: indexPath) as! CollectionHeaderView
        
        //2、取出模型
        headView.group = recommendVM.anchorGroup[indexPath.section]
        return headView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 1 {
            return CGSize(width: kItemW, height: kPrortyItemH)
        }
        
        return CGSize(width: kItemW, height: kNormalItemH)
    }
}

//--发送网络请求
extension RecommentdViewController {
    func loadData() {
        
        //请求推荐数据
        recommendVM.requestData {
            self.collectionView.reloadData()
            
            //将数据传到gameView
            self.gameView.groups = self.recommendVM.anchorGroup
        }
        
        //请求轮播数据
        recommendVM.requestCycleData {
              self.cycleView.cycleModel = self.recommendVM.cycleModel
        }
    }
}



