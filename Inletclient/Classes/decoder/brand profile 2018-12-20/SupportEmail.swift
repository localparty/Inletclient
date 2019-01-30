//
//  SupportEmail.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on December 19, 2018

import Foundation

public struct SupportEmail : Codable {
    
    public let supportEmailName : String?
    public let supportEmailValue : String?
    
    enum CodingKeys: String, CodingKey {
        case supportEmailName = "supportEmailName"
        case supportEmailValue = "supportEmailValue"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        supportEmailName = try values.decodeIfPresent(String.self, forKey: .supportEmailName)
        supportEmailValue = try values.decodeIfPresent(String.self, forKey: .supportEmailValue)
    }
    
}

