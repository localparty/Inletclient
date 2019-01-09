//
//  MirroringDatasourceTableViewController.swift
//  Inletclient_Example
//
//  Created by Gee C on 1/9/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import Inletclient

public class TableViewHelperController: UITableViewController {
    
    public var tableViewHelper: UITableViewHelper?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }

    public override func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewHelper!.numberOfSections!(in: tableView)
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewHelper!.tableView(tableView, numberOfRowsInSection: section)
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableViewHelper!.tableView(tableView, cellForRowAt: indexPath)
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt: IndexPath) {
        return tableViewHelper!.tableView!(tableView, didSelectRowAt: didSelectRowAt)
    }

}
