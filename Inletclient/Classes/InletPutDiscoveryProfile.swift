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

extension API {
    public static func putDiscoveryProfile(
        channelSpecificConsumerId: String, consentId: String?,
        zip: String?, phoneCountryCode: String?, phone: String?,
        email:String?) -> Endpoint<DiscoveryProfile> {
        let channelId: String = API.channelId()
        let endpointPath = "api/access/v1/discovery/channel/\(channelId)/channelconsumer/\(channelSpecificConsumerId)"
        
        let parameters = [
            "consentId": consentId,
            "channelConsumerDeliveryPoints": [["zipDeliveryPointType": ["userFields": [["zipCode": zip]]]], ["phoneDeliveryPointType": ["userFields": [["countryCode": phoneCountryCode], ["phone": phone]]]], ["emailDeliveryPointType": ["userFields": [["email": email]]]]]
            ] as [String : Any]
        
        return Endpoint(
            method: .put,
            path: endpointPath,
            parameters: parameters
        )
    }
}


