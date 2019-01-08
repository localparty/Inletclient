//
//  EnvelopeDocument.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on January 8, 2019

import Foundation

public struct EnvelopeDocument : Codable {

        public let documentId : String?

        enum CodingKeys: String, CodingKey {
                case documentId = "documentId"
        }
    
        public init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                documentId = try values.decodeIfPresent(String.self, forKey: .documentId)
        }

}
