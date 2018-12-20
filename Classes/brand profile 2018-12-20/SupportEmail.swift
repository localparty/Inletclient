//
//  SupportEmail.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on December 19, 2018

import Foundation

struct SupportEmail : Codable {
    
    let supportEmailName : String?
    let supportEmailValue : String?
    
    enum CodingKeys: String, CodingKey {
        case supportEmailName = "supportEmailName"
        case supportEmailValue = "supportEmailValue"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        supportEmailName = try values.decodeIfPresent(String.self, forKey: .supportEmailName)
        supportEmailValue = try values.decodeIfPresent(String.self, forKey: .supportEmailValue)
    }
    
}

