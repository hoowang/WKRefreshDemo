//
//  WKPureRefreshHeader.swift
//  WKRefreshDemo
//
//  Created by hooge on 16/5/4.
//  Copyright © 2016年 hooge. All rights reserved.
//

import UIKit

public class WKPureRefreshHeader: WKRefreshHeader {

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
        dispatch_async(dispatch_get_main_queue()) {
            self.activityView.startAnimating()
        }
    }
    
    override func unloadAnimators() {
        dispatch_async(dispatch_get_main_queue()) { 
            
            self.activityView.stopAnimating()
        }
    }
    
    public override func completeRefresh() {
        super.completeRefresh()
        self.activityView.stopAnimating()
    }
    
    override func changeIndicatorState(state:AnimationState) {
        self.activityView.startAnimating()
    }
    
    deinit{
        wkLog("WKPureRefreshHeader deinit")
    }
}

extension WKPureRefreshHeader{
    
    internal override func refreshHandler() {
        self.codeToRefresh = true
        super.refreshHandler()
    }
}

extension WKPureRefreshHeader{
    
    public override class func refreshHeaderFor(
        scrollView:UIScrollView, callback:()->(Void)) -> (WKRefreshControl){
        let header = WKPureRefreshHeader()
        header.callbackMode = .ClosureMode
        header.callback = callback
        scrollView.addSubview(header)
        return header
    }
    
    public override class func refreshHeaderFor(
        scrollView:UIScrollView, target:AnyObject, action:Selector) -> (WKRefreshControl){
        let refreshHeader = WKPureRefreshHeader()
        refreshHeader.callbackMode = .SelectorMode
        refreshHeader.targetObject = target
        refreshHeader.selector = action
        scrollView.addSubview(refreshHeader)
        return refreshHeader
    }
}
