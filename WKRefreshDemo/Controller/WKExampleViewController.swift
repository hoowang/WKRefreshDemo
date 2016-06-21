//
//  WKExampleViewController.swift
//  WKRefreshDemo
//
//  Created by hooge on 16/5/5.
//  Copyright © 2016年 hooge. All rights reserved.
//

import UIKit

class WKExampleViewController: UITableViewController {

    let exampleCount = 10
    let cellIdentify = "WKExampleCellID"
    let titles = ["WKRichRefreshHeader ---下拉刷新", "TableView ---上拉刷新",
                  "WKPureRefreshHeader ---下拉刷新","collectionView ---上拉刷新"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: cellIdentify)
    }

}

extension WKExampleViewController{
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentify)
        cell?.textLabel?.text = self.titles[indexPath.row]
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            self.navigationController?.pushViewController(WKExampleTableViewController(), animated: true)
            break
        case 1:
            break
        case 2:
            self.navigationController?.pushViewController(WKPureHeaderExampleController(), animated: true)
            break
        case 3:
            break
        default:
            break
        }
    }
}
