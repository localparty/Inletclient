import UIKit
import Alamofire
import RxSwift
import RxCocoa

extension Request {
    public func debugLog() -> Self {
        #if DEBUG
        debugPrint(self)
        #endif
        return self
    }
}

extension DataRequest {
    
    public func validateResponseStatus() -> Self {
        let validResponseCodes = [200, 401]
        
        return validate { request,response,data in
            var responseCodeIsValid = false
            let responseStatusCode = response.statusCode
            
            print("response status code– \(responseStatusCode)")
            
            for validResponseCode in validResponseCodes {
                if responseStatusCode == validResponseCode {
                    responseCodeIsValid = true
                    break
                }
            }
            if !responseCodeIsValid {
                let reason:AFError.ResponseValidationFailureReason = .unacceptableStatusCode(code: responseStatusCode)
                return .failure(AFError.responseValidationFailed(reason: reason))
            } else {
                return .success
            }
        }
    }
}

public protocol RESTClientProtocol {
    func request<Response>(_ endpoint: Endpoint<Response>) -> Single<Response>
}


public final class RESTClient: RESTClientProtocol {
    public enum Mode: String {
        case inlet
        case bundle
    }
    
    public static let localResourcedDirectoryName = "json"
    
    private let queue = DispatchQueue(label: "appdelivery.uat.inletdigital.com")
    private let baseURL = URL(string: "https://appdelivery.uat.inletdigital.com")!
    private let username: String
    private let password: String
    private let mode: Mode
    
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
    
    private static let inletBundleName = "Inletclient.framework"
    private static func inletBundle() -> Bundle? {
        let filterResult = Bundle.allFrameworks
            .compactMap { (bundle) -> (bundle: Bundle, path: String) in
                return (bundle, bundle.bundlePath)
            }
            .compactMap { (tuple) -> (bundle: Bundle, path: String)? in
                if tuple.path.contains(inletBundleName) {
                    return (tuple.bundle, tuple.path)
                }
                return nil
        }
        guard filterResult.count == 1 else {
            return nil
        }
        return filterResult.first!.bundle
    }
    private static func inletBundlePath(forResource: String, ofType: String) -> String? {
        let filterResult = Bundle.allFrameworks
            .compactMap { (bundle) -> (bundle: Bundle, path: String) in
                return (bundle, bundle.bundlePath)
            }
            .compactMap { (tuple) -> (bundle: Bundle, path: String)? in
                if tuple.path.contains(inletBundleName) {
                    return (tuple.bundle, tuple.path)
                }
                return nil
        }
        guard filterResult.count == 1 else {
            return nil
        }
        let bundle: Bundle = filterResult.first!.bundle
        return bundle.path(forResource: forResource, ofType: ofType)
    }
    
    private static func inletBundlePath() -> String? {
        let filterResult = Bundle.allFrameworks
            .compactMap { (bundle) -> (bundle: Bundle, path: String) in
                return (bundle, bundle.bundlePath)
            }
            .compactMap { (tuple) -> (bundle: Bundle, path: String)? in
                if tuple.path.contains(inletBundleName) {
                    return (tuple.bundle, tuple.path)
                }
                return nil
        }
        guard filterResult.count == 1 else {
            return nil
        }
        return filterResult.first?.bundle.bundlePath
    }
    
    public convenience init() {
        self.init(username: "n/a", password: "n/a", mode: .bundle)
    }
    
    public init(
        username: String,
        password: String,
        mode: Mode? = .inlet) {
        RESTClient.configureProtectionSpace()
        self.username = username
        self.password = password
        self.mode = mode!
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
            var alamofireRequest: DataRequest?
            if self.mode == .bundle {
                let directoryPath =
                    URL(fileURLWithPath: RESTClient.localResourcedDirectoryName)
                    .appendingPathComponent(endpoint.path, isDirectory: true)
                    .path
                let inletBundle = RESTClient.inletBundle()
                let inletBundleResource = inletBundle!.path(
                    forResource: endpoint.localResource,
                    ofType: endpoint.localResourceType,
                    inDirectory: directoryPath)
                if inletBundleResource == nil {
                    let debuggingDirectoryPath =
                        URL(fileURLWithPath: (inletBundle?.bundlePath)!)
                            .appendingPathComponent(RESTClient.localResourcedDirectoryName, isDirectory: true)
                            .appendingPathComponent(endpoint.path, isDirectory: true)
                            .appendingPathComponent(endpoint.localResource!, isDirectory: false)
                            .appendingPathExtension(endpoint.localResourceType!)
                            .path
                    print("couldn't find–– \(debuggingDirectoryPath)")
                }
                let localResourceURL = URL(fileURLWithPath: inletBundleResource!)
                alamofireRequest = Alamofire.request(localResourceURL)
            } else {
                let apiURL = self.urlFromBase(withPath: endpoint.path)
                
                var urlRequest = URLRequest(
                    url: apiURL,
                    cachePolicy: .useProtocolCachePolicy,
                    timeoutInterval: endpoint.timeoutInterval!
                )
                
                urlRequest.httpMethod = RESTClient.httpMethod(from: endpoint.method).rawValue
                urlRequest.allHTTPHeaderFields = endpoint.headers
                urlRequest.timeoutInterval = endpoint.timeoutInterval!
                
                if let parameters:Parameters = endpoint.parameters {
                    let postData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
                    urlRequest.httpBody = postData as Data
                }
                alamofireRequest = Alamofire.request(urlRequest)
            }
            
            alamofireRequest = alamofireRequest!
                .validateResponseStatus()
                .debugLog()
                .authenticate(user: self.username, password: self.password, persistence: .permanent)
                .responseData(queue: self.queue) { response in
                    if let data = response.data {
                        let stringData = String(data: data, encoding: .utf8)
                        print("stringData– \(String(describing: stringData))")
                    }
                    let result = response.result.flatMap(endpoint.decode)
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
    
    private func urlFromBase(withPath: Path) -> URL {
        return baseURL.appendingPathComponent(withPath)
    }
}

