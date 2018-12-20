//
//  RemittanceAddresse.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on December 19, 2018

import Foundation

struct RemittanceAddresse : Codable {
    
    let remittanceAddress : RemittanceAddres?
    
    enum CodingKeys: String, CodingKey {
        case remittanceAddress = "remittanceAddress"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        remittanceAddress = try RemittanceAddres(from: decoder)
    }
    
}

