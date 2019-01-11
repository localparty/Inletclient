import UIKit
import Alamofire
import RxSwift
import RxCocoa

public enum UserAttribute: String {
    case termsConsent
    case inletConsumerId
    case phoneNumber
    case phoneCountryCode
    case zip
    case email
    case envelopeId
    case minConfidenceLevel
    case channelId
}

public class Inletclient {
    
    public enum InletClientError: Error {
        case emptyResponse
    }
    
    var username: String
    var password: String
    
    public init(username: String, password: String){
        self.username = username
        self.password = password
    }
    
    func getEnvelope(
        restClient: RESTClient,
        userAttributes: [UserAttribute: String],
        otherData: (DiscoveryConsents, DiscoveryProfile, [(ResultMatch, BrandProfile)]),
        onData: (((DiscoveryConsents, DiscoveryProfile, [(ResultMatch, BrandProfile)], Envelope))->Void)?,
        onError: ((Error)->Void)?
        ) {
        
        let envelopeId: String = userAttributes[.minConfidenceLevel]!
        
        func onEnvelope (envelope: Envelope) -> Void {
            guard envelope.envelopeId != nil else {
                print("couln't get the envelope")
                onError?(InletClientError.emptyResponse)
                return
            }
            onData?(( otherData.0, otherData.1, otherData.2, envelope))
        }
        
        _ = restClient
            .request(API.getEnvelope(envelopeId: envelopeId))
            .asObservable()
            .subscribe(onNext: onEnvelope, onError: onError)
    }
    
    
    func putDiscoveryProfile(
        restClient: RESTClient,
        userAttributes: [UserAttribute: String],
        otherData: DiscoveryConsents,
        onData: (((DiscoveryConsents, DiscoveryProfile, [(ResultMatch, BrandProfile)], Mailbox))->Void)?,
        onError: ((Error)->Void)?
        ) {
        let channelId: String = userAttributes[.channelId]!
        let channelSpecificConsumerId: String = userAttributes[.inletConsumerId]!
        let zip: String? = userAttributes[.zip]
        let phoneCountryCode: String? = userAttributes[.phoneCountryCode]
        let phone: String? = userAttributes[.phoneNumber]
        let email: String? = userAttributes[.email]
        
        let consentId:String = otherData.consents![0].consentId!
        
        func onPutDiscoveryProfile (discoveryProfile: DiscoveryProfile) -> Void {
            onDiscoveryProfile(
                restClient: restClient,
                userAttributes: userAttributes,
                otherData: (otherData, discoveryProfile),
                onData: onData,
                onError: onError
            )
        }
        
        _ = restClient
            .request(API.putDiscoveryProfile(
                channelId: channelId, channelSpecificConsumerId: channelSpecificConsumerId,
                consentId: consentId, zip: zip, phoneCountryCode: phoneCountryCode,
                phone: phone, email: email))
            .asObservable()
            .subscribe(onNext: onPutDiscoveryProfile, onError: onError)
    }
    
