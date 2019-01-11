//
//  MailboxEnvelope.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on January 9, 2019

import Foundation

public struct MailboxEnvelope : Codable {
    
    public let accountNumber : String?
    public let billData : MailboxBillData?
    public let brandId : String?
    public let contentType : String?
    public let envelopeId : String?
    public let envelopeStatus : String?
    public let ingestionDate : String?
    public let lastModifiedOn : String?
    public let mailType : String?
    
    public enum CodingKeys: String, CodingKey {
        case accountNumber = "accountNumber"
        case billData = "billData"
        case brandId = "brandId"
        case contentType = "contentType"
        case envelopeId = "envelopeId"
        case envelopeStatus = "envelopeStatus"
        case ingestionDate = "ingestionDate"
        case lastModifiedOn = "lastModifiedOn"
        case mailType = "mailType"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        accountNumber = try values.decodeIfPresent(String.self, forKey: .accountNumber)
        billData = try MailboxBillData(from: decoder)
        brandId = try values.decodeIfPresent(String.self, forKey: .brandId)
        contentType = try values.decodeIfPresent(String.self, forKey: .contentType)
        envelopeId = try values.decodeIfPresent(String.self, forKey: .envelopeId)
        envelopeStatus = try values.decodeIfPresent(String.self, forKey: .envelopeStatus)
        ingestionDate = try values.decodeIfPresent(String.self, forKey: .ingestionDate)
        lastModifiedOn = try values.decodeIfPresent(String.self, forKey: .lastModifiedOn)
        mailType = try values.decodeIfPresent(String.self, forKey: .mailType)
    }
    
}

