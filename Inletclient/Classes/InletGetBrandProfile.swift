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

struct xBrandProfile: Codable {
    var brandId: String?
    var brandName: String?
    var brandDisplayName: String?
    var abbreviatedBrandName: String?
    var brandDescription: String?
    var industryVerticals: String?
    var hasChildren: String?
    var brandUrl: String?
}

extension API {
    static func getBrandProfile(brandId: String) -> Endpoint<[BrandProfile]> {
        
        let endpointPath = "api/access/v1/brand/\(brandId)"
        
        return Endpoint(
            method: .get,
            path: endpointPath,
            parameters: nil,
            encoding: JSONEncoding.default
        )
    }
}

