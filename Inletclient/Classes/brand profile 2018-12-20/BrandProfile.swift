//
//  RootClass.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on December 19, 2018

import Foundation

public struct BrandProfile : Codable {
    
    public let abbreviatedBrandName : String?
    public let accountNumberFormat : [String]?
    public let assetData : [AssetData]?
    public let brandConnectionParameters : [BrandConnectionParameter]?
    public let brandConsents : [BrandConsent]?
    public let brandDescription : String?
    public let brandDisplayName : String?
    public let brandHeadquartersAddress : [String]?
    public let brandId : String?
    public let brandName : String?
    public let brandTerminationDate : String?
    public let brandUrl : String?
    public let contentIngestionMethod : String?
    public let contentTypes : [String]?
    public let dateOfFirstAvailability : String?
    public let deliveryInstructionConfirmationSupport : String?
    public let deliveryInstructions : DeliveryInstruction?
    public let documentRetentionPolicies : [DocumentRetentionPolicy]?
    public let hasChildren : String?
    public let historicalContentSupport : String?
    public let industryVerticals : String?
    public let languageCode : String?
    public let lastModifiedOn : String?
    public let parentId : String?
    public let regionsServed : [String]?
    public let remittanceAddresses : [BrandProfileRemittanceAddresse]?
    public let supportEmails : [SupportEmail]?
    public let supportPhoneNumbers : [SupportPhoneNumber]?
    public let supportUrl : String?
    
    enum CodingKeys: String, CodingKey {
        case abbreviatedBrandName = "abbreviatedBrandName"
        case accountNumberFormat = "accountNumberFormat"
        case assetData = "assetData"
        case brandConnectionParameters = "brandConnectionParameters"
        case brandConsents = "brandConsents"
        case brandDescription = "brandDescription"
        case brandDisplayName = "brandDisplayName"
        case brandHeadquartersAddress = "brandHeadquartersAddress"
        case brandId = "brandId"
        case brandName = "brandName"
        case brandTerminationDate = "brandTerminationDate"
        case brandUrl = "brandUrl"
        case contentIngestionMethod = "contentIngestionMethod"
        case contentTypes = "contentTypes"
        case dateOfFirstAvailability = "dateOfFirstAvailability"
        case deliveryInstructionConfirmationSupport = "deliveryInstructionConfirmationSupport"
        case deliveryInstructions = "deliveryInstructions"
        case documentRetentionPolicies = "documentRetentionPolicies"
        case hasChildren = "hasChildren"
        case historicalContentSupport = "historicalContentSupport"
        case industryVerticals = "industryVerticals"
        case languageCode = "languageCode"
        case lastModifiedOn = "lastModifiedOn"
        case parentId = "parentId"
        case regionsServed = "regionsServed"
        case remittanceAddresses = "remittanceAddresses"
        case supportEmails = "supportEmails"
        case supportPhoneNumbers = "supportPhoneNumbers"
        case supportUrl = "supportUrl"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        abbreviatedBrandName = try values.decodeIfPresent(String.self, forKey: .abbreviatedBrandName)
        accountNumberFormat = try values.decodeIfPresent([String].self, forKey: .accountNumberFormat)
        assetData = try values.decodeIfPresent([AssetData].self, forKey: .assetData)
        brandConnectionParameters = try values.decodeIfPresent([BrandConnectionParameter].self, forKey: .brandConnectionParameters)
        brandConsents = try values.decodeIfPresent([BrandConsent].self, forKey: .brandConsents)
        brandDescription = try values.decodeIfPresent(String.self, forKey: .brandDescription)
        brandDisplayName = try values.decodeIfPresent(String.self, forKey: .brandDisplayName)
        brandHeadquartersAddress = try values.decodeIfPresent([String].self, forKey: .brandHeadquartersAddress)
        brandId = try values.decodeIfPresent(String.self, forKey: .brandId)
        brandName = try values.decodeIfPresent(String.self, forKey: .brandName)
        brandTerminationDate = try values.decodeIfPresent(String.self, forKey: .brandTerminationDate)
        brandUrl = try values.decodeIfPresent(String.self, forKey: .brandUrl)
        contentIngestionMethod = try values.decodeIfPresent(String.self, forKey: .contentIngestionMethod)
        contentTypes = try values.decodeIfPresent([String].self, forKey: .contentTypes)
        dateOfFirstAvailability = try values.decodeIfPresent(String.self, forKey: .dateOfFirstAvailability)
        deliveryInstructionConfirmationSupport = try values.decodeIfPresent(String.self, forKey: .deliveryInstructionConfirmationSupport)
        deliveryInstructions = try DeliveryInstruction(from: decoder)
        documentRetentionPolicies = try values.decodeIfPresent([DocumentRetentionPolicy].self, forKey: .documentRetentionPolicies)
        hasChildren = try values.decodeIfPresent(String.self, forKey: .hasChildren)
        historicalContentSupport = try values.decodeIfPresent(String.self, forKey: .historicalContentSupport)
        industryVerticals = try values.decodeIfPresent(String.self, forKey: .industryVerticals)
        languageCode = try values.decodeIfPresent(String.self, forKey: .languageCode)
        lastModifiedOn = try values.decodeIfPresent(String.self, forKey: .lastModifiedOn)
        parentId = try values.decodeIfPresent(String.self, forKey: .parentId)
        regionsServed = try values.decodeIfPresent([String].self, forKey: .regionsServed)
        remittanceAddresses = try values.decodeIfPresent([BrandProfileRemittanceAddresse].self, forKey: .remittanceAddresses)
        supportEmails = try values.decodeIfPresent([SupportEmail].self, forKey: .supportEmails)
        supportPhoneNumbers = try values.decodeIfPresent([SupportPhoneNumber].self, forKey: .supportPhoneNumbers)
        supportUrl = try values.decodeIfPresent(String.self, forKey: .supportUrl)
    }
    
}


