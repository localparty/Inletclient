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
import Inletclient


public enum API {
    
    public static func getDiscoveryConsents() -> Endpoint<DiscoveryConsents> {
        return Endpoint(
            path: "api/access/v1/discovery/consent",
            localResource: "discovery-consent",
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
    
    public static func putDiscoveryProfile(
        discoveryConsents: DiscoveryConsents,
        clientParameters: ClientParameters
        ) -> Endpoint<DiscoveryProfile> {
        
        let consentId = discoveryConsents.consents![0].consentId!
        
        let channelId = clientParameters.partnerChannelId
        let channelSpecificConsumerId = clientParameters.inletCustomer.ids.sourceCID
        let zip: Int? = clientParameters.inletCustomer.brandConnectionParameters.zip
        let phoneCountryCode: Int? = clientParameters.inletCustomer.brandConnectionParameters.phoneNumber?.countryCode
        let phone: Int64? = clientParameters.inletCustomer.brandConnectionParameters.phoneNumber?.number
        let email: String? = clientParameters.inletCustomer.brandConnectionParameters.email
        
        /*  below, aliasing the 'sourceCID' from the data documentation
            as 'channelSpecificConsumerId' to reflect the name used in the
            API PDF documentation
         */
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
