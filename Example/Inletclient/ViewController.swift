//
//  ViewController.swift
//  Inletclient
//
//  Created by localparty on 12/21/2018.
//  Copyright (c) 2018 localparty. All rights reserved.
//

import UIKit
import Inletclient

class ViewController: UIViewController {
    
    func onError(_ error: Error) {
        print("Inletclient error– \(error)")
    }
    
    func onBrandDetails(_ brandDetails: BrandDetails) {
        print("Inletclient brand details– \(brandDetails)")
        
        enum RequiredDatum: String {
            case zip = "zipDeliveryPointType"
            case email = "emailDeliveryPointType"
        }
        
        if let brandProfileDeet = brandDetails.brandProfileDetails {
            
            for tuple in brandProfileDeet {
                var requiredData: [RequiredDatum] = []
             
                let brandProfile: BrandProfile = tuple.brandProfile
                
                if let brandConnectionParameters: [BrandConnectionParameter] = brandProfile.brandConnectionParameters {
                    for matchingBrandProfile: BrandConnectionParameter in brandConnectionParameters {
                        if matchingBrandProfile.emailDeliveryPointType != nil &&
                            !requiredData.contains(RequiredDatum.email) {
                            requiredData.append(RequiredDatum.email)
                        }
                        if matchingBrandProfile.zipDeliveryPointType != nil &&
                            !requiredData.contains(RequiredDatum.zip) {
                            requiredData.append(RequiredDatum.zip)
                        }
                    }
                }
                
                for requiredDatum  in requiredData {
                    print("the brand with id– \(String(describing: brandProfile.brandId)) requires additional data– \(requiredDatum.rawValue)")
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        enum PayWithWfUser: String {
            case bill
        }
        
        let users: [PayWithWfUser: [UserAttribute: String]] = [
            .bill: [
                .termsConsent: "false",
                .inletConsumerId: "WFTEST111918A",
                .phoneNumber: "451-555-1111",
                .phoneCountryCode: "1",
                .zip: "94016",
                .email: "wfuser1@email.com"
            ]
        ]
        let userNameValue = "$2a$06$YKYwyV3lwnQ.mFNm97XtgOie.oTAOnsh0VQh1UHQ9jbLgyrNfY/1C"
        let passwordValue = "$2a$06$H7RhnGbrHg17E4siBcilwuJTwgyRiYQZAC6GPO0lITc/t/r24ORAC"
        
        let inletClient = Inletclient(username: userNameValue, password: passwordValue)
        
        inletClient.getBrandDetails(userAttributes: users[.bill]!, onBrandDetails: onBrandDetails, onError: onError)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

