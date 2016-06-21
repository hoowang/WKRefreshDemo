//
//  WKRefreshFunctions.swift
//  WKRefreshDemo
//
//  Created by 王虎 on 16/6/21.
//  Copyright © 2016年 hooge. All rights reserved.
//

import UIKit

func wkLog<T>(message: T,
              file: String = #file,
              method: String = #function,
              line: Int = #line)
{
    #if DEBUG
        print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #endif
}