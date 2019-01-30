//
//  UserField.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on December 19, 2018

import Foundation

public struct UserField : Codable {
    
    public let fieldId : String?
    public let fieldType : String?
    
    enum CodingKeys: String, CodingKey {
        case fieldId = "fieldId"
        case fieldType = "fieldType"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        fieldId = try values.decodeIfPresent(String.self, forKey: .fieldId)
        fieldType = try values.decodeIfPresent(String.self, forKey: .fieldType)
    }
    
}

