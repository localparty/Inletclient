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
    
    public struct Brand {
        
        public enum ConnectionParameter: String {
            case zip = "zipDeliveryPointType"
            case email = "emailDeliveryPointType"
        }
        
        var id: String? = nil
        var connection: Bool? = nil
        var displayName: String? = nil
        var description: String? = nil
        var connectionParameters: [ConnectionParameter]? = nil
        var assetData: [AssetData]?
        
        func getConnectionParameters(brandInfoTuple: (resultMatch: ResultMatch, brandProfile: BrandProfile)) ->
            [ConnectionParameter] {
                var requiredData: [ConnectionParameter] = []
                
                if let brandConnectionParameters: [BrandConnectionParameter] = brandInfoTuple.brandProfile.brandConnectionParameters {
                    for matchingBrandProfile: BrandConnectionParameter in brandConnectionParameters {
                        if matchingBrandProfile.emailDeliveryPointType != nil &&
                            !requiredData.contains(ConnectionParameter.email) {
                            requiredData.append(ConnectionParameter.email)
                        }
                        if matchingBrandProfile.zipDeliveryPointType != nil &&
                            !requiredData.contains(ConnectionParameter.zip) {
                            requiredData.append(ConnectionParameter.zip)
                        }
                    }
                }
                return requiredData
        }
        
        public static func extractFrom(brandDetails: BrandDetails) -> [Brand]{
            var brands: [Brand] = []
            
            if let brandProfileDeets = brandDetails.brandProfileDetails {
                
                for tuple in brandProfileDeets {
                    var brand = Brand()
                    brand.id = tuple.brandProfile.brandId
                    brand.connection = tuple.resultMatch.connection
                    brand.displayName = tuple.brandProfile.brandDisplayName
                    brand.description = tuple.brandProfile.brandDescription
                    brand.connectionParameters = brand.getConnectionParameters(brandInfoTuple: tuple)
                    brand.assetData = tuple.brandProfile.assetData
                    
                    brands.append(brand)
                }
            }
            return brands
        }
    }

    func onBrandDetails(_ brandDetails: BrandDetails) {
        let brandsInfo: [Brand] = Brand.extractFrom(brandDetails: brandDetails)
        for brandInfo in brandsInfo {
            print("brand details– \(String(describing: brandInfo))")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
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
            onBrandDetails: onBrandDetails,
            onError: onError)
        /*
         
         
         inletClient.getBrandDetails(
         userAttributes: users[.chris]!,
         onBrandDetails: onBrandDetails,
         onError: onError)
         
         inletClient.getBrandDetails(
         userAttributes: users[.jason]!,
         onBrandDetails: onBrandDetails,
         onError: onError)
         
         inletClient.getBrandDetails(
         userAttributes: users[.g]!,
         onBrandDetails: onBrandDetails,
         onError: onError)
         */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

