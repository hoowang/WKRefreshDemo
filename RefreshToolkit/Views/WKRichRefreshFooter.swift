//
//  WKRichRefreshFooter.swift
//  WKRefreshDemo
//
//  Created by hooge on 16/5/5.
//  Copyright © 2016年 hooge. All rights reserved.
//

import UIKit

public class WKRichRefreshFooter: WKRefreshFooter {
    internal lazy var animatorView:WKAnimationView = self.animationView()
    internal let descritionLabel = UILabel()
   
    override func initialize() {
        super.initialize()
        self.addSubview(self.descritionLabel)
        self.addSubview(self.animatorView)
        self.animatorView.wk_Size = self.animatorView.AnimationViewSize()
        self.animatorView.changeArrowDirection(.South)
        self.descritionLabel.font = UIFont.boldSystemFontOfSize(14)
        self.descritionLabel.textAlignment = NSTextAlignment.Center
        self.descritionLabel.textColor = UIColor(red: 0.514, green: 0.514, blue: 0.514, alpha: 1.0)
        self.descritionLabel.text = self.beginRefreshText()

    }
    
    override func placeSubViews() {
        super.placeSubViews()
        self.resizeSubViews()
    }
    
    private func resizeSubViews() -> (Void){
        // 计算并设置Label的位置
        let labelHeight = self.wk_Height - 2 * 1.0
        self.descritionLabel.frame = CGRectMake(0, 0, self.wk_Width, labelHeight)
       
        let rectDesc = self.descritionLabel.textRectForBounds(
            self.descritionLabel.bounds, limitedToNumberOfLines: 1)
        let textStartX:CGFloat = rectDesc.origin.x
        let spacingValue:CGFloat = 10.0
        // 计算并设置动画View的位置
        let animationViewX = textStartX - self.animatorView.wk_Width - spacingValue
        let animationViewY = (self.wk_Height - self.animatorView.wk_Height) * 0.5
        self.animatorView.wk_Origin = CGPointMake(animationViewX, animationViewY)
    }
}

extension WKRichRefreshFooter{
    
    override func scrollViewContentOffsetDidChanged(change: Dictionary<String, AnyObject>?) {
        super.scrollViewContentOffsetDidChanged(change)
        let contentOffsetY = self.scrollView!.wk_OffsetY;
        let contentSizeHeight = self.scrollView!.contentSize.height
        let scrollViewHeight = self.scrollView!.wk_Height
        if  contentSizeHeight <= 0 {
            return
        }
        
        if (contentOffsetY + scrollViewHeight < contentSizeHeight){
            return
        }
        
        let pullPercent =
            (contentOffsetY + scrollViewHeight - self.scrollView!.contentSize.height) / self.wk_Height
        // print("pullPercent:\(pullPercent)")
        
        if self.scrollView!.dragging {
            self.refreshState = .DragingState
            if pullPercent < 0.8 {
                self.animatorView.changeState(.Normal)
                return
            }
            // 拖动比例大于0.8时 开始切换为即将刷新状态
            dispatch_async(dispatch_get_main_queue()) {
                [unowned self] in
                self.refreshState = .WillRefreshState
                self.descritionLabel.text = self.willStartRefreshText()
                self.animatorView.changeState(.WillRefresh)
            }
            
            return
        }

        guard self.refreshState == .RefreshingState else{
            self.refreshState = .ReleaseState
            self.animatorView.changeState(.Normal)
            self.animatorView.changeArrowDirection(.South)
            return
        }

        self.descritionLabel.text = self.refreshingText()
        self.animatorView.changeState(.StartRefresh)
    }
    
    public override func completeRefresh() {
        super.completeRefresh()
        //重置动画执行器状态
        self.refreshState = .IdleState
        self.animatorView.changeState(.Normal)
    }
}

extension WKRichRefreshFooter{
    // 返回动画器View
    public func animationView() -> (WKAnimationView){
        let animationView =  WKArrowActivityAnimationView()
        return animationView
    }
    
    public func beginRefreshText() -> (String){
        return "上拉可以加载更多数据"
    }
    
    public func willStartRefreshText() ->(String){
        return "松开立即加载更多数据"
    }
    
    public func refreshingText() -> (String){
        return "正在加载更多数据..."
    }
}

extension WKRichRefreshFooter{
    
    public override class func refreshFooterFor(
        scrollView:UIScrollView, callback:()->(Void)) -> (WKRefreshControl){
        let header = WKRichRefreshFooter()
        header.callbackMode = .ClosureMode
        header.callback = callback
        scrollView.addSubview(header)
        return header
    }
    
    public override class func refreshFooterFor(
        scrollView:UIScrollView, target:AnyObject, action:Selector) -> (WKRefreshControl){
        let refreshHeader = WKRichRefreshFooter()
        refreshHeader.callbackMode = .SelectorMode
        refreshHeader.targetObject = target
        refreshHeader.selector = action
        scrollView.addSubview(refreshHeader)
        return refreshHeader
    }
}

