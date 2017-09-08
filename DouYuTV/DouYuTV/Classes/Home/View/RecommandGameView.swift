//
//  RecommandGameView.swift
//  DouYuTV
//
//  Created by xrh on 2017/9/8.
//  Copyright © 2017年 xiangronghua. All rights reserved.
//

import UIKit

private let kGameCellID = "kGameCellID"
private let kEdgeInsetMargin : CGFloat = 10

class RecommandGameView: UIView {

    //定义数据的属性
    var groups : [AnchorGroup]? {
        didSet {
            //移除前两组数据
            groups?.removeFirst()
            groups?.removeFirst()
            
            //添加更多组
            let moreGroup = AnchorGroup()
            moreGroup.tag_name = "更多"
            groups?.append(moreGroup)
            //刷新表格
            collectionView.reloadData()
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
         super.awakeFromNib()
        
        //设置不随父控件的大小改变而改变
        autoresizingMask = UIViewAutoresizing(rawValue: UInt(noErr))

        //注册cell
        collectionView.register(UINib(nibName: "CollectionGameCell", bundle: nil), forCellWithReuseIdentifier: kGameCellID)
        
        //给gameView添加内边距
        collectionView.contentInset = UIEdgeInsetsMake(0, kEdgeInsetMargin, 0, kEdgeInsetMargin)
    }
}


extension RecommandGameView {
    class func recommandGameView() -> RecommandGameView {
        
        return Bundle.main.loadNibNamed("RecommandGameView", owner: nil, options: nil)!.first as! RecommandGameView
    }
}


//遵守协议
extension RecommandGameView : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kGameCellID, for: indexPath) as! CollectionGameCell
        
        cell.group = groups![indexPath.item]

        
        return cell
    }
}
