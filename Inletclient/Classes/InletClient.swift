import UIKit
import Alamofire
import RxSwift
import RxCocoa

public class Inletclient {
    var username: String
    var password: String
    
    public init(username: String, password: String){
        self.username = username
        self.password = password
    }
}

public struct BrandDetails {
    public var discoveryConsents: DiscoveryConsents?
    public var discoveryProfile: DiscoveryProfile?
    public var brandProfileDetails: [(resultMatch: ResultMatch, brandProfile: BrandProfile)]?
}

public enum InletClientError: Error {
    case emptyResponse
}

extension Inletclient {
    
    func onBrandProfiles(
        discoveryConsents: DiscoveryConsents,
        discoveryProfile: DiscoveryProfile,
        brandProfileDetails: [(ResultMatch, BrandProfile)],
        onBrandDetails: ((BrandDetails)->Void)?,
        onError: ((Error)->Void)?
        ) -> Void {
        
        let brandDetails: BrandDetails = BrandDetails(
            discoveryConsents: discoveryConsents,
            discoveryProfile: discoveryProfile,
            brandProfileDetails: brandProfileDetails)
        
        onBrandDetails?(brandDetails)
    }
    
    
    func putDiscoveryProfile(
        client: RESTClient,
        channelSpecificConsumerId: String,
        zip: String?,
        phoneCountryCode: String?,
        phone: String?,
        email: String?,
        minConfidenceLevel: Int,
        discoveryConsents: DiscoveryConsents,
        onBrandDetails: ((BrandDetails)->Void)?,
        onError: ((Error)->Void)?
        ) {
        
        let consentId:String = discoveryConsents.consents![0].consentId!
        
        func onPutDiscoveryProfile (discoveryProfile: DiscoveryProfile) -> Void {
            onDiscoveryProfile(
                client: client, discoveryConsents: discoveryConsents,
                discoveryProfile: discoveryProfile, minConfidenceLevel: minConfidenceLevel,
                onBrandDetails: onBrandDetails, onError: onError)
        }
        
        _ = client
            .request(API.putDiscoveryProfile(
                channelSpecificConsumerId: channelSpecificConsumerId,
                consentId: consentId, zip: zip,
                phoneCountryCode: phoneCountryCode, phone: phone, email: email))
            .asObservable()
            .subscribe(onNext: onPutDiscoveryProfile, onError: onError)
    }
    
    public func onDiscoveryProfile(
        client: RESTClient,
        discoveryConsents: DiscoveryConsents,
        discoveryProfile: DiscoveryProfile,
        minConfidenceLevel: Int,
        onBrandDetails: ((BrandDetails)->Void)?,
        onError: ((Error)->Void)?
        ){
        
        guard discoveryProfile.ccId != nil &&
            discoveryProfile.consentId != nil &&
            discoveryProfile.resultMatch != nil else {
            onError?(InletClientError.emptyResponse)
            return
        }
        
        var brandProfileObservables :[Observable<(ResultMatch, BrandProfile)>] = []
        
        if let resultMatches = discoveryProfile.resultMatch {
            
            for resultMatch in resultMatches {
                
                if resultMatch.confidenceLevel == nil {
                    print("match doesn't have confidence level")
                    continue
                }
                
                if let confidenceLevel = resultMatch.confidenceLevel {
                    guard confidenceLevel >= minConfidenceLevel else {
                        print("confidence level is not sufficient– \(confidenceLevel)")
                        continue
                    }
                }
                
                let mergerObservable:PrimitiveSequence<SingleTrait, (ResultMatch, BrandProfile)> =
                    Single<(ResultMatch, BrandProfile)>.create { observer in
                        
                        func onNextt (brandProfiles: [BrandProfile]) -> Void {
                            
                            guard brandProfiles.capacity == 1 else {
                                onError?(InletClientError.emptyResponse)
                                return
                            }
                            
                            let brandProfile: BrandProfile = brandProfiles[0]
                            
                            observer(SingleEvent.success((resultMatch, brandProfile)))
                        }
                        
                        func onErrorr (error: Error) -> Void {
                            observer(SingleEvent.error(error))
                        }
                        
                        
                        let brandId = resultMatch.brandId
                        _ = client.request(API.getBrandProfile(brandId: brandId!))
                            .asObservable()
                            .subscribe(onNext: onNextt, onError: onErrorr)
                        
                        
                        return Disposables.create {
                            print("disposable")
                        }
                }
                
                brandProfileObservables.append(mergerObservable.asObservable())
                
            }
        }
        
        
        func onBrandProfilesMerged (brandProfileDetails: [(ResultMatch, BrandProfile)]) -> Void {
            
            onBrandProfiles(
                discoveryConsents: discoveryConsents,
                discoveryProfile: discoveryProfile,
                brandProfileDetails: brandProfileDetails,
                onBrandDetails: onBrandDetails,
                onError: onError
            )
        }
        
        _ = Observable
            .zip(brandProfileObservables)
            .asObservable()
            .subscribe(onNext: onBrandProfilesMerged, onError: onError)
    }
    
    public func getBrandDetails(
        userAttributes: [UserAttribute: String],
        onBrandDetails: ((BrandDetails)->Void)?, onError: ((Error)->Void)?) {
        
        let minConfidenceLevel = 19
        
        let client = RESTClient(username: username, password: password)
        
        let channelSpecificConsumerId: String = userAttributes[.inletConsumerId]!
        let zip: String? = userAttributes[.zip]
        let phoneCountryCode: String? = userAttributes[.phoneCountryCode]
        let phone: String? = userAttributes[.phoneNumber]
        let email: String? = userAttributes[.email]
        
        func onDiscoveryConsents (_ discoveryConsents: DiscoveryConsents) -> Void {
            guard discoveryConsents.consents != nil else {
                onError?(InletClientError.emptyResponse)
                return
            }
            putDiscoveryProfile(
                client: client, channelSpecificConsumerId: channelSpecificConsumerId,
                zip: zip, phoneCountryCode: phoneCountryCode, phone: phone, email: email,
                minConfidenceLevel: minConfidenceLevel,
                discoveryConsents: discoveryConsents, onBrandDetails: onBrandDetails, onError: onError
            )
        }
        
        _ = client
            .request(API.getDiscoveryConsents())
            .asObservable()
            .subscribe(onNext: onDiscoveryConsents, onError: onError)
    }
}
