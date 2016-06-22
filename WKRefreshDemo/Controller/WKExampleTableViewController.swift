//
//  WKExampleTableViewController.swift
//  WKRefreshDemo
//
//  Created by hooge on 16/5/5.
//  Copyright © 2016年 hooge. All rights reserved.
//

import UIKit

class WKExampleTableViewController: UITableViewController {

    var refreshHeader:WKRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()

       self.refreshHeader = WKRichRefreshHeader.refreshHeaderFor(
            self.tableView, target:self, action:#selector(WKExampleTableViewController.refreshCallback))
        self.refreshHeader!.beginRefresh()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func refreshCallback() -> (Void) {
        dispatch_after(dispatch_time(0, 1000 * 1000 * 1000), dispatch_get_main_queue(), {
                [unowned self] in
                self.refreshHeader?.completeRefresh()
            })
    }
    
    deinit{
        self.refreshHeader = nil
        print("WKExampleTableViewController被释放")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
}
