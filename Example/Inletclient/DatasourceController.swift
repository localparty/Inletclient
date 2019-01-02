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
    
    var datasource: UITableViewDataSource? = MemoDataSource(reusableCellIdentifier: "default", text: "loading data now...", detail: "Inlet REST API")
    
    var datasourceDelegate: DatasourceDelegate? = nil
    
    func getBrandsFromInlet(
        andThen onDataReady: ((BrandDetails)->Void)? = nil,
        orElse: ((Error)->Void)? = nil){
        
        enum PayWithWfUser: String {
            case bill
            case chris
            case jason
            case g
        }
        
        let users: [PayWithWfUser: [UserAttribute: String]] = [
            .bill: [
                .termsConsent: "false",
                .inletConsumerId: "WFTEST111918A",
                .phoneNumber: "451-555-1111",
                .phoneCountryCode: "1",
                .zip: "94016",
                .email: "wfuser1@email.com"
            ],
            .chris: [
                .termsConsent: "false",
                .inletConsumerId: "WFTEST111918B",
                .phoneNumber: "451-555-2222",
                .phoneCountryCode: "1",
                .zip: "94016",
                .email: "wfuser2@email.com"
            ],
            .g: [
                .termsConsent: "false",
                .inletConsumerId: "WFTEST111918C",
                .phoneNumber: "451-555-3333",
                .phoneCountryCode: "1",
                .zip: "94016",
                .email: "wfuser3@email.com"
            ],
            .jason: [
                .termsConsent: "false",
                .inletConsumerId: "WFTEST111918D",
                .phoneNumber: "451-555-4444",
                .phoneCountryCode: "1",
                .zip: "94016",
                .email: "wfuser4@email.com"
            ]
        ]
        let userNameValue = "$2a$06$YKYwyV3lwnQ.mFNm97XtgOie.oTAOnsh0VQh1UHQ9jbLgyrNfY/1C"
        let passwordValue = "$2a$06$H7RhnGbrHg17E4siBcilwuJTwgyRiYQZAC6GPO0lITc/t/r24ORAC"
        
        let inletClient = Inletclient(username: userNameValue, password: passwordValue)
        
        inletClient.getBrandDetails(
            userAttributes: users[.bill]!,
            andThen: { brandDetails in
                onDataReady?(brandDetails)
            },
            orElse: { error in
                orElse?(error)
            }
        )
    }
    
    public init(){
        getBrandsFromInlet(
            andThen: { brandDetails in
                self.datasource = brandDetails.asUITableViewDataSource(datasourceDelegate: self.datasourceDelegate!)
                self.datasourceDelegate?.resetDataSource(with: self.datasource!)
            },
            orElse: { error in
                self.datasource = MemoDataSource(
                    reusableCellIdentifier:  (self.datasourceDelegate?.getReusableCellIdentifier())!,
                    
                    text: error.localizedDescription,
                    detail: String(describing: error)
                )
                self.datasourceDelegate?.resetDataSource(with: self.datasource!)
            }
        )
    }
    
}

