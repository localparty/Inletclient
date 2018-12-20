//
//  ViewController.swift
//  InletClient3
//
//  Created by Donkey Donks on 12/4/18.
//  Copyright © 2018 Wells Fargo. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift
import RxCocoa


public enum API {}

extension API {
    // business partner id
    static func channelId () -> String {
        return "CP:0000000149";
    }
}


extension Request {
    public func debugLog() -> Self {
        #if DEBUG
        debugPrint(self)
        #endif
        return self
    }
}

extension DataRequest {
    
    public func validateBodyStatusCode() -> Self {
        let httpResponseSuccessCode = 200
        
        return validate { request,response,data in
            
            if response.statusCode != httpResponseSuccessCode {
                let reason:AFError.ResponseValidationFailureReason = .unacceptableStatusCode(code: response.statusCode)
                return .failure(AFError.responseValidationFailed(reason: reason))
            }
            return .success
        }
    }
}

public protocol ClientProtocol {
    func request<Response>(_ endpoint: Endpoint<Response>) -> Single<Response>
}


public final class Client: ClientProtocol {
    private let baseURL = URL(string: "https://appdelivery.uat.inletdigital.com")!
    private let queue = DispatchQueue(label: "appdelivery.uat.inletdigital.com")
    
    static func initUrlProtectionSpace(user: String, password: String) {
        let upsHost = "appdelivery.uat.inletdigital.com"
        
        let protectionSpace0 = URLProtectionSpace.init(
            host: upsHost,
            port: 80,
            protocol: "http",
            realm: nil,
            authenticationMethod: nil)
        
        let protectionSpace1 = URLProtectionSpace.init(
            host: upsHost,
            port: 443,
            protocol: "https",
            realm: nil,
            authenticationMethod: nil)
        
        let protectionSpace2 = URLProtectionSpace.init(
            host: upsHost,
            port: 443,
            protocol: "htps",
            realm: nil,
            authenticationMethod: nil)
        
        let userCredential = URLCredential(
            user: user,
            password: password,
            persistence: .permanent)
        
        
        URLCredentialStorage.shared.set(userCredential, for: protectionSpace0)
        URLCredentialStorage.shared.set(userCredential, for: protectionSpace1)
        URLCredentialStorage.shared.set(userCredential, for: protectionSpace2)
    }
    
    static func configureProtectionSpace() {
        let upsHost = "appdelivery.uat.inletdigital.com"
        let upsPort = 443
        let upsProtocol = "https"
        let upsAuthenticationMethod:String? = nil
        
        let protectionSpace = URLProtectionSpace.init(
            host: upsHost,
            port: upsPort,
            protocol: upsProtocol,
            realm: nil,
            authenticationMethod: upsAuthenticationMethod)
        
        guard let credential = URLCredentialStorage.shared.defaultCredential(for: protectionSpace) else {
            print("couldn't create credential")
            return;
        }
        
        URLCredentialStorage.shared.setDefaultCredential(credential, for: protectionSpace)
    }
    init() {
        Client.configureProtectionSpace()
    }
    
    static func httpMethod(from method: Method) -> Alamofire.HTTPMethod {
        switch method {
        case .get: return .get
        case .post: return .post
        case .put: return .put
        case .patch: return .patch
        case .delete: return .delete
        }
    }
    
