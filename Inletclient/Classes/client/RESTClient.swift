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
        
        return validate { request, response, data in
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

public class GenericError:Error {
    public let name: String
    public let details: String
    init (
        name: String,
        details: String){
        self.name = name
        self.details = details
    }
}

public final class RESTClient: RESTClientProtocol {
    
    public enum Mode: String {
        case inlet
        case bundle
    }
    
    private static func timestampDirectoryPrefix (withDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timestampComponent = dateFormatter.string(from: withDate)
        let uuidComponent = NSUUID().uuidString
        return "\(timestampComponent)–\(uuidComponent)"
    }
    
    public static let inletBundleName = "Inletclient.framework"
    public static let defaultLocalDataDirectory: String = "json"
    public static let defaultBaseURL = "https://appdelivery.uat.inletdigital.com"
    public static let defaultCredentialsValue = "n/a"
    
    private let queue = DispatchQueue(label: "appdelivery.uat.inletdigital.com")
    private let uuid = NSUUID().uuidString
    private let username: String
    private let password: String
    private let dataDirectory: String?
    private let bundle: Bundle?
    private let baseURL: URL
    
    func configureProtectionSpace() {
        let upsHost = self.baseURL.host!
        let upsPort = self.baseURL.port!
        let upsProtocol = self.baseURL.scheme!
        let upsAuthenticationMethod:String = NSURLAuthenticationMethodHTTPDigest
        
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
    
    public static func findBundle(withName: String) -> Bundle? {
        let filterResult = Bundle.allFrameworks
            .compactMap { (bundle) -> (bundle: Bundle, path: String) in
                return (bundle, bundle.bundlePath)
            }
            .compactMap { (tuple) -> (bundle: Bundle, path: String)? in
                if tuple.path.contains(withName) {
                    return (tuple.bundle, tuple.path)
                }
                return nil
        }
        guard filterResult.count == 1 else {
            return nil
        }
        return filterResult.first!.bundle
    }
    
    public init(
        username: String = RESTClient.defaultCredentialsValue,
        password: String = RESTClient.defaultCredentialsValue,
        baseURL: String = RESTClient.defaultBaseURL,
        dataDirectory: String? = nil,
        bundle: Bundle? = nil
        ) {
        self.username = username
        self.password = password
        self.baseURL = URL(string: baseURL)!
        self.dataDirectory = dataDirectory
        self.bundle = bundle
    }
    
    static func alamoFireHttpMethod(from method: Method) -> Alamofire.HTTPMethod {
        switch method {
        case .get: return .get
        case .post: return .post
        case .put: return .put
        case .patch: return .patch
        case .delete: return .delete
        }
    }
    
    private func dumpResponseData <Response>(
        response: DataResponse<Data>,
        endpoint: Endpoint<Response>,
        jsonPathFromEndpoint: String){
        
        guard let data = response.data else {
            return
        }
        
        guard let stringData = String(data: data, encoding: .utf8) else {
            print("couldn't UTF-8 decode the response's data, giving up now :/")
            return
        }
        print("response data– \(stringData)")
        
        guard bundle == nil else {
            return
        }
        
        guard response.response?.statusCode == 200 else {
            print("won't dump the data of a non-200 response :/")
            return
        }
        
        // trying to write the data to a file for debugging and logging
        do {
            let documentsPath =
                NSURL(
                    fileURLWithPath: NSSearchPathForDirectoriesInDomains(
                        .documentDirectory, .userDomainMask, true).first!)
            let logsPath =
                documentsPath
                    .appendingPathComponent(uuid, isDirectory: true)!
                    .appendingPathComponent(jsonPathFromEndpoint)
            
            let filePathUrl =
                logsPath
                    .appendingPathComponent(endpoint.localResource!, isDirectory: false)
                    .appendingPathExtension(endpoint.localResourceType!)
            
            try FileManager.default.createDirectory(
                atPath: logsPath.path,
                withIntermediateDirectories: true, attributes: nil)
            print("created logs directory– \(logsPath)")
            do {
                try stringData.write(to: filePathUrl, atomically: false, encoding: .utf8)
                print("wrote data to file– \(filePathUrl)")
            }
            catch {
                print("couldn't write data file– \(error)")
            }
            
        }
        catch let error as NSError {
            NSLog("couldn't create directory \(error.debugDescription)")
        }
    }
    
    private static func getFileURL<Response>(
        fromBundle bundle: Bundle,
        andfromEndpoint endpoint: Endpoint<Response>,
        andDataDirectory dataDirectory: String) -> URL {
        
        // first we try to find the resource in the main bundle
        let resource = endpoint.localResource
        let resourceType = endpoint.localResourceType
        let resourceDirectory = URL(string: dataDirectory)!
            .appendingPathComponent(endpoint.path, isDirectory: true)
            .path
        let bundleResourcePath = bundle.path(
            forResource: resource,
            ofType: resourceType,
            inDirectory: resourceDirectory
        )
        // if the previous path was nil it means that the bundle couldnt' find the resource
        let bundleResourcePathFileURL = URL(fileURLWithPath: bundleResourcePath!)
        return bundleResourcePathFileURL
    }
    
    private func getDataRequest<Response>(fromEndpoint endpoint: Endpoint<Response>) -> DataRequest {
        guard let bundle = bundle else {
            // i.e. inline mode
            var urlFromEndpointAndBasePath: URL
            
            if let urlParameters = endpoint.queryItems {
                let queryItems: [URLQueryItem] =
                    urlParameters.map { (key: String, value: String) -> URLQueryItem in
                    return URLQueryItem(name: key, value: value)
                }
                let urlComps = NSURLComponents(
                    string: urlFromBasePath(appendingPath: endpoint.path).absoluteString)!
                urlComps.queryItems = queryItems
                urlFromEndpointAndBasePath = urlComps.url!
            } else {
                urlFromEndpointAndBasePath = urlFromBasePath(appendingPath: endpoint.path)
            }
            
            var urlRequest = URLRequest(
                url: urlFromEndpointAndBasePath,
                cachePolicy: .useProtocolCachePolicy,
                timeoutInterval: endpoint.timeoutInterval!
            )
            
            urlRequest.httpMethod = RESTClient.alamoFireHttpMethod(from: endpoint.method).rawValue
            urlRequest.allHTTPHeaderFields = endpoint.headers
            urlRequest.timeoutInterval = endpoint.timeoutInterval!
            
            if let parameters:BodyParameters = endpoint.bodyParameters {
                let postData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
                urlRequest.httpBody = postData as Data
            }
            return Alamofire.request(urlRequest)
        }
        
        // i.e. local data mode
        let fileURL = RESTClient.getFileURL(fromBundle: bundle, andfromEndpoint: endpoint, andDataDirectory: dataDirectory!)
        return Alamofire.request(fileURL)
    }
    
    public func request<Response>(_ endpoint: Endpoint<Response>) -> Single<Response> {
        return Single<Response>.create { observer in
            // the following pathes might be used if in writing mode
            let alamofireRequest = self.getDataRequest(fromEndpoint: endpoint)
                .validateResponseStatus()
                .debugLog()
                .authenticate(user: self.username, password: self.password, persistence: .permanent)
                .responseData(queue: self.queue) { response in
                    self.dumpResponseData(
                        response: response,
                        endpoint: endpoint,
                        jsonPathFromEndpoint: endpoint.path)
                    if self.bundle == nil {
                        guard response.response?.statusCode == 200 else {
                            observer(SingleEvent.error(GenericError(
                                name: "error HTTP status",
                                details: "\(String(describing: response.response?.statusCode))")))
                            return
                        }
                    }
                    
                    let result = response.result.flatMap(endpoint.decode)
                    switch result {
                    case let .success(val): observer(.success(val))
                    case let .failure(err): observer(.error(err))
                    }
            }
            
            return Disposables.create {
                alamofireRequest.cancel()
            }
        }
    }
    
    private func urlFromBasePath(appendingPath: Path) -> URL {
        return baseURL.appendingPathComponent(appendingPath)
    }
}

