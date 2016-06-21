//
//  WKPureRefreshFooter.swift
//  WKRefreshDemo
//
//  Created by hooge on 16/5/5.
//  Copyright © 2016年 hooge. All rights reserved.
//
//  这是一个纯洁的上拉刷新组件 仅仅显示一个指示器


import UIKit

public class WKPureRefreshFooter: WKRefreshFooter {

    private let activityView = UIActivityIndicatorView(activityIndicatorStyle:.Gray)
    override func initialize() {
        super.initialize()
        self.addSubview(self.activityView)
    }
    
    override func placeSubViews() {
        super.placeSubViews()
        let activityWH:CGFloat = 30.0
        let activityX = (self.wk_Width - activityWH) * 0.5
        let activityY = (self.wk_Height - activityWH) * 0.5
        self.activityView.frame = CGRectMake(activityX, activityY, activityWH, activityWH)
    }
    
    override func loadAnimators() {
        self.activityView.startAnimating()
    }
    
    override func unloadAnimators() {
        self.activityView.stopAnimating()
    }
    
    public override func completeRefresh() {
        super.completeRefresh()
        self.activityView.stopAnimating()
    }
}

extension WKPureRefreshFooter{
    
    public override class func refreshFooterFor(
        scrollView:UIScrollView, callback:()->(Void)) -> (WKRefreshControl){
        let header = WKPureRefreshFooter()
        header.callbackMode = .ClosureMode
        header.callback = callback
        scrollView.addSubview(header)
        return header
    }
    
    public override class func refreshFooterFor(
        scrollView:UIScrollView, target:AnyObject, action:Selector) -> (WKRefreshControl){
        let refreshHeader = WKPureRefreshFooter()
        refreshHeader.callbackMode = .SelectorMode
        refreshHeader.targetObject = target
        refreshHeader.selector = action
        scrollView.addSubview(refreshHeader)
        return refreshHeader
    }
}