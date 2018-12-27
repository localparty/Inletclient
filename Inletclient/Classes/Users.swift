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

public typealias PayWithWfUser = String
public typealias PayWithWfUsers = [PayWithWfUser: [UserAttribute: Any]]
public typealias InletCid = String

public enum UserAttribute: String {
    case termsConsent
    case inletConsumerId
    case phoneNumber
    case phoneCountryCode
    case zip
    case email
}

public class WfClient {
    
    public static let users: PayWithWfUsers = [
        "bill": [
            .termsConsent: false,
            .inletConsumerId: "WFTEST111918A",
            .phoneNumber: "451-555-1111",
            .phoneCountryCode: "1",
            .zip: "94016",
            .email: "wfuser1@email.com"
        ]
    ]
    
}
