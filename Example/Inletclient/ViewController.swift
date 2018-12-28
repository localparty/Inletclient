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
    @IBOutlet weak var brandsUIButton: UIButton!
    
    @IBAction func onGetDataNow(_ sender: UIButton) {
        sender.isEnabled = false
        getBrandsFromInlet(
            andThen: { data in
                DispatchQueue.main.async {
                    sender.isEnabled = true
                }
            },
            orElse: { error in
                DispatchQueue.main.async {
                    sender.isEnabled = true
                }
            }
        )
    }
    
    @IBOutlet weak var brandsUITableView: UITableView!
    
    enum StoryBoardReusableCellIdentifier: String {
        case inletBrand = "inletBrandCell"
        case errorCell = "errorCell"
    }
    
    func onBrandDetailsError(_ error: Error) {
        print("Inletclient error– \(error)")
        
        let errorDataSource: UITableViewDataSource =
            error.asUITableViewDataSource(withCellIdentifier: StoryBoardReusableCellIdentifier.errorCell.rawValue)
        
        DispatchQueue.main.async {
            self.brandsUITableView.dataSource = errorDataSource
            self.brandsUITableView.reloadData()
        }
    }
    
    func onBrandDetails(_ brandDetails: BrandDetails) {
        let inletBrands: [InletBrand] = InletBrand.extractFrom(brandDetails: brandDetails)
        for inletBrand in inletBrands {
            print("brand details– \(String(describing: inletBrand))")
        }
        
        let inletBrandsDatasource: UITableViewDataSource = InletBrand.getUITableViewDataSource(fromInletBrands: inletBrands, reusableCellIdentifier: StoryBoardReusableCellIdentifier.inletBrand.rawValue)
        
        DispatchQueue.main.async {
            self.brandsUITableView.dataSource = inletBrandsDatasource
            self.brandsUITableView.reloadData()
        }
        
    }
    
    func getBrandsFromInlet(andThen onDataReady: ((Any)->Void)? = nil, orElse: ((Error)->Void)? = nil){
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
            onBrandDetails: { brandDetails in
                onDataReady?(brandDetails)
                self.onBrandDetails(brandDetails)
            },
            onError: { error in
                orElse?(error)
                self.onBrandDetailsError(error)
            }
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

