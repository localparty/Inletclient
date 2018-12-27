//
//  BrandConnectionParameter.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on December 19, 2018

import Foundation

public struct BrandConnectionParameter : Codable {
    
    public let emailDeliveryPointType : EmailDeliveryPointType?
    public let zipDeliveryPointType : ZipDeliveryPointType?
    
    enum CodingKeys: String, CodingKey {
        case emailDeliveryPointType = "emailDeliveryPointType"
        case zipDeliveryPointType = "zipDeliveryPointType"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        emailDeliveryPointType = try EmailDeliveryPointType(from: decoder)
        zipDeliveryPointType = try ZipDeliveryPointType(from: decoder)
    }
    
}

