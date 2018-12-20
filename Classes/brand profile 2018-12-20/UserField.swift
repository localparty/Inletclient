//
//  UserField.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on December 19, 2018

import Foundation

struct UserField : Codable {
    
    let fieldId : String?
    let fieldType : String?
    
    enum CodingKeys: String, CodingKey {
        case fieldId = "fieldId"
        case fieldType = "fieldType"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        fieldId = try values.decodeIfPresent(String.self, forKey: .fieldId)
        fieldType = try values.decodeIfPresent(String.self, forKey: .fieldType)
    }
    
}

