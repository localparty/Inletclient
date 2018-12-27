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

public struct DiscoveryConsents: Codable {
    struct Consents: Codable {
        var consentId: String?
    }
    var consents: [Consents]?
}

extension API {
    static func getDiscoveryConsents() -> Endpoint<DiscoveryConsents> {
        return Endpoint(path: "api/access/v1/discovery/consent")
    }
}


