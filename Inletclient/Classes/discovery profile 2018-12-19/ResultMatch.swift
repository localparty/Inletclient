//
//  ResultMatch.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on December 19, 2018

import Foundation

public struct ResultMatch : Codable {
    
    public let accountNumber : String?
    public let billMetadata : [BillMetadata]?
    public let brandId : String?
    public let brandName : String?
    public let confidenceLevel : Int?
    public let connection : Bool?
    public let contentType : [String]?
    public let enrollmentEligibilityStatus : Bool?
    public let remittanceAddresses : [RemittanceAddresse]?
    public let verificationComplete : Bool?
    
    // introduced to merge the brand detail data
    public var brandProfile : BrandProfile?
    
    enum CodingKeys: String, CodingKey {
        case accountNumber = "accountNumber"
        case billMetadata = "billMetadata"
        case brandId = "brandId"
        case brandName = "brandName"
        case confidenceLevel = "confidenceLevel"
        case connection = "connection"
        case contentType = "contentType"
        case enrollmentEligibilityStatus = "enrollmentEligibilityStatus"
        case remittanceAddresses = "remittanceAddresses"
        case verificationComplete = "verificationComplete"
        
        // introduced to merge the brand detail data
        case brandProfile = "brandProfile"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        accountNumber = try values.decodeIfPresent(String.self, forKey: .accountNumber)
        billMetadata = try values.decodeIfPresent([BillMetadata].self, forKey: .billMetadata)
        brandId = try values.decodeIfPresent(String.self, forKey: .brandId)
        brandName = try values.decodeIfPresent(String.self, forKey: .brandName)
        confidenceLevel = try values.decodeIfPresent(Int.self, forKey: .confidenceLevel)
        connection = try values.decodeIfPresent(Bool.self, forKey: .connection)
        contentType = try values.decodeIfPresent([String].self, forKey: .contentType)
        enrollmentEligibilityStatus = try values.decodeIfPresent(Bool.self, forKey: .enrollmentEligibilityStatus)
        remittanceAddresses = try values.decodeIfPresent([RemittanceAddresse].self, forKey: .remittanceAddresses)
        verificationComplete = try values.decodeIfPresent(Bool.self, forKey: .verificationComplete)
        
        // introduced to merge the brand detail data
        brandProfile = try values.decodeIfPresent(BrandProfile.self, forKey: .brandProfile)
    }
    
}

