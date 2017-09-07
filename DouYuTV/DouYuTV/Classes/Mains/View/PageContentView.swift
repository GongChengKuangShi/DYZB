//
//  PageContentView.swift
//  DouYuTV
//
//  Created by xrh on 2017/9/5.
//  Copyright © 2017年 xiangronghua. All rights reserved.
//

//视屏地址：http://study.163.com/course/courseLearn.htm?courseId=1003309014&from=study#/learn/video?lessonId=1003764483&courseId=1003309014

import UIKit

private let ContentCellID = "ContentCellID"

protocol PageContentViewDelegate: class {
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int)
}


class PageContentView: UIView {

    //MARK:- 懒加载属性
    var chidldVs: [UIViewController]
    var startOffsetX: CGFloat = 0
    
    /*
     HomeViewController对pageContentView是强引用，而pageContentView对UIViewController（也就是HomeViewController）也是强引用，所以会造成一个循环引用，会造成两个对象不能销毁掉
     */
    weak var parenViewController : UIViewController?
    var isForbidScrollDelegate : Bool = false
    weak var delegate : PageContentViewDelegate?
    
    /*
       因为创建懒加载是一个闭包，所以self.用法可能会造成循环引用，所以需要把它变成弱引用
     */
    lazy var collectionView: UICollectionView = { [weak self] in
       
        // 1
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        // 2
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ContentCellID)
        
        return collectionView
    }()
    
    //-- 自定义构造函数
    init(frame: CGRect, childVcs: [UIViewController], parentViewController: UIViewController?) {
        self.chidldVs = childVcs
        self.parenViewController = parentViewController
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// -- 设置UI界面
extension PageContentView {
    
    // 1、将所有的子控制器添加到父控制器中
    func setupUI() {
        for chidldVc in chidldVs {
            parenViewController?.addChildViewController(chidldVc)
        }
        
        //2、添加UIControllerView，用于在Cell中存储控制器的View
        addSubview(collectionView)
        collectionView.frame = bounds
    }
}


// -- CollectionViewDataSource
extension PageContentView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chidldVs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCellID, for: indexPath)
    
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        let childVC = chidldVs[indexPath.row]
        childVC.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVC.view)
        
        return cell
    }
}

extension PageContentView : UICollectionViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        isForbidScrollDelegate = false
        startOffsetX = scrollView.contentOffset.x
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //0、判断是否是点击事件
        if isForbidScrollDelegate { return }
        
        // 1、定义获取需要的数据
        var progress: CGFloat = 0
        var sourceIndex: Int = 0
        var targetIndex: Int = 0
        
        //2、判断左滑还是右滑
        
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        
        if currentOffsetX > startOffsetX { // 左滑
            
            // 1、计算progress
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            
            // 2、计算sourceIndex
            sourceIndex = Int(currentOffsetX / scrollViewW)
            
            // 3、计算targetIndex
            targetIndex = sourceIndex + 1
            if targetIndex >= chidldVs.count {
                targetIndex = chidldVs.count - 1
            }
            
            //4、如果完全滑过去了
            if currentOffsetX - startOffsetX == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
            
        } else { //右滑
            // 1、计算progress
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            
            // 2、计算targetIndex
            targetIndex = Int(currentOffsetX / scrollViewW)
            
            //3、计算sourceIndex
            sourceIndex = targetIndex + 1
            if sourceIndex >= chidldVs.count {
                sourceIndex = chidldVs.count - 1
            }
        }
        
        //3、将progress、sourceIndex、targetIndex传递给titleView
        print("progress:\(progress) sourceIndex\(sourceIndex) targetIndex:\(targetIndex)")
        delegate?.pageContentView(contentView: self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}


// 对外接口方法
extension PageContentView {
    func setupCurrentIndex(currentIndex: Int) {
        
        //1、记录需要禁止执行代理方法
        isForbidScrollDelegate = true
        
        //2、滚动到正确的位置
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
}

