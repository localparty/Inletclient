//
//  AssetData.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on December 19, 2018

import Foundation

struct AssetData : Codable {

        let assetDescription : String?
        let assetId : String?
        let assetName : String?
        let assetTitle : String?
        let assetType : String?
        let brandId : String?
        let languageCode : String?

        enum CodingKeys: String, CodingKey {
                case assetDescription = "assetDescription"
                case assetId = "assetId"
                case assetName = "assetName"
                case assetTitle = "assetTitle"
                case assetType = "assetType"
                case brandId = "brandId"
                case languageCode = "languageCode"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                assetDescription = try values.decodeIfPresent(String.self, forKey: .assetDescription)
                assetId = try values.decodeIfPresent(String.self, forKey: .assetId)
                assetName = try values.decodeIfPresent(String.self, forKey: .assetName)
                assetTitle = try values.decodeIfPresent(String.self, forKey: .assetTitle)
                assetType = try values.decodeIfPresent(String.self, forKey: .assetType)
                brandId = try values.decodeIfPresent(String.self, forKey: .brandId)
                languageCode = try values.decodeIfPresent(String.self, forKey: .languageCode)
        }

}
