//
//  ZipDeliveryPointType.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on December 19, 2018

import Foundation

struct ZipDeliveryPointType : Codable {

        let deliveryPointName : String?
        let deliveryPointScope : String?
        let userFields : [UserField]?

        enum CodingKeys: String, CodingKey {
                case deliveryPointName = "deliveryPointName"
                case deliveryPointScope = "deliveryPointScope"
                case userFields = "userFields"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                deliveryPointName = try values.decodeIfPresent(String.self, forKey: .deliveryPointName)
                deliveryPointScope = try values.decodeIfPresent(String.self, forKey: .deliveryPointScope)
                userFields = try values.decodeIfPresent([UserField].self, forKey: .userFields)
        }

}