    public func onDiscoveryProfile(
        restClient: RESTClient,
        userAttributes: [UserAttribute: String],
        otherData: (DiscoveryConsents, DiscoveryProfile),
        onData: (((DiscoveryConsents, DiscoveryProfile, [(ResultMatch, BrandProfile)], Mailbox))->Void)?,
        onError: ((Error)->Void)?
        ){
        
        let minConfidenceLevel = userAttributes[.minConfidenceLevel]
        let discoveryConsents = otherData.0
        let discoveryProfile = otherData.1
        
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
                    guard confidenceLevel >= Int(minConfidenceLevel!)! else {
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
                        _ = restClient.request(API.getBrandProfile(brandId: brandId!))
                            .asObservable()
                            .subscribe(onNext: onNextt, onError: onErrorr)
                        
                        
                        return Disposables.create {
                            print("disposable")
                        }
                }
                
                brandProfileObservables.append(mergerObservable.asObservable())
                
            }
        }
        
        
        func onNext (
            brandProfileDetails: [(ResultMatch, BrandProfile)],
            mailbox: Mailbox
            ) -> Void {
            
            onData?((
                discoveryConsents,
                discoveryProfile,
                brandProfileDetails,
                mailbox))
        }
        /*
         _ = Observable
         .zip(brandProfileObservables)
         .asObservable()
         .subscribe(onNext: onBrandProfilesMerged, onError: onError)
         */
        let brandProfileZipObservable = Observable
            .zip(brandProfileObservables)
            .asObservable()
        let ccId = discoveryProfile.ccId!
        let getMailboxObservable = restClient
            .request(API.getMailbox(ccId: ccId))
            .asObservable()
        
        let dependencies = Observable.combineLatest(
            brandProfileZipObservable,
            getMailboxObservable
            )
            .asObservable()
            .subscribe(onNext: onNext, onError: onError)
        
        
        
    }
    
    public func getData(
        userAttributes: [UserAttribute: String],
        onData: (((DiscoveryConsents, DiscoveryProfile, [(ResultMatch, BrandProfile)], Mailbox))->Void)?,
        onError: ((Error)->Void)?) {
        let client = RESTClient(username: username, password: password)
        
        func onDiscoveryConsents (_ discoveryConsents: DiscoveryConsents) -> Void {
            guard discoveryConsents.consents != nil else {
                onError?(InletClientError.emptyResponse)
                return
            }
            putDiscoveryProfile(
                restClient: client, userAttributes: userAttributes,
                otherData: discoveryConsents, onData: onData, onError: onError
            )
        }
        
        _ = client
            .request(API.getDiscoveryConsents())
            .asObservable()
            .subscribe(onNext: onDiscoveryConsents, onError: onError)
    }
    
    public typealias InletData = (DiscoveryConsents, DiscoveryProfile, [(ResultMatch, BrandProfile)], Mailbox)
    
    public static func getBrandProfileObservables (
        restClient: RESTClient,
        userAttributes: [UserAttribute: String],
        discoveryProfile: DiscoveryProfile
        ) -> Observable<[(ResultMatch, BrandProfile)]> {
    
        
        let minConfidenceLevel = userAttributes[.minConfidenceLevel]
        let filteredResultMatches: [ResultMatch] = (discoveryProfile.resultMatch ?? [] as! [ResultMatch]).compactMap({ (resultMatch) in
            guard resultMatch.confidenceLevel != nil else {
                print("missing confidence level–> \(resultMatch)")
                return nil
            }
            guard resultMatch.confidenceLevel! >= Int(minConfidenceLevel!)! else {
                print("confidence level is not sufficient– \(resultMatch.confidenceLevel!)")
                return nil
            }
            return resultMatch
        })
        
        let brandProfileObservables: [Observable<(ResultMatch, BrandProfile)>] = filteredResultMatches.map({ (resultMatch) in
            let brandId = resultMatch.brandId!
            return restClient.request(API.getBrandProfile(brandId: brandId)).flatMap({(brandProfile) in
                return Single<(ResultMatch, BrandProfile)>.create { (observer) in
                    
                    if brandProfile.capacity != 1{
                        observer(SingleEvent.error(InletClientError.emptyResponse))
                    } else {
                        observer(SingleEvent.success((resultMatch, brandProfile.first!)))
                    }
                    return Disposables.create {}
                }
            }).asObservable()
        })
        return Observable.zip(brandProfileObservables);
    }
    
    public func getData2(userAttributes: [UserAttribute: String]) -> Observable<InletData> {
        let restClient = RESTClient(username: username, password: password)
        
        let discoveryConsentsSequence =
            restClient
            .request(API.getDiscoveryConsents())
        
        let discoveryProfileSequence =
            discoveryConsentsSequence.flatMap({ (discoveryConsents) in
            return restClient
                .request(API.putDiscoveryProfile2(
                    discoveryConsents: discoveryConsents,
                    userAttributes: userAttributes)
            )
        })
        
        let getMailboxSequence: PrimitiveSequence<SingleTrait, Mailbox> =
        discoveryProfileSequence.flatMap({ (discoveryProfile) in
            return restClient
                .request(API.getMailbox2(discoveryProfile: discoveryProfile))
        })
        
        let brandProfilesSequence =
            discoveryProfileSequence.flatMap({ (discoveryProfile) -> PrimitiveSequence<SingleTrait, [(ResultMatch, BrandProfile)]> in
                
                let single = Single<[(ResultMatch, BrandProfile)]>.create { (observer) in
                    _ = Inletclient.getBrandProfileObservables(
                        restClient: restClient, userAttributes: userAttributes,
                        discoveryProfile: discoveryProfile)
                        .subscribe(
                        onNext: { (data) in
                            observer(SingleEvent.success(data))
                        },
                        onError: { (error) in
                            observer(SingleEvent.error(error))
                        }
                    )
                    
                    return Disposables.create {
                        
                    }
                    
                }
                return single
                
            })
        
        let dependencies = Observable.combineLatest(
            discoveryConsentsSequence.asObservable(),
            discoveryProfileSequence.asObservable(),
            brandProfilesSequence.asObservable(),
            getMailboxSequence.asObservable()
        )
        return dependencies.asObservable()
    }
}
