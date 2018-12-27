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
        let payWithWfUser: PayWithWfUser = "bill"
        Inletclient.getBrandDetails(payWithWfUser: payWithWfUser, onBrandDetails: onBrandDetails, onError: onError)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

