//
//  ViewController.swift
//  InletClient3
//
//  Created by Donkey Donks on 12/4/18.
//  Copyright © 2018 Wells Fargo. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift
import RxCocoa

public enum API {
    
    public static func getDiscoveryConsents() -> Endpoint<DiscoveryConsents> {
        return Endpoint(
            path: "api/access/v1/discovery/consent",
            localResource: "discovery-consent",
            localResourceType: "json"
        )
    }
    
    public static func getBrandProfile(brandId: String) -> Endpoint<[BrandProfile]> {
        let parameters: [String: Any] = [
            "assetBinaryData": true
        ]
        return Endpoint(
            path: "api/access/v1/brand/\(brandId)",
            parameters: parameters,
            localResource: "brand",
            localResourceType: "json"
        )
    }
    
    public static func putDiscoveryProfile(
        discoveryConsents: DiscoveryConsents,
        clientParameters: ClientParameters
        ) -> Endpoint<DiscoveryProfile> {
        
        let consentId = discoveryConsents.consents![0].consentId!
        
        let channelId = clientParameters.partnerChannelId
        let channelSpecificConsumerId = clientParameters.inletCustomer.cID
        
        /*  below, aliasing the 'sourceCID' from the data documentation
            as 'channelSpecificConsumerId' to reflect the name used in the
            API PDF documentation
         */
        let endpointPath = "api/access/v1/discovery/channel/\(channelId)/channelconsumer/\(channelSpecificConsumerId)"
        var channelConsumerDeliveryPoints: [[String : [String : [[String : Any]]]]] = []
        if let phoneNumber = clientParameters.inletCustomer.phoneNumber {
            channelConsumerDeliveryPoints.append([
                "phoneDeliveryPointType": [
                    "userFields": [
                        ["countryCode": String(phoneNumber.countryCode)],
                        ["phone": String(phoneNumber.number)]
                    ]
                ]
            ])
        }
        
        if let email = clientParameters.inletCustomer.email {
            channelConsumerDeliveryPoints.append([
                "emailDeliveryPointType": [
                    "userFields": [
                        ["email": String(email)]
                    ]
                ]
            ])
        }
        
        if let zip = clientParameters.inletCustomer.zip {
            channelConsumerDeliveryPoints.append([
                "zipDeliveryPointType": [
                    "userFields": [
                        ["zipCode": String(zip)]
                    ]
                ]
            ])
        }
        
        if let structuredName = clientParameters.inletCustomer.structuredName {
            channelConsumerDeliveryPoints.append([
                "structuredNameDeliveryPointType": [
                    "userFields": [
                        ["salutation": String(structuredName.salutation)],
                        ["firstName": String(structuredName.firstName)],
                        ["middleName": String(structuredName.middleName)],
                        ["lastName": String(structuredName.lastName)],
                        ["suffix": String(structuredName.suffix)],
                    ]
                ]
            ])
        }
        
        if let brandId = clientParameters.inletCustomer.brandId {
            channelConsumerDeliveryPoints.append([
                "brandIdDeliveryPointType": [
                    "userFields": [
                        ["accountNum": String(brandId)]
                    ]
                ]
            ])
        }
        
        let parameters: [String: Any] = [
            "consentId": consentId,
            "channelConsumerDeliveryPoints": channelConsumerDeliveryPoints
        ]
        
        return Endpoint(
            method: .put,
            path: endpointPath,
            parameters: parameters,
            localResource: "discovery-profile",
            localResourceType: "json"
        )
    }
    
    public static func getMailbox(discoveryProfile: DiscoveryProfile) -> Endpoint<Mailbox> {
        let ccId = discoveryProfile.ccId!
        return Endpoint(path: "api/access/v1/ccid/\(ccId)/mailbox",
            localResource: "mailbox",
            localResourceType: "json")
    }
    
    public static func getEnvelope(envelopeId: String) -> Endpoint<Envelope> {
        return Endpoint(path: "api/access/v1/envelope/\(envelopeId)")
    }
}

public class EndpointConfiguration {
    static let defaultHeaders: Headers = [
        "Content-Type": "application/json",
        "cache-control": "no-cache"
    ]
    static let timeoutInterval:TimeInterval = 220
}

public typealias Headers = [String: String]
public typealias Parameters = [String: Any]
public typealias Path = String

public enum Method {
    case get, post, put, patch, delete
}
