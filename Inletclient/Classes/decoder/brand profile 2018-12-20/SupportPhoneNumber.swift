//
//  SupportPhoneNumber.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on December 19, 2018

import Foundation

public struct SupportPhoneNumber : Codable {
    
    public let supportPhoneNumberName : String?
    public let supportPhoneNumberValue : String?
    
    enum CodingKeys: String, CodingKey {
        case supportPhoneNumberName = "supportPhoneNumberName"
        case supportPhoneNumberValue = "supportPhoneNumberValue"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        supportPhoneNumberName = try values.decodeIfPresent(String.self, forKey: .supportPhoneNumberName)
        supportPhoneNumberValue = try values.decodeIfPresent(String.self, forKey: .supportPhoneNumberValue)
    }
    
}

