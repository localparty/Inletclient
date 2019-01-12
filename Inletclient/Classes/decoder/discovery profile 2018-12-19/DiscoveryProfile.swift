//
//  RootClass.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on December 19, 2018

import Foundation

public struct DiscoveryProfile : Codable {
    
    public let ccId : String?
    public let consentId : String?
    public var resultMatch : [ResultMatch]?
    
    enum CodingKeys: String, CodingKey {
        case ccId = "ccId"
        case consentId = "consentId"
        case resultMatch = "resultMatch"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ccId = try values.decodeIfPresent(String.self, forKey: .ccId)
        consentId = try values.decodeIfPresent(String.self, forKey: .consentId)
        resultMatch = try values.decodeIfPresent([ResultMatch].self, forKey: .resultMatch)
    }
    
}

