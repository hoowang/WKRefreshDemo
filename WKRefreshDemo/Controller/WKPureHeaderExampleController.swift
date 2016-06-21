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
        
        self.refreshFooter = WKRichRefreshFooter.refreshFooterFor(self.tableView, callback: { () -> (Void) in
            dispatch_after(dispatch_time(0, 1000 * 1000 * 1000 ), dispatch_get_main_queue(), {
                [unowned self] in
                self.refreshFooter.completeRefresh()
            })
        })
        
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

        cell.backgroundColor = UIColor.cyanColor()

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
