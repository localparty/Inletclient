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
    
    var datasource: UITableViewDataSource? = MemoDataSource(
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

enum PropertyTypes:String
{
    case OptionalInt = "Optional<Int>"
    case Int = "Int"
    case OptionalString = "Optional<String>"
    case String = "String"
    //...
}

extension Envelope {
    func getValueOfProperty(name:String)->String? {
        let type: Mirror = Mirror(reflecting:self)
        
        for child in type.children {
            if child.label! == name {
                return String(describing: child.value)
            }
        }
        return nil
    }
    //returns the property type
    func getTypeOfProperty(name:String)->String? {
        let type: Mirror = Mirror(reflecting:self)
        
        for child in type.children {
            if child.label! == name{
                return String(describing: child.value.self)
            }
        }
        return nil
    }
    
    //Property Type Comparison
    func propertyIsOfType(propertyName:String, type:PropertyTypes)->Bool {
        if getTypeOfProperty(name: propertyName) == type.rawValue {
            return true
        }
        
        return false
    }
}

public protocol EnvelopeDataSource {
    func getReusableCellIdentifier(forTypeName: String) -> String
}

extension Envelope {
    public func asUITableViewDataSource (datasourceDelegate: EnvelopeDataSource) -> UITableViewDataSource {
        
        class EnvelopeUITableViewDataSource: NSObject, UITableViewDataSource {
            
            public let envelope: Envelope
            public let datasourceDelegate: EnvelopeDataSource
            
            init(envelope: Envelope, datasourceDelegate: EnvelopeDataSource) {
                self.envelope = envelope
                self.datasourceDelegate = datasourceDelegate
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
                    withIdentifier: self.datasourceDelegate.getReusableCellIdentifier(forTypeName: codingKeyname),
                    for: indexPath)
                
                if cell is UITableViewCell {
                    cell.textLabel?.text = codingKeyname
                    cell.detailTextLabel?.text = envelope.getValueOfProperty(name: codingKeyname)
                }
                
                return cell
            }
        }
        let uiTableViewDataSource: UITableViewDataSource = EnvelopeUITableViewDataSource(envelope: self, datasourceDelegate: datasourceDelegate)
        
        return uiTableViewDataSource
    }
}

