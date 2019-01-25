//
//  BrandConsent.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on December 19, 2018

import Foundation

public struct BrandConsent : Codable {
    
    public let brandId : String?
    public let consentFile : String?
    public let consentFileName : String?
    public let consentFormat : String?
    public let consentId : String?
    public let consentLanguage : String?
    public let consentReference : String?
    public let consentSource : String?
    public let consentText : String?
    public let consentUpdatePolicy : String?
    public let consentUrl : String?
    public let effectiveDate : String?
    public let expiryDate : String?
    public let languageCode : String?
    public let status : String?
    
    enum CodingKeys: String, CodingKey {
        case brandId = "brandId"
        case consentFile = "consentFile"
        case consentFileName = "consentFileName"
        case consentFormat = "consentFormat"
        case consentId = "consentId"
        case consentLanguage = "consentLanguage"
        case consentReference = "consentReference"
        case consentSource = "consentSource"
        case consentText = "consentText"
        case consentUpdatePolicy = "consentUpdatePolicy"
        case consentUrl = "consentUrl"
        case effectiveDate = "effectiveDate"
        case expiryDate = "expiryDate"
        case languageCode = "languageCode"
        case status = "status"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        brandId = try values.decodeIfPresent(String.self, forKey: .brandId)
        consentFile = try values.decodeIfPresent(String.self, forKey: .consentFile)
        consentFileName = try values.decodeIfPresent(String.self, forKey: .consentFileName)
        consentFormat = try values.decodeIfPresent(String.self, forKey: .consentFormat)
        consentId = try values.decodeIfPresent(String.self, forKey: .consentId)
        consentLanguage = try values.decodeIfPresent(String.self, forKey: .consentLanguage)
        consentReference = try values.decodeIfPresent(String.self, forKey: .consentReference)
        consentSource = try values.decodeIfPresent(String.self, forKey: .consentSource)
        consentText = try values.decodeIfPresent(String.self, forKey: .consentText)
        consentUpdatePolicy = try values.decodeIfPresent(String.self, forKey: .consentUpdatePolicy)
        consentUrl = try values.decodeIfPresent(String.self, forKey: .consentUrl)
        effectiveDate = try values.decodeIfPresent(String.self, forKey: .effectiveDate)
        expiryDate = try values.decodeIfPresent(String.self, forKey: .expiryDate)
        languageCode = try values.decodeIfPresent(String.self, forKey: .languageCode)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
    
}

