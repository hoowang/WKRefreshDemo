//
//  WKGIFRefreshFooter.swift
//  WKRefreshDemo
//
//  Created by 王虎 on 16/5/5.
//  Copyright © 2016年 hooge. All rights reserved.
//

import UIKit

public class WKGIFRefreshFooter: WKRichRefreshFooter {
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

extension WKGIFRefreshFooter{
    
    public override class func refreshFooterFor(
        scrollView:UIScrollView, callback:()->(Void)) -> (WKRefreshControl){
        let header = WKGIFRefreshFooter()
        header.callbackMode = .ClosureMode
        scrollView.addSubview(header)
        header.callback = callback
        return header
    }
    
    public override class func refreshFooterFor(
        scrollView:UIScrollView, target:AnyObject, action:Selector) -> (WKRefreshControl){
        let refreshHeader = WKGIFRefreshFooter()
        refreshHeader.callbackMode = .SelectorMode
        refreshHeader.targetObject = target
        refreshHeader.selector = action
        scrollView.addSubview(refreshHeader)
        return refreshHeader
    }
}
