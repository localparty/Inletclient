//
//  ViewController.swift
//  Inletclient
//
//  Created by localparty on 12/21/2018.
//  Copyright (c) 2018 localparty. All rights reserved.
//

import UIKit
import Inletclient


public struct InletBrand {
    
    public enum ConnectionParameter: String {
        case zip = "zipDeliveryPointType"
        case email = "emailDeliveryPointType"
    }
    
    var id: String? = nil
    var connection: Bool? = nil
    var displayName: String? = nil
    var description: String? = nil
    var connectionParameters: [ConnectionParameter]? = nil
    var assetData: [AssetData]?
    
    func getConnectionParameters(brandInfoTuple: (resultMatch: ResultMatch, brandProfile: BrandProfile)) ->
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
    
    public static func getUITableViewDataSource(
        fromInletBrands: [InletBrand],
        reusableCellIdentifier: String) -> UITableViewDataSource{
        let dataSource = InletBrandsUITableViewDataSource(brands: fromInletBrands, reusableCellIdentifier: reusableCellIdentifier)
        return dataSource as UITableViewDataSource
    }
}

class InletBrandUITableViewCell: UITableViewCell {
    var logoURL: URL? = nil
    var displayValue: String? = nil
}

class InletBrandsUITableViewDataSource: NSObject, UITableViewDataSource {
    
    let brands: [InletBrand]
    var reusableCellIdentifier: String
    
    init(brands: [InletBrand], reusableCellIdentifier: String) {
        self.brands = brands
        self.reusableCellIdentifier = reusableCellIdentifier
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRowsInSection = brands.capacity
        return numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableCellIdentifier, for: indexPath)
        if cell is InletBrandUITableViewCell {
            let brand = brands[indexPath.row]
            let inletBrandCell: InletBrandUITableViewCell = cell as! InletBrandUITableViewCell
            for assetDatum: AssetData in brand.assetData ?? [] {
                if assetDatum.assetType == "assetType" &&
                    assetDatum.assetName != nil {
                    inletBrandCell.logoURL = URL(string: assetDatum.assetName!)
                    break
                }
            }
        }
        return cell
    }
    
    
}


class ErrorUITableViewDataSource: NSObject, UITableViewDataSource {
    let cellIdentifier: String
    let error: Error
    
    init(_ error: Error, cellIdentifier: String) {
        self.error = error
        self.cellIdentifier = cellIdentifier
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        reusableCell.textLabel?.text = String(describing: self.error)
        return reusableCell
    }
}

extension Error {
    func asUITableViewDataSource(withCellIdentifier: String) -> UITableViewDataSource {
        let errorDS = ErrorUITableViewDataSource(self, cellIdentifier: withCellIdentifier)
        return errorDS as! UITableViewDataSource
    }
}
