//
//  WKAnimationView.swift
//  WKRefreshDemo
//
//  Created by 王虎 on 16/5/3.
//  Copyright © 2016年 hooge. All rights reserved.
//

import UIKit

public enum AnimationState {
    case Normal
    case WillRefresh
    case StartRefresh
    case None
}

public class WKAnimationView: UIView {
    var lastAnimationState = AnimationState.None
    public func AnimationViewSize() -> (CGSize){return CGSizeMake(10, 10)}
    public func startAnimation() ->(Void) {}
    public func stopAnimation() ->(Void) {}
    public func changeState(state:AnimationState) ->(Void){}
    public func changeArrowDirection(direction:ArrowDirection) -> (Void){}
}
