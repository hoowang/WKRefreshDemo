//
//  WKRefreshControl.swift
//  WKRefreshDemo
//
//  Created by hooge on 16/4/27.
//  Copyright © 2016年 hooge. All rights reserved.
//
//  这个类是一切组件的基类 但是swift不好实现真正意义上的抽象基类（协议与C++中的抽象基类还是有很大的区别）
//  这个类主要做了一些核心的实现同时定义了相关接口 你绝不应该直接使用这个类创建对象并使用 因为没法正常使用

import UIKit

enum WKRefreshState {
    case InvalidState           // 0.无效状态
    case IdleState              // 1.闲置状态
    case DragingState           // 2.正在下拉状态
    case WillRefreshState       // 3.即将刷新
    case RefreshingState        // 4.正在刷新状态
    case ReleaseState           // 5.松开手状态[没有刷新]
    case RefreshCompleteState   // 6.刷新完成
}

enum WKCallbackMode {
    case ClosureMode
    case SelectorMode
}

public class WKRefreshControl: UIView {
    private let WKRefreshKeyPathContentOffset = "contentOffset"
    internal var callbackMode = WKCallbackMode.ClosureMode
    internal weak var scrollView:UIScrollView?
    internal var refreshState = WKRefreshState.InvalidState
    internal var callback:(()->(Void)) = {}
    internal weak var targetObject:AnyObject?
    internal var selector:Selector?
    internal var codeToRefresh = false
    
    // 用于记录scrollView的初始Inset值
    internal var scrollViewOriginalInset = UIEdgeInsetsZero
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    deinit{
        wkLog("WKRefreshControl 被释放")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 以下是内部虚方法 调整子控件 由子类来实现
    internal func initialize() -> (Void){
        self.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        self.backgroundColor = UIColor.clearColor()
    }
}

// MARK: - 私有接口
extension WKRefreshControl{
    
    private func addObservers() -> (Void){
        let options:NSKeyValueObservingOptions = [NSKeyValueObservingOptions.New,
                                                  NSKeyValueObservingOptions.Old]
        self.scrollView?.addObserver(
            self, forKeyPath:WKRefreshKeyPathContentOffset, options:options, context: nil)
    }
    
    private func removeObservers() -> (Void){
        self.superview?.removeObserver(self, forKeyPath: WKRefreshKeyPathContentOffset, context: nil)
    }
}

// KVO处理方法
extension WKRefreshControl{
    
    public override func observeValueForKeyPath(
        keyPath: String?, ofObject object: AnyObject?,
        change: [String : AnyObject]?,
        context: UnsafeMutablePointer<Void>) {
        guard keyPath != nil else {
            return
        }
        
        switch keyPath! {
        case WKRefreshKeyPathContentOffset:
            self.scrollViewContentOffsetDidChanged(change)
            break;
            
        default:
            break;
        }
    }
}

// MARK: - 重写父类相关的方法
extension WKRefreshControl{
    
    public override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        guard newSuperview != nil && (newSuperview?.isKindOfClass(UIScrollView.classForCoder()))!
        else{
            self.removeObservers()
            return
        }
        
        self.scrollView = newSuperview as? UIScrollView
        self.wk_Origin.x = 0
        self.wk_Width = (newSuperview?.wk_Width)!
      
        self.addObservers()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.placeSubViews()
        guard self.scrollView != nil else{
            return
        }
        let originalInset = self.scrollView!.contentInset
        self.scrollViewOriginalInset = UIEdgeInsetsMake(
            originalInset.top - WKAppearance.refreshHeaderHeight,
            originalInset.left, originalInset.bottom, originalInset.right)
    }
}

// MARK: - 提供给子类覆盖的方法[纯虚方法😊]
extension WKRefreshControl{
    
    internal func placeSubViews() -> (Void) {}
    internal func scrollViewContentOffsetDidChanged(change:Dictionary<String, AnyObject>?) -> (Void){}
    public func completeRefresh() -> (Void){}
    public func beginRefresh() -> (Void) {}
}
