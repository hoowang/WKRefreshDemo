//
//  WKRichRefreshHeader.swift
//  WKRefreshDemo
//
//  Created by hooge on 16/5/3.
//  Copyright © 2016年 hooge. All rights reserved.
//
//   功能丰富的下拉刷新组件、带有简单的动画状态

import UIKit

public class WKRichRefreshHeader: WKRefreshHeader {

    internal lazy var animatorView:WKAnimationView = self.animationView()
    internal let descritionLabel = UILabel()
    internal let lastUpdateLabel = UILabel()
    
    override func initialize() {
        super.initialize()
        self.addSubview(self.descritionLabel)
        self.addSubview(self.lastUpdateLabel)
        self.addSubview(self.animatorView)
        self.animatorView.wk_Size = self.animatorView.AnimationViewSize()
        self.descritionLabel.font = UIFont.boldSystemFontOfSize(14)
        self.lastUpdateLabel.font = UIFont.boldSystemFontOfSize(14)
        self.descritionLabel.textAlignment = NSTextAlignment.Center
        self.lastUpdateLabel.textAlignment = NSTextAlignment.Center
        self.descritionLabel.textColor = UIColor(red: 0.514, green: 0.514, blue: 0.514, alpha: 1.0)
        self.lastUpdateLabel.textColor = UIColor(red: 0.514, green: 0.514, blue: 0.514, alpha: 1.0)
        self.descritionLabel.text = self.beginRefreshText()
        self.lastUpdateLabel.text = self.updateTimeText()
    }
    
    deinit{
        wkLog("释放WKRichRefreshHeader")
    }
    
    override func placeSubViews() {
        super.placeSubViews()
        self.resizeSubViews()
    }
    
    private func resizeSubViews() -> (Void){
       
        // 计算并设置Label的位置
        let labelSpacing:CGFloat = 5.0
        let labelHeight = (self.wk_Height - labelSpacing) * 0.5
        self.descritionLabel.frame = CGRectMake(0, 0, self.wk_Width, labelHeight)
        self.lastUpdateLabel.frame = CGRectMake(
            0, self.descritionLabel.wk_Height + labelSpacing, self.wk_Width, labelHeight)
        
        let rectDesc = self.descritionLabel.textRectForBounds(
            self.descritionLabel.bounds, limitedToNumberOfLines: 1)
        let rectLastUpdate = self.lastUpdateLabel.textRectForBounds(
            self.lastUpdateLabel.bounds, limitedToNumberOfLines: 1)
     
        var textStartX:CGFloat = 0.0
        if rectDesc.origin.x < rectLastUpdate.origin.x{
            textStartX = rectDesc.origin.x
        } else{
            textStartX = rectLastUpdate.origin.x
        }
        
        let spacingValue:CGFloat = 20.0
        // 计算并设置动画View的位置
        let animationViewX = textStartX - self.animatorView.wk_Width - spacingValue
        let animationViewY = (self.wk_Height - self.animatorView.wk_Height) * 0.5
        self.animatorView.wk_Origin = CGPointMake(animationViewX, animationViewY)
    }
    
    internal override func changeIndicatorState(state:AnimationState) {
        self.animatorView.changeState(state)
    }
}

extension WKRichRefreshHeader{
    
    override func scrollViewContentOffsetDidChanged(change: Dictionary<String, AnyObject>?) {
        super.scrollViewContentOffsetDidChanged(change)
        
        let offsetY = self.scrollView?.wk_OffsetY;
        // 头部控件刚好出现的offsetY,向下拉的时候 contentoffsetY是负值
        let happenOffsetY = 0 - self.scrollViewOriginalInset.top;
        if (offsetY > happenOffsetY){
            return
        }

        let normal2pullingOffsetY = happenOffsetY - self.wk_Height;
        if self.scrollView!.dragging {
            if self.refreshState == .IdleState  && offsetY < normal2pullingOffsetY {
                self.refreshState = .DragingState
                dispatch_async(dispatch_get_main_queue(), {
                    [unowned self] in
                    self.descritionLabel.text = self.willStartRefreshText()
                    self.animatorView.changeState(.WillRefresh)
                })
            }
        }
        
        guard self.refreshState == WKRefreshState.RefreshingState else{
            return
        }
        self.descritionLabel.text = self.refreshingText()
        self.animatorView.changeState(.StartRefresh)
    }
    
    public override func completeRefresh() {
        super.completeRefresh()
        //重置动画执行器状态
        self.descritionLabel.text = self.beginRefreshText()
        self.animatorView.changeState(.Normal)
    }
}

extension WKRichRefreshHeader{
    override func refreshHandler() {
        self.codeToRefresh = true
        super.refreshHandler()
    }
}

// MARK: - 外部调用的类方法
extension WKRichRefreshHeader{
    
    public override class func refreshHeaderFor(
        scrollView:UIScrollView, callback:()->(Void)) -> (WKRefreshControl){
        let header = WKRichRefreshHeader()
        header.callbackMode = .ClosureMode
        header.callback = callback
        scrollView.addSubview(header)
        return header
    }
    
    public override class func refreshHeaderFor(
        scrollView:UIScrollView, target:AnyObject, action:Selector) -> (WKRefreshControl){
        let refreshHeader = WKRichRefreshHeader()
        refreshHeader.callbackMode = .SelectorMode
        refreshHeader.targetObject = target
        refreshHeader.selector = action
        scrollView.addSubview(refreshHeader)
        return refreshHeader
    }
}

// MARK: - 这部分代码由子类来覆盖
extension WKRichRefreshHeader{
    
    // 返回动画器View
    public func animationView() -> (WKAnimationView){
        let animationView =  WKArrowActivityAnimationView()
        return animationView
    }
    
    public func beginRefreshText() -> (String){
        return "下拉可以刷新"
    }
    
    public func willStartRefreshText() ->(String){
        return "松开立即刷新"
    }
    
    public func refreshingText() -> (String){
        return "正在刷新数据中..."
    }
    
    public func updateTimeText() -> (String){
        return "最后更新:"
    }
}
