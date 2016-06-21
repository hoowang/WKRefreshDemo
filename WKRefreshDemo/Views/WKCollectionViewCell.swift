//
//  WKCollectionViewCell.swift
//  WKRefreshDemo
//
//  Created by hooge on 16/4/27.
//  Copyright © 2016年 hooge. All rights reserved.
//

import UIKit

class WKCollectionViewCell: UICollectionViewCell {
    
    class func cellIdentify() -> (String){
        return "WKCollectionViewCell"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.orangeColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
