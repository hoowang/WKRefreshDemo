//
//  WKPureHeaderExampleController.swift
//  WKRefreshDemo
//
//  Created by hooge on 16/5/6.
//  Copyright © 2016年 hooge. All rights reserved.
//

import UIKit

class WKPureHeaderExampleController: UITableViewController {
    var refreshHeader: WKRefreshControl?
    var refreshFooter:WKRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.refreshHeader = WKPureRefreshHeader.refreshHeaderFor(self.tableView, callback: {
            [unowned self]() -> (Void) in
            dispatch_after(dispatch_time(0, 1000 * 1000 * 1000 ), dispatch_get_main_queue(), {
                [unowned self] in
                 self.refreshHeader?.completeRefresh()
            })
        })
        
         self.refreshHeader?.beginRefresh()
        
        // self.refreshHeader?.backgroundColor = UIColor.blueColor()
        
        self.refreshFooter = WKRichRefreshFooter.refreshFooterFor(self.tableView, callback: { () -> (Void) in
            dispatch_after(dispatch_time(0, 1000 * 1000 * 1000 ), dispatch_get_main_queue(), {
                [unowned self] in
                self.refreshFooter.completeRefresh()
            })
        })
        
    // self.automaticallyAdjustsScrollViewInsets = true
        
        self.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "reuseIdentifier")
    }
    
    deinit{
        print("WKPureHeaderExampleController 释放")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 100
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // cell.backgroundColor = UIColor.cyanColor()

        return cell
    }
    


}
