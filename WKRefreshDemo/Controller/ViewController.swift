//
//  ViewController.swift
//  WKRefreshDemo
//
//  Created by hooge on 16/4/26.
//  Copyright © 2016年 hooge. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {

    private var refreshHeader: WKRefreshControl?
    private var refreshFooter:WKRefreshControl?
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: WKFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        
        // 闭包形式
        //        self.refreshHeader = WKPureRefreshHeader.refreshHeaderFor(self.collectionView!, callback: { () -> (Void) in
        //        dispatch_after(dispatch_time(0, 1000 * 1000 * 1000), dispatch_get_main_queue(), {
        //                [unowned self] in
        //                self.refreshHeader!.completeRefresh()
        //         })
        //        })
        
        // 方法形式
        self.refreshHeader = WKPureRefreshHeader.refreshHeaderFor(
            self.collectionView!, target: self, action: #selector(ViewController.completeRefreshHandler))

//        self.refreshHeader = WKRichRefreshHeader.refreshHeaderFor(
//            self.collectionView!, target: self, action: #selector(ViewController.completeRefreshHandler))

        
//        self.refreshHeader = WKGIFRefreshHeader.refreshHeaderFor(
//            self.collectionView!, target: self, action: #selector(ViewController.completeRefreshHandler))
//        
//        (self.refreshHeader as! WKGIFRefreshHeader).hideTextLabel()
//        
//        self.refreshFooter = WKRichRefreshFooter.refreshFooterFor(
//            self.collectionView!, callback: {[unowned self] () -> (Void) in
//            dispatch_after(dispatch_time(0, 1000 * 1000 * 1000), dispatch_get_main_queue(), {
//                [unowned self] in
//                self.refreshFooter!.completeRefresh()
//            })
//        })
        
//        self.refreshFooter = WKPureRefreshFooter.refreshFooterFor(
//            self.collectionView!, callback: {[unowned self] () -> (Void) in
//            dispatch_after(dispatch_time(0, 1000 * 1000 * 1000), dispatch_get_main_queue(), {
//                [unowned self] in
//                self.refreshFooter!.completeRefresh()
//            })
//        })
        
        self.refreshFooter = WKGIFRefreshFooter.refreshFooterFor(
            self.collectionView!, callback: {[unowned self] () -> (Void) in
                dispatch_after(dispatch_time(0, 1000 * 1000 * 1000), dispatch_get_main_queue(), {
                    [unowned self] in
                    self.refreshFooter!.completeRefresh()
                    })
        })
        
        (self.refreshFooter as! WKGIFRefreshFooter).hideTextLabel()
        
        //self.refreshFooter?.backgroundColor = UIColor.greenColor()
        
        self.collectionView?.registerClass(
            WKCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: WKCollectionViewCell.cellIdentify())
    }
    
    internal func completeRefreshHandler() -> (Void){
        
        dispatch_after(dispatch_time(0, 1000 * 1000 * 1000), dispatch_get_main_queue(), {
                [unowned self] in
                self.refreshHeader!.completeRefresh()
         })
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(
        collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier(WKCollectionViewCell.cellIdentify(), forIndexPath: indexPath)
    }
    
}

