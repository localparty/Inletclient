//
//  MirroringDatasource.swift
//  Inletclient_Example
//
//  Created by Gee C on 1/9/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

open class MirroringTableViewController: ProxyTableViewController {
    
    public func mirror(_ subject: Any, usingDelegate: MirrorControllerDelegate) {
        
        self.proxyDataSource =
            MirroringTableViewDataSource(
                subject: subject)
        
        self.proxyDelegate =
            MirroringTableViewDelegate(
                subject: subject,
                mirrorControllerDelegate: usingDelegate)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
}

open class ProxyTableViewController: UITableViewController {
    
    public var proxyDataSource: UITableViewDataSource?
    public var proxyDelegate: UITableViewDelegate?
    
    open override func numberOfSections(in tableView: UITableView) -> Int {
        return proxyDataSource!.numberOfSections!(in: tableView)
    }
    
    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return proxyDataSource!.tableView(tableView, numberOfRowsInSection: section)
    }
    
    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return proxyDataSource!.tableView(tableView, cellForRowAt: indexPath)
    }
    
    open override func tableView(_ tableView: UITableView, didSelectRowAt: IndexPath) {
        return proxyDelegate!.tableView!(tableView, didSelectRowAt: didSelectRowAt)
    }
    
}

public typealias MirrorChildrenMap = [(label: String?, type: Any.Type, value: Any)]

public func reflectSubjectAsMap(_ subject: Any) -> MirrorChildrenMap {
    let mirror = Mirror(reflecting: subject)
    return mirror.children.map({(label, value) in
        let result = (label, type(of: value), value)
        return result
    })
}

func shouldDetailType(member: Any.Type) -> Bool {
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

func unwrapOptionalThereof(any:Any) -> Any {
    
    let mi = Mirror(reflecting: any)
    
    if mi.displayStyle != .optional {
        return any
    }
    
    if mi.children.count == 0 { return NSNull() }
    let (_, some) = mi.children.first!
    return some
    
}

public protocol MirrorControllerDelegate {
    func instanciateProxyViewController() -> ProxyTableViewController
    func sourceController() -> UIViewController
}

public class MirroringTableViewDelegate: NSObject, UITableViewDelegate {
    
    let childrenMap: MirrorChildrenMap
    let mirrorControllerDelegate: MirrorControllerDelegate
    
    init(subject: Any, mirrorControllerDelegate: MirrorControllerDelegate) {
        self.childrenMap = reflectSubjectAsMap(subject)
        self.mirrorControllerDelegate = mirrorControllerDelegate
    }
    
    public func tableView(_: UITableView, didSelectRowAt: IndexPath) {
        let row = didSelectRowAt.row
        let child = childrenMap[row]
        let childValue = child.value
        let childType = type(of: childValue)
        let unwrappedChildValue = unwrapOptionalThereof(any: childValue)
        
        if shouldDetailType(member: childType) {
            
            let newViewController = mirrorControllerDelegate.instanciateProxyViewController()
            let sourceController = mirrorControllerDelegate.sourceController()
            
            newViewController.proxyDataSource =
                MirroringTableViewDataSource(
                    subject: unwrappedChildValue)
            
            newViewController.proxyDelegate =
                MirroringTableViewDelegate(
                    subject: unwrappedChildValue,
                    mirrorControllerDelegate: self.mirrorControllerDelegate)
            
            DispatchQueue.main.async {
                sourceController.show(newViewController, sender: nil)
            }
        }
    }
}

public class MirroringTableViewDataSource: NSObject, UITableViewDataSource {
    
    let childrenMap: MirrorChildrenMap
    
    init(subject: Any) {
        self.childrenMap = reflectSubjectAsMap(subject)
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
            let unwrappedChildValue = unwrapOptionalThereof(any: childValue)
            cell.detailTextLabel?.text = String(describing: unwrappedChildValue)
        }
        
        return cell
    }
}
