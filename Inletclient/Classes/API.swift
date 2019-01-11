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
    
    public static func putDiscoveryProfile(
        channelId: String,
        channelSpecificConsumerId: String, consentId: String?,
        zip: String?, phoneCountryCode: String?, phone: String?,
        email:String?) -> Endpoint<DiscoveryProfile> {
        let endpointPath = "api/access/v1/discovery/channel/\(channelId)/channelconsumer/\(channelSpecificConsumerId)"
        
        let parameters = [
            "consentId": consentId,
            "channelConsumerDeliveryPoints": [["zipDeliveryPointType": ["userFields": [["zipCode": zip]]]], ["phoneDeliveryPointType": ["userFields": [["countryCode": phoneCountryCode], ["phone": phone]]]], ["emailDeliveryPointType": ["userFields": [["email": email]]]]]
            ] as [String : Any]
        
        return Endpoint(
            method: .put,
            path: endpointPath,
            parameters: parameters,
            localResource: "discovery-profile",
            localResourceType: "json"
        )
    }
    
    public static func getBrandProfile(brandId: String) -> Endpoint<[BrandProfile]> {
        return Endpoint(
            path: "api/access/v1/brand/\(brandId)",
            localResource: "brand",
            localResourceType: "json"
        )
    }
    
    public static func getEnvelope(envelopeId: String) -> Endpoint<Envelope> {
        return Endpoint(path: "api/access/v1/envelope/\(envelopeId)")
    }
    
    public static func putDiscoveryProfile2(
        discoveryConsents: DiscoveryConsents,
        userAttributes: [UserAttribute: String]
        ) -> Endpoint<DiscoveryProfile> {
        
        let consentId = discoveryConsents.consents![0].consentId!
        
        let channelId: String = userAttributes[.channelId]!
        let channelSpecificConsumerId: String = userAttributes[.inletConsumerId]!
        let zip: String? = userAttributes[.zip]
        let phoneCountryCode: String? = userAttributes[.phoneCountryCode]
        let phone: String? = userAttributes[.phoneNumber]
        let email: String? = userAttributes[.email]
        
        let endpointPath = "api/access/v1/discovery/channel/\(channelId)/channelconsumer/\(channelSpecificConsumerId)"
        
        let parameters = [
            "consentId": consentId,
            "channelConsumerDeliveryPoints": [["zipDeliveryPointType": ["userFields": [["zipCode": zip]]]], ["phoneDeliveryPointType": ["userFields": [["countryCode": phoneCountryCode], ["phone": phone]]]], ["emailDeliveryPointType": ["userFields": [["email": email]]]]]
            ] as [String : Any]
        
        return Endpoint(
            method: .put,
            path: endpointPath,
            parameters: parameters,
            localResource: "discovery-profile",
            localResourceType: "json"
        )
    }
    
    public static func getMailbox(ccId: String) -> Endpoint<Mailbox> {
        return Endpoint(
            path: "api/access/v1/ccid/\(ccId)/mailbox",
            localResource: "mailbox",
            localResourceType: "json")
    }
    
    public static func getMailbox2(discoveryProfile: DiscoveryProfile) -> Endpoint<Mailbox> {
        let ccId = discoveryProfile.ccId!
        return Endpoint(path: "api/access/v1/ccid/\(ccId)/mailbox",
            localResource: "mailbox",
            localResourceType: "json")
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
