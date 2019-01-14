//
//  BrandConnectionParameter.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on December 19, 2018

import Foundation

public struct BrandConnectionParameter : Codable {
    
    public let emailDeliveryPointType : EmailDeliveryPointType?
    public let zipDeliveryPointType : ZipDeliveryPointType?
    public let phoneNumberDeliveryPointType : PhoneNumberDeliveryPointType?
    public let structuredNameDeliveryPointType : StructuredNameDeliveryPointType?
    public let brandIdDeliveryPointType : BrandIdDeliveryPointType?
    
    enum CodingKeys: String, CodingKey {
        case emailDeliveryPointType = "emailDeliveryPointType"
        case zipDeliveryPointType = "zipDeliveryPointType"
        case phoneNumberDeliveryPointType = "phoneNumberDeliveryPointType"
        case structuredNameDeliveryPointType = "structuredNameDeliveryPointType"
        case brandIdDeliveryPointType = "brandIdDeliveryPointType"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        emailDeliveryPointType = try values.decodeIfPresent(
            EmailDeliveryPointType.self, forKey: .emailDeliveryPointType)
        
        zipDeliveryPointType = try values.decodeIfPresent(
            ZipDeliveryPointType.self, forKey: .zipDeliveryPointType)
        
        phoneNumberDeliveryPointType = try values.decodeIfPresent(
            PhoneNumberDeliveryPointType.self, forKey: .phoneNumberDeliveryPointType)
        
        structuredNameDeliveryPointType = try values.decodeIfPresent(
            StructuredNameDeliveryPointType.self, forKey: .structuredNameDeliveryPointType)
        
        brandIdDeliveryPointType = try values.decodeIfPresent(
            BrandIdDeliveryPointType.self, forKey: .brandIdDeliveryPointType)
    }
    
}

