//
//  DeliveryInstruction.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on December 19, 2018

import Foundation

public struct DeliveryInstruction : Codable {
    
    public let acceptsPrintSuppression : String?
    public let allowBrandWideInstruction : String?
    public let allowByAccount : String?
    public let allowByAccountContentType : String?
    public let allowByContentType : String?
    public let allowParentInstruction : String?
    
    enum CodingKeys: String, CodingKey {
        case acceptsPrintSuppression = "acceptsPrintSuppression"
        case allowBrandWideInstruction = "allowBrandWideInstruction"
        case allowByAccount = "allowByAccount"
        case allowByAccountContentType = "allowByAccountContentType"
        case allowByContentType = "allowByContentType"
        case allowParentInstruction = "allowParentInstruction"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        acceptsPrintSuppression = try values.decodeIfPresent(String.self, forKey: .acceptsPrintSuppression)
        allowBrandWideInstruction = try values.decodeIfPresent(String.self, forKey: .allowBrandWideInstruction)
        allowByAccount = try values.decodeIfPresent(String.self, forKey: .allowByAccount)
        allowByAccountContentType = try values.decodeIfPresent(String.self, forKey: .allowByAccountContentType)
        allowByContentType = try values.decodeIfPresent(String.self, forKey: .allowByContentType)
        allowParentInstruction = try values.decodeIfPresent(String.self, forKey: .allowParentInstruction)
    }
    
}

