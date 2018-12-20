//
//  RemittanceAddresse.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on December 19, 2018

import Foundation

struct BrandProfileRemittanceAddresse : Codable {

        let addressLines : [String]?
        let addressName : String?

        enum CodingKeys: String, CodingKey {
                case addressLines = "addressLines"
                case addressName = "addressName"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                addressLines = try values.decodeIfPresent([String].self, forKey: .addressLines)
                addressName = try values.decodeIfPresent(String.self, forKey: .addressName)
        }

}
