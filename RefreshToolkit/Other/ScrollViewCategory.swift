//
//  ScrollViewCategory.swift
//  WKRefreshDemo
//
//  Created by 王虎 on 16/4/28.
//  Copyright © 2016年 hooge. All rights reserved.
//

import UIKit

public extension UIScrollView{
    var wk_InsetTop: CGFloat {
        set {
            var insets: UIEdgeInsets = self.contentInset
            insets.top = newValue
            self.contentInset = insets
        }
        get {
            return self.contentInset.top
        }
    }
    
    var wk_InsetBottom: CGFloat {
        set {
            var insets: UIEdgeInsets = self.contentInset
            insets.bottom = newValue
            self.contentInset = insets
        }
        get {
            return self.contentInset.top
        }
    }
    
    var wk_OffsetY: CGFloat {
        set {
            var offset: CGPoint = self.contentOffset
            offset.y = newValue
            self.contentOffset = offset
        }
        get {
            return self.contentOffset.y
        }
    }
    
}