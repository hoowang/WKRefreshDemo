//
//  WKGIFRefreshHeader.swift
//  WKRefreshDemo
//
//  Created by hooge on 16/5/3.
//  Copyright © 2016年 hooge. All rights reserved.
//
//  带有GIF动画的 刷新组件

import UIKit

public class WKGIFRefreshHeader: WKRichRefreshHeader {
    
    // MARK: - 直接重写这个方法 返回自己定制的GIF动画View
    public override func animationView() -> (WKAnimationView) {
        
        return WKGIFAnimationView()
    }
    
    override func initialize() {
        super.initialize()
    }
    
    // MARK: - 这个接口帮你隐藏文本展示的Label
    public func hideTextLabel(){
        // 隐藏掉Label 同时把动画移动到中间(这个操作延迟到layoutSubViews方法)
        self.descritionLabel.hidden = true
        self.lastUpdateLabel.hidden = true
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.descritionLabel.hidden {
            let animatorX = (self.wk_Width - self.animatorView.wk_Width) * 0.5
            let animatorY = (self.wk_Height - self.animatorView.wk_Height) * 0.5
            self.animatorView.frame = CGRectMake(animatorX, animatorY, 50, 50)
        }
    }
    
    public override func completeRefresh() {
        super.completeRefresh()
        self.animatorView.stopAnimation()
    }
}

// MARK: - 供外部调用的类方法
extension WKGIFRefreshHeader{
    
    public override class func refreshHeaderFor(
        scrollView:UIScrollView, callback:()->(Void)) -> (WKRefreshControl){
        let header = WKGIFRefreshHeader()
        header.callbackMode = .ClosureMode
        header.callback = callback
        scrollView.addSubview(header)
        return header
    }
    
    public override class func refreshHeaderFor(
        scrollView:UIScrollView, target:AnyObject, action:Selector) -> (WKRefreshControl){
        let refreshHeader = WKGIFRefreshHeader()
        refreshHeader.callbackMode = .SelectorMode
        refreshHeader.targetObject = target
        refreshHeader.selector = action
        scrollView.addSubview(refreshHeader)
        return refreshHeader
    }
}
