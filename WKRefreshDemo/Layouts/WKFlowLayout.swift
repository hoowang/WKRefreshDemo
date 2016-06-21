//
//  WKFlowLayout.swift
//  WKRefreshDemo
//
//  Created by 王虎 on 16/4/27.
//  Copyright © 2016年 hooge. All rights reserved.
//

import UIKit

class WKFlowLayout: UICollectionViewFlowLayout {
    override init(){
        super.init()
        self.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width - 20, 70)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width - 20, 70)
    }
    
    
}
