//
//  Envelope.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on January 8, 2019

import Foundation

public struct Envelope: Codable {
    
    public let asOfDate : String?
    public let billData : EnvelopeBillData?
    public let brandConnectionId : String?
    public let brandId : String?
    public let contentType : String?
    public let envelopeDocuments : [EnvelopeDocument]?
    public let envelopeId : String?
    public let envelopeName : String?
    public let envelopeStatus : String?
    public let historicalMail : String?
    public let ingestionDate : String?
    public let lastModifiedOn : String?
    public let mailType : String?
    public let printSuppressed : String?
    
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case asOfDate = "asOfDate"
        case billData = "billData"
        case brandConnectionId = "brandConnectionId"
        case brandId = "brandId"
        case contentType = "contentType"
        case envelopeDocuments = "envelopeDocuments"
        case envelopeId = "envelopeId"
        case envelopeName = "envelopeName"
        case envelopeStatus = "envelopeStatus"
        case historicalMail = "historicalMail"
        case ingestionDate = "ingestionDate"
        case lastModifiedOn = "lastModifiedOn"
        case mailType = "mailType"
        case printSuppressed = "printSuppressed"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        asOfDate = try values.decodeIfPresent(String.self, forKey: .asOfDate)
        billData = try EnvelopeBillData(from: decoder)
        brandConnectionId = try values.decodeIfPresent(String.self, forKey: .brandConnectionId)
        brandId = try values.decodeIfPresent(String.self, forKey: .brandId)
        contentType = try values.decodeIfPresent(String.self, forKey: .contentType)
        envelopeDocuments = try values.decodeIfPresent([EnvelopeDocument].self, forKey: .envelopeDocuments)
        envelopeId = try values.decodeIfPresent(String.self, forKey: .envelopeId)
        envelopeName = try values.decodeIfPresent(String.self, forKey: .envelopeName)
        envelopeStatus = try values.decodeIfPresent(String.self, forKey: .envelopeStatus)
        historicalMail = try values.decodeIfPresent(String.self, forKey: .historicalMail)
        ingestionDate = try values.decodeIfPresent(String.self, forKey: .ingestionDate)
        lastModifiedOn = try values.decodeIfPresent(String.self, forKey: .lastModifiedOn)
        mailType = try values.decodeIfPresent(String.self, forKey: .mailType)
        printSuppressed = try values.decodeIfPresent(String.self, forKey: .printSuppressed)
    }
    
}