    public func request<Response>(_ endpoint: Endpoint<Response>) -> Single<Response> {
        return Single<Response>.create { observer in
            
            let userNameValue = "$2a$06$YKYwyV3lwnQ.mFNm97XtgOie.oTAOnsh0VQh1UHQ9jbLgyrNfY/1C"
            let passwordValue = "$2a$06$H7RhnGbrHg17E4siBcilwuJTwgyRiYQZAC6GPO0lITc/t/r24ORAC"
            
            Client.initUrlProtectionSpace(user: userNameValue, password: passwordValue)
            
            let urlRequestURL = self.url(path: endpoint.path)
            
            var urlRequest = URLRequest(
                url: urlRequestURL,
                cachePolicy: .useProtocolCachePolicy,
                timeoutInterval: endpoint.timeoutInterval!
            )
            
            urlRequest.httpMethod = Client.httpMethod(from: endpoint.method).rawValue
            urlRequest.allHTTPHeaderFields = endpoint.headers
            urlRequest.timeoutInterval = endpoint.timeoutInterval!
            
            if let parameters:Parameters = endpoint.parameters {
                let postData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
                urlRequest.httpBody = postData as Data
            }
            
            let queue = DispatchQueue(label: "appdelivery.uat.inletdigital.com")
            
            let alamofireRequest: DataRequest? = Alamofire
                .request(urlRequest)
                //.validateBodyStatusCode()
                .validate(statusCode: 200...499)
                .debugLog()
                .authenticate(user: userNameValue, password: passwordValue, persistence: .permanent)
                .responseData(queue: queue) { response in
                    if let data = response.data {
                        let stringData = String(data: data, encoding: .utf8)
                        print("stringData– \(String(describing: stringData))")
                    }
                    let result: Result<Response> = response.result.flatMap(endpoint.decode)
                    
                    switch result {
                    case let .success(val): observer(.success(val))
                    case let .failure(err): observer(.error(err))
                    }
            }
            
            return Disposables.create {
                alamofireRequest?.cancel()
            }
        }
    }
    
    private func url(path: Path) -> URL {
        return baseURL.appendingPathComponent(path)
    }
}

public class EndpointConfiguration {
    static let defaultHeaders: Headers = [
        "Content-Type": "application/json",
        "cache-control": "no-cache"
    ]
    static let timeoutInterval:TimeInterval = 220
}

public typealias Headers = [String: String]
public typealias Parameters = [String: Any]
public typealias Path = String

public enum Method {
    case get, post, put, patch, delete
}

public final class Endpoint<Response> {
    
    let method: Method
    let path: Path
    let parameters: Parameters?
    let encoding: ParameterEncoding?
    let decode: (Data) throws -> Response
    
    var headers: Headers? = EndpointConfiguration.defaultHeaders
    var timeoutInterval: TimeInterval? = EndpointConfiguration.timeoutInterval
    
    init(method: Method = .get,
         path: Path,
         parameters: Parameters? = nil,
         headers: Headers? = nil,
         encoding: ParameterEncoding? = nil,
         decode: @escaping (Data) throws -> Response) {
        self.method = method
        self.path = path
        self.parameters = parameters
        self.encoding = encoding
        self.decode = decode
    }
}

func httpMethod(from method: Method) -> Alamofire.HTTPMethod {
    switch method {
    case .get: return .get
    case .post: return .post
    case .put: return .put
    case .patch: return .patch
    case .delete: return .delete
    }
}

extension Endpoint where Response: Swift.Decodable {
    convenience init(method: Method = .get,
                     path: Path,
                     parameters: Parameters? = nil,
                     headers: Headers? = nil,
                     encoding: ParameterEncoding? = nil) {
        self.init(method: method, path: path, parameters: parameters, encoding: encoding) { jsonData in
            try JSONDecoder().decode(Response.self, from: jsonData)
        }
    }
}

extension Endpoint where Response == Void {
    convenience init(method: Method = .get,
                     path: Path,
                     parameters: Parameters? = nil) {
        self.init(
            method: method,
            path: path,
            parameters: parameters,
            decode: { result in
                print("void result– \(result)")
        }
        )
    }
}

public enum UserAttribute: String {
    case termsConsent
    case inletConsumerId
    case phoneNumber
    case phoneCountryCode
    case zip
    case email
}

public typealias PayWithWfUser = String
public typealias PayWithWfUsers = [PayWithWfUser: [UserAttribute: Any]]
public typealias InletCid = String




public class WfClient {
    
    static let users: PayWithWfUsers = [
        "bill": [
            .termsConsent: false,
            .inletConsumerId: "WFTEST111918A",
            .phoneNumber: "451-555-1111",
            .phoneCountryCode: "1",
            .zip: "94016",
            .email: "wfuser1@email.com"
        ]
    ]
    
}

public enum Inletclient {}

public struct BrandDetails {
    var discoveryConsents: DiscoveryConsents?
    var discoveryProfile: DiscoveryProfile?
    var brandProfiles: [[BrandProfile]]?
}

