//
//  BillMetadata.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on December 19, 2018

import Foundation

public struct BillMetadata : Codable {
    
    public let billDataName : String?
    public let billDataValue : String?
    
    enum CodingKeys: String, CodingKey {
        case billDataName = "billDataName"
        case billDataValue = "billDataValue"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        billDataName = try values.decodeIfPresent(String.self, forKey: .billDataName)
        billDataValue = try values.decodeIfPresent(String.self, forKey: .billDataValue)
    }
    
}

