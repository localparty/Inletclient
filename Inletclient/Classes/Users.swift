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

public enum UserAttribute: String {
    case termsConsent
    case inletConsumerId
    case phoneNumber
    case phoneCountryCode
    case zip
    case email
}
