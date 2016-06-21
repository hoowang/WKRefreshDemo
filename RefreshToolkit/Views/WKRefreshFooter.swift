//
//  WKRefreshFooter.swift
//  WKRefreshDemo
//
//  Created by hooge on 16/5/4.
//  Copyright © 2016年 hooge. All rights reserved.
//

import UIKit

public class WKRefreshFooter: WKRefreshControl {

    override func initialize() {
        super.initialize()
        self.wk_Height = WKAppearance.refreshFooterHeight
        self.scrollView?.bounces = false
    }
    
    override func placeSubViews() {
        super.placeSubViews()
        self.wk_Origin.y = (self.scrollView?.contentSize.height)!
    }
    
    override func scrollViewContentOffsetDidChanged(change: Dictionary<String, AnyObject>?) {
        super.scrollViewContentOffsetDidChanged(change)
        
        guard self.refreshState != .RefreshingState else {
            return
        }
        
        let contentSizeHeight = self.scrollView?.contentSize.height
        guard contentSizeHeight > 0 else {
            return
        }
        
        let contentOffsetY = self.scrollView!.contentOffset.y
        let scrollViewHeight = self.scrollView?.wk_Height
        
        // 这行代码主要是控制动画出现的时机
        guard contentOffsetY + scrollViewHeight! > contentSizeHeight! + self.wk_Height * 0.3 else{
            return
        }

        self.loadAnimators()
        guard contentOffsetY + scrollViewHeight! > contentSizeHeight! + self.wk_Height * 0.8 else{
            self.unloadAnimators()
            return
        }
        
        guard self.scrollView!.dragging else{
            
            self.beginRefresh()
            return
        }
    }
}

// MARK: - 公共类方法
extension WKRefreshFooter{
    
    public class func refreshFooterFor(
        scrollView:UIScrollView, callback:()->(Void)) -> (WKRefreshControl){
        let refreshControl = WKRefreshFooter()
        refreshControl.callbackMode = .ClosureMode
        refreshControl.callback = callback
        scrollView.alwaysBounceVertical = false
        scrollView.addSubview(refreshControl)
        return refreshControl
    }
    
    public class func refreshFooterFor(
        scrollView:UIScrollView, target:AnyObject, action:Selector) -> (WKRefreshControl){
        let refreshHeader = WKRefreshFooter()
        refreshHeader.callbackMode = .SelectorMode
        refreshHeader.targetObject = target
        refreshHeader.selector = action
        scrollView.addSubview(refreshHeader)
        return refreshHeader
    }
}

extension WKRefreshFooter{
    public override func completeRefresh() -> (Void){
        self.refreshState = .IdleState
        dispatch_async(dispatch_get_main_queue(), {
            [unowned self] in
            UIView.animateWithDuration(0.35, animations: {
                [unowned self] in
                self.scrollView?.contentInset = self.scrollViewOriginalInset
            })
        })
    }
}

extension WKRefreshFooter{
    internal func loadAnimators() -> (Void){}
    internal func unloadAnimators() -> (Void){}
    public override func beginRefresh(){
        self.refreshState = .RefreshingState
        UIView.animateWithDuration(WKAppearance.animationDuration, animations: {
            [unowned self] in
            let newBottomInset = self.scrollViewOriginalInset.bottom + self.wk_Height
            self.scrollView?.wk_InsetBottom = newBottomInset
            self.scrollView?.wk_OffsetY += newBottomInset
            
        }) {[unowned self] (_) in
            
            switch self.callbackMode{
                
            case .ClosureMode:
                self.callback()
                break
            case .SelectorMode:
                guard self.targetObject!.respondsToSelector(self.selector!) else{
                    return
                }
                self.targetObject?.performSelector(self.selector!)
                break
            }
            
        }
    }
}