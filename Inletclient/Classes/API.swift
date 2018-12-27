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


public enum API {}

extension API {
    // business partner id
    static func channelId () -> String {
        return "CP:0000000149";
    }
}

public class EndpointConfiguration {
    static let defaultHeaders: Headers = [
        "Content-Type": "application/json",
        "cache-control": "no-cache"
    ]
    static let timeoutInterval:TimeInterval = 220
}

public typealias Headers = [String: String]
public typealias Parameters = [String: Any]
public typealias Path = String

public enum Method {
    case get, post, put, patch, delete
}
