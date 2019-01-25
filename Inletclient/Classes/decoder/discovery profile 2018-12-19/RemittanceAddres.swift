//
//  RemittanceAddres.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on December 19, 2018

import Foundation

public struct RemittanceAddres : Codable {
    
    public let addressLines : [String]?
    public let addressName : String?
    
    enum CodingKeys: String, CodingKey {
        case addressLines = "addressLines"
        case addressName = "addressName"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        addressLines = try values.decodeIfPresent([String].self, forKey: .addressLines)
        addressName = try values.decodeIfPresent(String.self, forKey: .addressName)
    }
    
}

