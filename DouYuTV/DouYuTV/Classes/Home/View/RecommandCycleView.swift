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
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageViewControl: UIPageControl!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        //设置不随父控件的大小改变而改变
        autoresizingMask = UIViewAutoresizing(rawValue: UInt(noErr))
        
        //注册cell
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kCycleCellID)
        
        //注：在这里设置layout的大小不能够拿到最正确的size，需要在layoutSubviews中才行
        
           }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //设置layout
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = collectionView.bounds.size
//        layout.minimumLineSpacing = 0
//        layout.minimumInteritemSpacing = 0
//        layout.scrollDirection = .vertical
//        collectionView.isPagingEnabled = true
        

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
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCycleCellID, for: indexPath)
        
        cell.backgroundColor = indexPath.item % 2 == 0 ? UIColor.red : UIColor.orange
        
        return cell
    }
}
