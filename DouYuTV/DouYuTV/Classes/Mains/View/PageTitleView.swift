//
//  PageTitleView.swift
//  DouYuTV
//
//  Created by xiangronghua on 2017/9/4.
//  Copyright © 2017年 xiangronghua. All rights reserved.
//

import UIKit

// 定义协议
protocol PageTitleViewDelegate: class {//表示协议只能被类接受
    func pageTitleView(titleView: PageTitleView, selectedIndex index: Int)// (selectedIndex：外部参数， index：内部参数)
}

//定义常量
private let kScrollLineH: CGFloat = 2
private let kNormalColor: (CGFloat, CGFloat, CGFloat) = (85, 85, 85)
private let kSelectColor: (CGFloat, CGFloat, CGFloat) = (255, 120, 8)

class PageTitleView: UIView {
    
    var titles: [String]
    var currnentIndex: Int = 0
    weak var delegate : PageTitleViewDelegate?
    //懒加载属性
    lazy var titleLabel: [UILabel] = [UILabel]()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        return scrollView
    }()
    
    lazy var scrollViewLine: UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orange
        return scrollLine
    }()
    
    //MARK：- 自定义构造函数
    init(frame: CGRect, titles: [String]) {
        self.titles = titles
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension PageTitleView {
    func setupUI() {
        addSubview(scrollView)
        scrollView.frame = bounds
        
        // 通过title设置label
        setupTitleLabels()
        
        //设置底线和滚动的滑块
        setipBottomLineAndScrollViewLine()
    }
    
    func setupTitleLabels() {
        
        let labelW: CGFloat = frame.width / CGFloat(titles.count)
        let labelH: CGFloat = frame.height - kScrollLineH
        let labelY: CGFloat = 0
        
        for (index, title) in titles.enumerated() {
            
            //创建label
            let label = UILabel()
            
            // 设置label属性
            label.text = title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            label.textAlignment = .center
            
            //将label添加到scrollView上
            let labelX: CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            
            scrollView.addSubview(label)
            titleLabel.append(label)
            
            // 给label设置手势
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelClick(tapGes:)))
            label.addGestureRecognizer(tapGes)
        }
    }
    
    func setipBottomLineAndScrollViewLine() {
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGray
        let lineH: CGFloat = 0.5
        bottomLine.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        addSubview(bottomLine)
        
        //添加scrollviewLine
        //获取第一个label
        guard let firtLabel = titleLabel.first else {//guard 判断第一个值是否为空
            return
        }
        firtLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        scrollView.addSubview(scrollViewLine)
        scrollViewLine.frame = CGRect(x: firtLabel.frame.origin.x, y: frame.height - kScrollLineH, width: firtLabel.frame.width, height: kScrollLineH)
    }
}

// MARK: --监听Label的点击事件
extension PageTitleView {
    @objc func titleLabelClick(tapGes: UITapGestureRecognizer) {

        // 获取当前label的下标值
        guard let currentLabel = tapGes.view as? UILabel else {
            return
        }
        
        // 2、获取之前的Label
        let oldLabel = titleLabel[currnentIndex]
        
        //如果是点击同一个Label的话，就不变
        if oldLabel.text == currentLabel.text {
            return
        }
        
        // 切换文字颜色
        currentLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        oldLabel.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        
        
        //保存最新的Label的下标值
        currnentIndex = currentLabel.tag
        
        // 滚动条的位置
        let scrollLineX = CGFloat(currentLabel.tag) * scrollViewLine.frame.width
        UIView.animate(withDuration: 0.15) { 
            self.scrollViewLine.frame.origin.x = scrollLineX
        }
        
        
        //通知代理
        delegate?.pageTitleView(titleView: self, selectedIndex: currnentIndex)
    }
}

// MARK: - 对外公开接口
extension PageTitleView {
    func setTitleWithProgress(progress: CGFloat, sourceIndex: Int, targetIndx: Int) {
        // 1、取出sourceLabel、targetLabel
        let sourceLabel = titleLabel[sourceIndex]
        let targetLabel = titleLabel[targetIndx]
        
        //2、处理滑块逻辑
        let moveTotelX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = moveTotelX * progress
        scrollViewLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        
        //3、颜色的渐变
        //3.1、取出变化范围
        let colorDelta = (kSelectColor.0 - kNormalColor.0, kSelectColor.1 - kNormalColor.1, kSelectColor.2 - kNormalColor.2)
        
        //3.2先变化sourceLabel
        sourceLabel.textColor = UIColor(r: kSelectColor.0 - colorDelta.0 * progress, g: kSelectColor.1 - colorDelta.1 * progress, b: kSelectColor.2 - colorDelta.2 * progress)
        
        
        //3.2再变化targetLabel
        targetLabel.textColor = UIColor(r: kNormalColor.0 + colorDelta.0 * progress, g: kNormalColor.1 + colorDelta.1 * progress, b: kNormalColor.2 + colorDelta.2 * progress)
    
        //4、记录最新的index
        currnentIndex = targetIndx
    }
}
