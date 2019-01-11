//
//  DatasourceController.swift
//  Inletclient Example
//
//  Created by Donkey Donks on 1/2/19.
//  Copyright © 2019 Wells Fargo. All rights reserved.
//

import UIKit
import Inletclient
import RxSwift
import RxCocoa

public class InletController2 {
    
    var datasource: UITableViewDataSource? = TextDetailDatasource(
        reusableCellIdentifier: "default",
        text: "loading data now...",
        detail: "Inlet REST API"
    )
    
    public typealias BrandProfilesSingle = Single<(discoveryConsents: DiscoveryConsents, discoveryProfile: DiscoveryProfile, mailbox: Mailbox, brandProfiles: [(ResultMatch, BrandProfile)])>
    
    public func getLocalData() -> BrandProfilesSingle {
        
        enum PayWithWfUser: String {
            case bill
            case chris
            case jason
            case g
        }
        
        let channelId: String = "CP:0000000149"
        let envelopeId: String = "EV:10000271587"
        let minConfidenceLevel: String = "19"
        
        let users: [PayWithWfUser: [UserAttribute: String]] = [
            .bill: [
                .channelId: channelId,
                .termsConsent: "false",
                .inletConsumerId: "WFTEST111918A",
                .phoneNumber: "451-555-1111",
                .phoneCountryCode: "1",
                .zip: "94016",
                .email: "wfuser1@email.com",
                .envelopeId: envelopeId,
                .minConfidenceLevel: minConfidenceLevel
            ],
            .chris: [
                .channelId: channelId,
                .termsConsent: "false",
                .inletConsumerId: "WFTEST111918B",
                .phoneNumber: "451-555-2222",
                .phoneCountryCode: "1",
                .zip: "94016",
                .email: "wfuser2@email.com",
                .envelopeId: envelopeId,
                .minConfidenceLevel: minConfidenceLevel
            ],
            .g: [
                .channelId: channelId,
                .termsConsent: "false",
                .inletConsumerId: "WFTEST111918C",
                .phoneNumber: "451-555-3333",
                .phoneCountryCode: "1",
                .zip: "94016",
                .email: "wfuser3@email.com",
                .envelopeId: envelopeId,
                .minConfidenceLevel: minConfidenceLevel
            ],
            .jason: [
                .channelId: channelId,
                .termsConsent: "false",
                .inletConsumerId: "WFTEST111918D",
                .phoneNumber: "451-555-4444",
                .phoneCountryCode: "1",
                .zip: "94016",
                .email: "wfuser4@email.com",
                .envelopeId: envelopeId,
                .minConfidenceLevel: minConfidenceLevel
            ]
        ]
        let restClient = RESTClient()
        let userAttributes = users[.bill]!
        return InletclientLocal(restClient: restClient, userAttributes: userAttributes).getLocalData()
    }
    
}


