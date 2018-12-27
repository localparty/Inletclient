//
//  DocumentRetentionPolicy.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on December 19, 2018

import Foundation

public struct DocumentRetentionPolicy : Codable {
    
    let contentType : String?
    let retentionDuration : String?
    
    enum CodingKeys: String, CodingKey {
        case contentType = "contentType"
        case retentionDuration = "retentionDuration"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        contentType = try values.decodeIfPresent(String.self, forKey: .contentType)
        retentionDuration = try values.decodeIfPresent(String.self, forKey: .retentionDuration)
    }
    
}

