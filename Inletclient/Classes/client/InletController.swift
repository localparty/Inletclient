import UIKit
import Alamofire
import RxSwift
import RxCocoa
import Inletclient

public struct ClientParameters {
    let inletCustomer: InletCustomer
    let minConfidenceLevel: Int
    let partnerChannelId: String
    public init(
        inletCustomer: InletCustomer,
        minConfidenceLevel: Int,
        partnerChannelId: String) {
        self.inletCustomer = inletCustomer
        self.minConfidenceLevel = minConfidenceLevel
        self.partnerChannelId = partnerChannelId
    }
}

public typealias InletDataSingle = Single<(discoveryConsents: DiscoveryConsents, discoveryProfile: DiscoveryProfile, mailbox: Mailbox, brandProfiles: [(ResultMatch, BrandProfile)])>

public class InletController {
    
    public enum InletClientError: Error {
        case emptyResponse
    }
    
    let restClient: RESTClient
    let clientParameters: ClientParameters
    
    public init(
        restClient: RESTClient,
        clientParameters: ClientParameters
        ){
        self.restClient = restClient
        self.clientParameters = clientParameters
    }
    
    public func getBrandProfilesObservablesZip (
        discoveryProfile: DiscoveryProfile
        ) -> Observable<[(ResultMatch, BrandProfile)]> {
        
        let filteredResultMatches: [ResultMatch] = (discoveryProfile.resultMatch ?? [] as! [ResultMatch]).compactMap({ (resultMatch) in
            guard resultMatch.confidenceLevel != nil else {
                print("missing confidence level–> \(resultMatch)")
                return nil
            }
            guard resultMatch.confidenceLevel! >= clientParameters.minConfidenceLevel else {
                print("confidence level is not sufficient– \(resultMatch.confidenceLevel!)")
                return nil
            }
            return resultMatch
        })
        
        let observables: [Observable<(ResultMatch, BrandProfile)>] = filteredResultMatches.map { (resultMatch) -> Observable<(ResultMatch, BrandProfile)> in
            let brandId = resultMatch.brandId!
            let observable: Observable<(ResultMatch, BrandProfile)> =
            restClient.request(API.getBrandProfile(brandId: brandId)).flatMap { (brandProfile) in
                return Single<(ResultMatch, BrandProfile)>.create { (observer) in
                    if brandProfile.capacity != 1{
                        observer(SingleEvent.error(InletClientError.emptyResponse))
                    } else {
                        observer(SingleEvent.success((resultMatch, brandProfile.first!)))
                    }
                    return Disposables.create {}
                }
            }.asObservable()
            return observable
        }
        let observablesZip = Observable.zip(observables)
        return observablesZip
    }
    
    public typealias DiscoveryConsentsSingle = Single<DiscoveryConsents>
    
    private func getDiscoveryConsentsSingle () -> DiscoveryConsentsSingle {
        return restClient.request(API.getDiscoveryConsents())
    }
    public typealias DiscoveryProfileSingle = Single<(discoveryConsents: DiscoveryConsents, discoveryProfile: DiscoveryProfile)>
    
    private func getDiscoveryProfileSingle (singleOfDiscoveryConsents: DiscoveryConsentsSingle) -> DiscoveryProfileSingle {
        return singleOfDiscoveryConsents.flatMap {
            (discoveryConsents) in
            return DiscoveryProfileSingle.create { (observer) in
                // getting the discovery profile here
                _ = self.restClient
                    .request(API.putDiscoveryProfile(
                        discoveryConsents: discoveryConsents,
                        clientParameters: self.clientParameters))
                    .subscribe(
                        onSuccess: {
                            (discoveryProfile) in
                            observer(.success((discoveryConsents, discoveryProfile)))
                    },
                        onError: {
                            (error) in
                            observer(.error(error))
                    }
                )
                return Disposables.create()
            }
        }
    }
    public typealias MailboxSingle = Single<(discoveryConsents: DiscoveryConsents, discoveryProfile: DiscoveryProfile, mailbox: Mailbox)>
    
    private func getMailboxSingle (singleOfDiscoveryProfile: DiscoveryProfileSingle) -> MailboxSingle {
        return singleOfDiscoveryProfile.flatMap {
            (tuple) in
            return MailboxSingle.create { (observer) in
                // geting the mailbox here
                _ = self.restClient
                    .request(API.getMailbox(discoveryProfile: tuple.discoveryProfile))
                    .subscribe(
                        onSuccess: {
                            (mailbox) in
                            observer(.success((tuple.discoveryConsents, tuple.discoveryProfile, mailbox)))
                    },
                        onError: {
                            (error) in
                            observer(.error(error))
                    }
                )
                return Disposables.create()
            }
        }
    }
    
    public typealias BrandProfilesSingle = Single<(discoveryConsents: DiscoveryConsents, discoveryProfile: DiscoveryProfile, mailbox: Mailbox, brandProfiles: [(ResultMatch, BrandProfile)])>
    
    private func getBrandDetailsSingle (singleOfMailbox: MailboxSingle) -> BrandProfilesSingle {
        return singleOfMailbox.flatMap {
            (tuple) in
            return BrandProfilesSingle.create { (observer) in
                // getting the brand profile tuples here
                _ = self.getBrandProfilesObservablesZip(discoveryProfile: tuple.discoveryProfile)
                    .subscribe(
                        onNext: { (brandProfiles) in
                            observer(.success((tuple.discoveryConsents, tuple.discoveryProfile, tuple.mailbox, brandProfiles)))
                    },
                        onError: {
                            (error) in
                            observer(.error(error))
                    }
                )
                return Disposables.create()
            }
        }
        
    }
    
    public func loadData() -> BrandProfilesSingle {
        let singleOfDiscoveryConsents = getDiscoveryConsentsSingle()
        let singleOfDiscoveryProfile = getDiscoveryProfileSingle(singleOfDiscoveryConsents: singleOfDiscoveryConsents)
        let singleOfMailbox = getMailboxSingle(singleOfDiscoveryProfile: singleOfDiscoveryProfile)
        let singleOfBrandDetails = getBrandDetailsSingle(singleOfMailbox: singleOfMailbox)
        
        return singleOfBrandDetails
    }
}
