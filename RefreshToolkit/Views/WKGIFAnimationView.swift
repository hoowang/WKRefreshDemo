//
//  WKGIFAnimationView.swift
//  WKRefreshDemo
//
//  Created by 王虎 on 16/5/3.
//  Copyright © 2016年 hooge. All rights reserved.
//

import UIKit

class WKGIFAnimationView: WKAnimationView {
    
    let animationView = UIImageView()
    lazy var animationImagesNormal:[UIImage] = {
        var images = [UIImage]()
        for index in 1...60{
            let name = String.init(format: "dropdown_anim__000%d", arguments: [index])
            let image = UIImage(named:name)
            images.append(image!)
        }
        return images
    }()
    
    lazy var animationImagesWillRefresh:[UIImage] = {
        var images = [UIImage]()
        for index in 1...3{
            let name = String.init(format: "dropdown_loading_0%d", arguments: [index])
          
            let image = UIImage(named:name)
            images.append(image!)
        }
        return images
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.animationView.frame = self.bounds
    }
    
    private func initialize() -> (Void){
        self.addSubview(self.animationView)
        self.animationView.frame = self.bounds
    }
    
    override func changeState(state: AnimationState) {
        super.changeState(state)
        if state == self.lastAnimationState {
            return
        }
        self.lastAnimationState = state
        switch state {
        case .Normal:
            self.stopAnimation()
            self.animationView.animationImages = self.animationImagesNormal
            self.animationView.animationDuration = NSTimeInterval(self.animationImagesNormal.count) * 0.1
            self.startAnimation()
            break
        case .WillRefresh:
            self.stopAnimation()
            self.animationView.animationImages = self.animationImagesNormal
            self.animationView.animationDuration = NSTimeInterval(self.animationImagesNormal.count) * 0.1
            self.startAnimation()
            break
        case .StartRefresh:
            self.stopAnimation()
            self.animationView.animationImages = self.animationImagesWillRefresh
            self.animationView.animationDuration = NSTimeInterval(self.animationImagesWillRefresh.count) * 0.1
            self.startAnimation()
            break
        default:
            break
        }
    }
    
    override func startAnimation() {
        super.startAnimation()
        self.animationView.startAnimating()
    }
    
    override func stopAnimation() {
        super.stopAnimation()
        self.animationView.stopAnimating()
    }
    
    override func AnimationViewSize() -> (CGSize) {
        return CGSizeMake(50, 50)
    }
}