extension Inletclient {
    public static func getTermsAndConditionsConsent(payWithWfUser: PayWithWfUser) -> Bool? {
        guard WfClient.users[payWithWfUser] != nil &&
            WfClient.users[payWithWfUser]![.termsConsent] != nil else {
                print("couldn't find that user in the Pay With Wells Fargo DB– try again?")
                return nil
        }
        guard WfClient.users[payWithWfUser]![.termsConsent] != nil else {
            print("the database seems to have an empty value for termsConsent– try again?")
            return nil
        }
        return WfClient.users[payWithWfUser]![.termsConsent] as? Bool
    }
    
    public static func getPayees(payWithWfUser: PayWithWfUser, onBrandDetails: ((BrandDetails)->Void)?, onError: ((Error)->Void)?) {
        
        let minConfidenceLevel = 19
        
        let client = Client()
        
        let channelSpecificConsumerId = WfClient.users[payWithWfUser]![.inletConsumerId] as! String
        let zip = WfClient.users[payWithWfUser]![.zip] as! String
        let phoneCountryCode = WfClient.users[payWithWfUser]![.phoneCountryCode] as! String
        let phone = WfClient.users[payWithWfUser]![.phoneNumber] as! String
        let email = WfClient.users[payWithWfUser]![.email] as! String
        
        func onBrandProfiles(
            discoveryConsents: DiscoveryConsents,
            discoveryProfile: DiscoveryProfile,
            brandProfiles: [[BrandProfile]],
            onBrandDetails: ((BrandDetails)->Void)?) -> Void {
            for brandProfileResponse in brandProfiles {
                guard brandProfileResponse.capacity == 1 else {
                    print("got a capacity that is not 1 on brand profile \(String(describing: brandProfileResponse))")
                    return
                }
            }
            
            let brandDetails: BrandDetails = BrandDetails(
                discoveryConsents: discoveryConsents,
                discoveryProfile: discoveryProfile,
                brandProfiles: brandProfiles)
            
            onBrandDetails?(brandDetails)
        }
        
        func onDiscoveryProfile(
            discoveryConsents: DiscoveryConsents,
            discoveryProfile: DiscoveryProfile,
            onBrandDetails: ((BrandDetails)->Void)?
            ){
            
            guard discoveryProfile.resultMatch != nil else {
                print("got a nil result match for discovery profile")
                return
            }
            
            var filteredBrands :[Observable<[BrandProfile]>] = []
            for match in discoveryProfile.resultMatch! {
                if match.confidenceLevel! >= minConfidenceLevel {
                    let brandId = match.brandId
                    let brandRequest = client.request(API.getBrandProfile(brandId: brandId!)).asObservable()
                    filteredBrands.append(brandRequest)
                }
            }
            
            _ = Observable
                .zip(filteredBrands)
                .asObservable()
                .subscribe(onNext: { brandProfiles in
                    onBrandProfiles(
                        discoveryConsents: discoveryConsents,
                        discoveryProfile: discoveryProfile,
                        brandProfiles: brandProfiles,
                        onBrandDetails: onBrandDetails
                    )
                }, onError: onError)
        }
        
        func onDiscoveryConsents(_ discoveryConsents: DiscoveryConsents, onBrandDetails: ((BrandDetails)->Void)?) {
            guard discoveryConsents.consents != nil else {
                print("got a nil result match for discoveryConsents consents")
                return
            }
            
            let consentId:String = discoveryConsents.consents![0].consentId!
            
            _ = client
                .request(API.putDiscoveryProfile(
                    channelSpecificConsumerId: channelSpecificConsumerId,
                    consentId: consentId, zip: zip,
                    phoneCountryCode: phoneCountryCode, phone: phone, email: email))
                .asObservable()
                .subscribe(onNext: { discoveryProfile in
                    onDiscoveryProfile(
                        discoveryConsents: discoveryConsents,
                        discoveryProfile: discoveryProfile,
                        onBrandDetails: onBrandDetails)
                }, onError: onError)
        }
        
        _ = client
            .request(API.getDiscoveryConsents())
            .asObservable()
            .subscribe(onNext: { discoveryConsents in
                onDiscoveryConsents(discoveryConsents, onBrandDetails: onBrandDetails)
            }, onError: onError)
    }
}


