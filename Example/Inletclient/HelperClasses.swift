//
//  MirroringDatasource.swift
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

public class MirroringDatasource: NSObject, UITableViewHelper {
    
    let reflectionOf: Any
    let mirror: Mirror
    let showingController: UIViewController
    let childrenMap: [(label: String?, type: Any.Type, value: Any)]
    
    init(reflectionOf: Any, showingController: UIViewController) {
        self.reflectionOf = reflectionOf
        self.showingController = showingController
        mirror = Mirror(reflecting: self.reflectionOf)
        childrenMap = mirror.children.map({(label, value) in
            let result = (label, type(of: value), value)
            return result
        })
    }
    private func unwrap(any:Any) -> Any {
        
        let mi = Mirror(reflecting: any)
        
        if mi.displayStyle != .optional {
            return any
        }
        
        if mi.children.count == 0 { return NSNull() }
        let (_, some) = mi.children.first!
        return some
        
    }
    
    private func shouldDetailType(member: Any.Type) -> Bool {
        if member is String.Type {
            return false
        }
        if member is String?.Type {
            return false
        }
        if member is Int.Type {
            return false
        }
        if member is Int?.Type {
            return false
        }
        return true
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return childrenMap.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let child = childrenMap[row]
        let childLabel = child.label
        let childValue = child.value
        let childType = child.type
        let cell: UITableViewCell = tableView.dequeueReusableCell(
            withIdentifier: "default",
            for: indexPath)
        
        cell.textLabel?.text = childLabel
        if (shouldDetailType(member: childType)) {
            cell.detailTextLabel?.text = "––>"
        } else {
            let unwrappedChildValue = unwrap(any: childValue)
            cell.detailTextLabel?.text = String(describing: unwrappedChildValue)
        }
        
        return cell
    }
    
    public func tableView(_: UITableView, didSelectRowAt: IndexPath) {
        let row = didSelectRowAt.row
        let child = childrenMap[row]
        let childValue = child.value
        let childType = type(of: childValue)
        let unwrappedChildValue = unwrap(any: childValue)
        
        if shouldDetailType(member: childType) {
            let storyboard: UIStoryboard = UIStoryboard(uiStoryboardName: .main)
            let newViewController: UIViewController = storyboard.instantiateViewController(withControlerStoryboardIdentifier: .tableController)
            if let newViewController = newViewController as? TableViewHelperController {
                newViewController.tableViewHelper = MirroringDatasource(reflectionOf: unwrappedChildValue, showingController: self.showingController)
                DispatchQueue.main.async {
                    self.showingController.show(newViewController, sender: nil)
                }
            }
        }
    }
}

public protocol UITableViewHelper: UITableViewDataSource, UITableViewDelegate {}

public class TextDetailDatasource: NSObject, UITableViewHelper {
    
    public let reusableCellIdentifier: String
    public let text: String
    public let detail: String
    
    public init(
        reusableCellIdentifier: String,
        text: String,
        detail: String){
        self.reusableCellIdentifier = reusableCellIdentifier
        self.text = text
        self.detail = detail
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: reusableCellIdentifier,
                for: indexPath)
        
        cell.textLabel?.text = text
        cell.detailTextLabel?.text = detail
        
        return cell
    }
    
}
