//
//  RemittanceAddresse.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on December 19, 2018

import Foundation

public struct RemittanceAddresse : Codable {
    
    public let remittanceAddress : RemittanceAddres?
    
    enum CodingKeys: String, CodingKey {
        case remittanceAddress = "remittanceAddress"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        remittanceAddress = try values.decodeIfPresent(RemittanceAddres.self, forKey: .remittanceAddress)
        //remittanceAddress = try RemittanceAddres(from: decoder)
    }
    
}

