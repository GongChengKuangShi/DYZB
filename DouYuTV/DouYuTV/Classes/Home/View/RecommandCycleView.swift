//
//  RecommandCycleView.swift
//  DouYuTV
//
//  Created by xrh on 2017/9/7.
//  Copyright © 2017年 xiangronghua. All rights reserved.
//

import UIKit

private let kCycleCellID = "kCycleCellID"


class RecommandCycleView: UIView {
    
    //定时器
    var cycleTimer : Timer?
    //--定义属性
    var cycleModel : [CycleModel]? {
        didSet {
            collectionView.reloadData()
            
            //设置pageController的个数
            pageViewControl.numberOfPages = cycleModel?.count ?? 0
            
            //默认滚动到中间的一个位置
            
            let indexPath = NSIndexPath(row: (cycleModel!.count ) * 10, section: 0)
            collectionView.scrollToItem(at: indexPath as IndexPath, at: .left, animated: false)
            
            
            //添加定时器
            removeCycleTimer()
            addCycleTimer()
        }
    }
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageViewControl: UIPageControl!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        //设置不随父控件的大小改变而改变
        autoresizingMask = UIViewAutoresizing(rawValue: UInt(noErr))
        
        //注册cell
        collectionView.register(UINib(nibName: "CollectionCycleCell", bundle: nil), forCellWithReuseIdentifier: kCycleCellID)
        
        //注：在这里设置layout的大小不能够拿到最正确的size，需要在layoutSubviews中才行
        
           }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //设置layout
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = collectionView.bounds.size
    }
}


// 快速创建View的类方法
extension RecommandCycleView {
    
    class func recommandCycleView() -> RecommandCycleView {
        
        return Bundle.main.loadNibNamed("RecommandCycleView", owner: nil, options: nil)!.first as! RecommandCycleView
    }
}

//遵守协议
extension RecommandCycleView : UICollectionViewDataSource {
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return cycleModel?.count ?? 0//可选值，补全，成确定值,
        return (cycleModel?.count ?? 0) * 10000//无限轮播
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCycleCellID, for: indexPath) as! CollectionCycleCell
        
        cell.cycleModel = cycleModel![indexPath.item % cycleModel!.count]//无限轮播（%cycleModel!.count）

        return cell
    }
}

extension RecommandCycleView : UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //1、获取滚动的偏移量
//        let offsetX = scrollView.contentOffset.x
        let offsetX = scrollView.contentOffset.x + scrollView.bounds.width * 0.5//这个是scrollview滚动到一半，那个page
        
        //计算pageController的currentIndex
        pageViewControl.currentPage = Int(offsetX / scrollView.bounds.width) % (cycleModel!.count )//取模，无限轮播
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeCycleTimer()
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addCycleTimer()
    }
}

//定时器的操作方法 (定时器用法) http://www.jianshu.com/p/ca95d8504439

extension RecommandCycleView {
    func addCycleTimer() {
        
        cycleTimer = Timer(timeInterval: 3.0, target: self, selector: #selector(self.scrollToNext), userInfo: nil, repeats: true)
        RunLoop.main.add(cycleTimer!, forMode: RunLoopMode.commonModes)
    }
    
    @objc func removeCycleTimer() {
        cycleTimer?.invalidate()//从运行循环中移除
        cycleTimer = nil
    }
    
    @objc func scrollToNext() {
        //滚动偏移量
        let currentOffsetX = collectionView.contentOffset.x
        let offsetx = currentOffsetX + collectionView.bounds.width
        
        //滚动的位置
        collectionView.setContentOffset(CGPoint(x: offsetx, y: 0), animated: true)
    }
}

 
