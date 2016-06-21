//
//  WKArrowActivityAnimationView.swift
//  WKRefreshDemo
//
//  Created by hooge on 16/5/3.
//  Copyright © 2016年 hooge. All rights reserved.
//

import UIKit

public enum ArrowDirection {
    case South
    case North
}

public class WKArrowActivityAnimationView: WKAnimationView {
    private let activityView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    private let arrowImageView = UIImageView()
    private var arrowTransform:CGAffineTransform = CGAffineTransformMakeRotation(0.000001 - CGFloat(M_PI))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.arrowImageView.frame = self.bounds
        let activityX = (self.wk_Width - 15.0) * 0.5
        let activityY = (self.wk_Height - 15.0) * 0.5
        self.activityView.frame = CGRectMake(activityX, activityY, 15, 15)
    }
    
    private func initialize() -> (Void){
        self.addSubview(self.activityView)
        self.addSubview(self.arrowImageView)
        self.arrowImageView.image = UIImage(named: "arrow")
    }

    public override func startAnimation() ->(Void) {
        self.activityView.startAnimating()
    }
    
    public override func stopAnimation() ->(Void) {
        self.activityView.stopAnimating()
    }
    
    // 这个方法也许是个设计缺陷 专为上拉刷新调用 代码有些匪夷所思 不想搞太多的类 所以取巧了一下
    public override func changeArrowDirection(direction:ArrowDirection) -> (Void){
        switch direction {
        case .South:
            self.arrowImageView.transform = CGAffineTransformMakeRotation(0.000001 - CGFloat(M_PI))
            self.arrowTransform = CGAffineTransformIdentity
            break
        case .North:
            self.arrowTransform = CGAffineTransformMakeRotation(0.000001 - CGFloat(M_PI))
            break
        }
    }
    
    public override func changeState(state:AnimationState) ->(Void){
        if self.lastAnimationState == state {
            return
        }
        self.lastAnimationState = state
        switch state {
        case .Normal:
            self.arrowImageView.hidden = false
            self.stopAnimation()
            break
        case .WillRefresh:
            UIView.animateWithDuration(WKAppearance.animationDuration, animations: { 
                [unowned self ] in
                self.arrowImageView.transform = self.arrowTransform
            })
            break
        case .StartRefresh:
            self.arrowImageView.hidden = true
            self.arrowImageView.transform = CGAffineTransformIdentity
            self.startAnimation()
            break
        default:
            break
        }
    }
    
    public override func AnimationViewSize() -> (CGSize) {
        return CGSizeMake(15, 40)
    }
}
