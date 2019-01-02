//
//  ViewController.swift
//  Inletclient
//
//  Created by localparty on 12/21/2018.
//  Copyright (c) 2018 localparty. All rights reserved.
//

import UIKit

public enum UserAttribute: String {
    case termsConsent
    case inletConsumerId
    case phoneNumber
    case phoneCountryCode
    case zip
    case email
}

public struct InletBrand {
    
    public enum ConnectionParameter: String {
        case zip = "zipDeliveryPointType"
        case email = "emailDeliveryPointType"
    }
    
    public var id: String? = nil
    public var connection: Bool? = nil
    public var displayName: String? = nil
    public var description: String? = nil
    public var connectionParameters: [ConnectionParameter]? = nil
    public var assetData: [AssetData]?
    
    public func getConnectionParameters(brandInfoTuple: (resultMatch: ResultMatch, brandProfile: BrandProfile)) ->
        [ConnectionParameter] {
            var requiredData: [ConnectionParameter] = []
            
            if let brandConnectionParameters: [BrandConnectionParameter] = brandInfoTuple.brandProfile.brandConnectionParameters {
                for matchingBrandProfile: BrandConnectionParameter in brandConnectionParameters {
                    if matchingBrandProfile.emailDeliveryPointType != nil &&
                        !requiredData.contains(ConnectionParameter.email) {
                        requiredData.append(ConnectionParameter.email)
                    }
                    if matchingBrandProfile.zipDeliveryPointType != nil &&
                        !requiredData.contains(ConnectionParameter.zip) {
                        requiredData.append(ConnectionParameter.zip)
                    }
                }
            }
            return requiredData
    }
    
    public static func extractFrom(brandDetails: BrandDetails) -> [InletBrand]{
        var brands: [InletBrand] = []
        
        if let brandProfileDeets = brandDetails.brandProfileDetails {
            
            for tuple in brandProfileDeets {
                var brand = InletBrand()
                brand.id = tuple.brandProfile.brandId
                brand.connection = tuple.resultMatch.connection
                brand.displayName = tuple.brandProfile.brandDisplayName
                brand.description = tuple.brandProfile.brandDescription
                brand.connectionParameters = brand.getConnectionParameters(brandInfoTuple: tuple)
                brand.assetData = tuple.brandProfile.assetData
                
                brands.append(brand)
            }
        }
        return brands
    }
}


public class InletBrandsUITableViewDataSource: NSObject, UITableViewDataSource {
    
    public let brands: [InletBrand]
    public let datasourceDelegate: DatasourceDelegate
    
    init(brands: [InletBrand], datasourceDelegate: DatasourceDelegate) {
        self.brands = brands
        self.datasourceDelegate = datasourceDelegate
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRowsInSection = brands.capacity
        return numberOfRowsInSection
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let brand = brands[indexPath.row]
        let cell: UITableViewCell = tableView.dequeueReusableCell(
            withIdentifier: self.datasourceDelegate.getReusableCellIdentifier(),
            for: indexPath)
        
        self.datasourceDelegate.setBrandContent(brand: brand, cell: cell)
        
        return cell
    }
    
    
}

extension BrandDetails {
    public func asUITableViewDataSource (datasourceDelegate: DatasourceDelegate) -> UITableViewDataSource {
        
        let inletBrands: [InletBrand] = InletBrand.extractFrom(brandDetails: self)
        
        let uiTableViewDataSource: UITableViewDataSource = InletBrandsUITableViewDataSource(brands: inletBrands, datasourceDelegate: datasourceDelegate)
        
        return uiTableViewDataSource
    }
}

public class MemoDataSource: NSObject, UITableViewDataSource {
    
    public let reusableCellIdentifier: String
    public let memo: String
    
    init(reusableCellIdentifier: String, memo: String){
        self.reusableCellIdentifier = reusableCellIdentifier
        self.memo = memo
    }
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: reusableCellIdentifier,
                for: indexPath)
        
        cell.textLabel?.text = memo
        
        return cell
    }
    
    
}

public protocol DatasourceDelegate {
    func resetDataSource(with datasource: UITableViewDataSource) -> Void
    func setBrandContent(brand: InletBrand, cell: UITableViewCell) -> Void
    func getReusableCellIdentifier() -> String
}
