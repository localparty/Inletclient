//
//  DatasourceController.swift
//  Inletclient Example
//
//  Created by Donkey Donks on 1/2/19.
//  Copyright © 2019 Wells Fargo. All rights reserved.
//

import UIKit
import Inletclient

class EnvelopeController {
    
    let userNameValue = "$2a$06$YKYwyV3lwnQ.mFNm97XtgOie.oTAOnsh0VQh1UHQ9jbLgyrNfY/1C"
    let passwordValue = "$2a$06$H7RhnGbrHg17E4siBcilwuJTwgyRiYQZAC6GPO0lITc/t/r24ORAC"
    let restClient: RESTClient
    
    var datasource: UITableViewDataSource? = MemoDatasource(
        reusableCellIdentifier: "default",
        text: "loading envelope now...",
        detail: "Inlet REST API")
    
    init() {
        restClient = RESTClient(username: userNameValue, password: passwordValue)
    }
    
    var datasourceDelegate: DatasourceDelegate? = nil
    
    func getEnvelope(
        withEnvelopeId: String,
        andThen onDataReady: ((Envelope)->Void)? = nil,
        orElse: ((Error)->Void)? = nil){
        _ = restClient
            .request(API.getEnvelope(envelopeId: withEnvelopeId))
            .asObservable()
            .subscribe(onNext: onDataReady, onError: orElse)
    }
    
}

public enum ReuseIndentifier: String {
    case `default` = "default"
    case hyperTable = "hyper table"
    case tableController = "table controller"
}

public enum UIStoryboardName: String {
    case main = "Main"
}

public enum ControllerStoryboardIdentifier: String {
    case tableController = "table controller"
}

extension UITableView {
    public func dequeueReusableCell(withReuseIdentifier: ReuseIndentifier, cellForRowAt indexPath: IndexPath)  -> UITableViewCell {
        return self.dequeueReusableCell(withIdentifier: withReuseIdentifier.rawValue, for: indexPath)
    }
}

extension UIStoryboard {
    public convenience init (uiStoryboardName: UIStoryboardName, bundle: Bundle? = nil) {
        self.init(name: uiStoryboardName.rawValue, bundle: bundle)
    }
    public func instantiateViewController(withControlerStoryboardIdentifier: ControllerStoryboardIdentifier) -> UIViewController{
        return instantiateViewController(withIdentifier: withControlerStoryboardIdentifier.rawValue);
    }
}

extension Envelope {
    func getValueOfProperty(name:String)->String? {
        let type: Mirror = Mirror(reflecting:self)
        
        for child in type.children {
            if child.label! == name {
                let value:String = String(describing: child.value)
                return value
            }
        }
        return nil
    }
    //returns the property type
    func getTypeOfProperty(name:String)->Any.Type? {
        let mirror: Mirror = Mirror(reflecting:self)
        
        for child in mirror.children {
            print("child– \(String(describing: child))")
        }
        
        for child in mirror.children {
            if child.label! == name{
                let childType = type(of: child.value)
                //let type: String = String(describing: child.value.self)
                return childType
            }
        }
        return nil
    }
}

extension Envelope {
    public func asUITableViewHelper (reusableCellIdentifier: String) -> UITableViewHelper {
        
        class EnvelopeUITableViewHelperImpl: NSObject, UITableViewHelper {
            
            public let envelope: Envelope
            public let reusableCellIdentifier: String
            
            init(envelope: Envelope, reusableCellIdentifier: String) {
                self.envelope = envelope
                self.reusableCellIdentifier = reusableCellIdentifier
            }
            
            public func numberOfSections(in tableView: UITableView) -> Int {
                return 1
            }
            
            public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return Envelope.CodingKeys.allCases.count
            }
            
            public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let codingKey:Envelope.CodingKeys = Envelope.CodingKeys.allCases[indexPath.row]
                let codingKeyname: String = codingKey.rawValue
                
                let cell: UITableViewCell = tableView.dequeueReusableCell(
                    withIdentifier: self.reusableCellIdentifier,
                    for: indexPath)
                cell.textLabel?.text = codingKeyname
                cell.detailTextLabel?.text = envelope.getValueOfProperty(name: codingKeyname)
                
                return cell
            }
            
        }
        let uiTableViewHelper: EnvelopeUITableViewHelperImpl = EnvelopeUITableViewHelperImpl(envelope: self, reusableCellIdentifier: reusableCellIdentifier)
        
        return uiTableViewHelper
    }
}

