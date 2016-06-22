//
//  WKRefreshHeader.swift
//  WKRefreshDemo
//
//  Created by hooge on 16/4/29.
//  Copyright © 2016年 hooge. All rights reserved.
//

import UIKit

public class WKRefreshHeader: WKRefreshControl {
    
    private var isDragStateChanged = false
    private var isScrollViewDragged = false
    override func initialize() -> (Void){
        super.initialize()
        self.wk_Height = WKAppearance.refreshHeaderHeight
    }
    
    deinit{
        wkLog("WKRefreshHeader 被释放")
    }
    
    override func placeSubViews() -> (Void){
        super.placeSubViews()
        self.wk_Origin.y = 0 - WKAppearance.refreshHeaderHeight
    }
    
    
    override func scrollViewContentOffsetDidChanged(
        change:Dictionary<String, AnyObject>?) -> (Void) {
        
        // 需要排除的几种情况
        // 一.加载tableView时 系统自动调整间距并非下拉拖动刷新引起的offsetChange
        //         也不是代码刷新引起的调整 这两种情况不需要做多余的操作
        
        // 1.既没有拖拽 也没有代码刷新 跳过系统自动调整contentOffset 操作
        if self.scrollView!.dragging {
            self.isScrollViewDragged = true
        }
        
        if self.scrollView!.dragging == false && self.codeToRefresh == false && self.isScrollViewDragged == false{
            return
        }
        
        // 2.正在拖拽或者正在通过代码形式刷新 同时处于刷新状态 直接返回 保证一次操作的完整性
        if (self.scrollView!.dragging == true ||
            self.codeToRefresh == true) &&
            self.refreshState == .RefreshingState {
            return
        }
        
        // 3.如果是向上拖拽 直接返回（下拉刷新不必处理上拉情况）
        let contentOffsetY = self.scrollView!.contentOffset.y
        let topInset = self.scrollView!.contentInset.top
        // 向上拖拽的时候 contentOffset的绝对值可能会小于topInset contentOffset本身可能会大于topInset
        if (fabs(contentOffsetY) <= topInset) || contentOffsetY >= topInset {
            return
        }
        // 4.拖拽到一定距离 切换拖拽控件的动画
        let offset = fabs(contentOffsetY) - topInset

        if offset >= self.wk_Height * 0.6 && self.isDragStateChanged == false{
            self.changeIndicatorState(.WillRefresh)
            self.isDragStateChanged = true
        }
        
        if offset < self.wk_Height * 0.8 {
            return
        }
        if self.scrollView!.dragging == false {
            self.loadAnimators()
            self.refreshHandler()
            self.isScrollViewDragged = false
        }
    }
    
    internal func loadAnimators() ->(Void) {}
    internal func unloadAnimators() ->(Void) {}
    internal func changeIndicatorState(state:AnimationState) ->(Void){}
    
    
    public override func completeRefresh() -> (Void){
        self.refreshState = .IdleState
        dispatch_async(dispatch_get_main_queue(), {
            [unowned self] in
            UIView.animateWithDuration(0.35, animations: {
                [unowned self] in
                self.scrollView?.contentInset = self.scrollViewOriginalInset
                self.unloadAnimators()
                self.changeIndicatorState(.Normal)
                self.isDragStateChanged = false
            })
        })
    }
    
    public  class func refreshHeaderFor(
        scrollView:UIScrollView, callback:()->(Void)) -> (WKRefreshControl){
        let header = WKRefreshHeader()
        header.callbackMode = .ClosureMode
        header.callback = callback
        scrollView.addSubview(header)
        return header
    }
    
    public  class func refreshHeaderFor(
        scrollView:UIScrollView, target:AnyObject, action:Selector) -> (WKRefreshControl){
        let refreshHeader = WKRefreshHeader()
        refreshHeader.callbackMode = .SelectorMode
        refreshHeader.targetObject = target
        refreshHeader.selector = action
        scrollView.addSubview(refreshHeader)
        return refreshHeader
    }
}

extension WKRefreshHeader{
    
    internal func refreshHandler(){

        self.refreshState = .RefreshingState
        UIView.animateWithDuration(WKAppearance.animationDuration, animations: {
            [unowned self] in
            var newTopInset = self.scrollView!.contentInset.top + self.wk_Height
            //wkLog("newTopInset:\(newTopInset)")
            // 加上这句代码是为了解决PureHeader出现的莫名其妙的bug
            if newTopInset > 64.0 + self.wk_Height{
                newTopInset = self.scrollViewOriginalInset.top + self.wk_Height
            }
            //wkLog("newTopInset:\(newTopInset)")
            self.scrollView?.wk_InsetTop = newTopInset
            self.scrollView?.wk_OffsetY = 0.0 - newTopInset

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
        self.refreshState = .IdleState
    }
    
    public override func beginRefresh(){
        self.refreshHandler()
    }
}