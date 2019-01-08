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
    public static func getEnvelope(envelopeId: String) -> Endpoint<Envelope> {
        return Endpoint(path: "api/access/v1/envelope/\(envelopeId)")
    }
}
