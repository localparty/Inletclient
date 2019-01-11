//
//  DatasourceController.swift
//  Inletclient Example
//
//  Created by Donkey Donks on 1/2/19.
//  Copyright © 2019 Wells Fargo. All rights reserved.
//

import UIKit
import Inletclient

class InletController {
    
    var datasource: UITableViewDataSource? = TextDetailDatasource(
        reusableCellIdentifier: "default",
        text: "loading data now...",
        detail: "Inlet REST API"
    )
    
    func getData(
        onData: (((DiscoveryConsents, DiscoveryProfile, [(ResultMatch, BrandProfile)], Mailbox))->Void)? = nil,
        onError: ((Error)->Void)? = nil){
        
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
        
        let userNameValue = "$2a$06$YKYwyV3lwnQ.mFNm97XtgOie.oTAOnsh0VQh1UHQ9jbLgyrNfY/1C"
        let passwordValue = "$2a$06$H7RhnGbrHg17E4siBcilwuJTwgyRiYQZAC6GPO0lITc/t/r24ORAC"
        
        let inletClient = Inletclient(username: userNameValue, password: passwordValue)
        
        inletClient.getData(
            userAttributes: users[.bill]!,
            onData: onData,
            onError: onError)
    }
    
}

