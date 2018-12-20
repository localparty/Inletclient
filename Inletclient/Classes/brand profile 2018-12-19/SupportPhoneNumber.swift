//
//  SupportPhoneNumber.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on December 19, 2018

import Foundation

struct SupportPhoneNumber : Codable {

        let supportPhoneNumberName : String?
        let supportPhoneNumberValue : String?

        enum CodingKeys: String, CodingKey {
                case supportPhoneNumberName = "supportPhoneNumberName"
                case supportPhoneNumberValue = "supportPhoneNumberValue"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                supportPhoneNumberName = try values.decodeIfPresent(String.self, forKey: .supportPhoneNumberName)
                supportPhoneNumberValue = try values.decodeIfPresent(String.self, forKey: .supportPhoneNumberValue)
        }

}
