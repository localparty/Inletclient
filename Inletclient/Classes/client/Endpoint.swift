import UIKit
import Alamofire
import RxSwift
import RxCocoa

public final class Endpoint<Response> {
    
    let method: Method
    let path: Path
    let bodyParameters: BodyParameters?
    let queryItems: QueryItems?
    let encoding: ParameterEncoding?
    let localResource: String?
    let localResourceType: String?
    let decode: (Data) throws -> Response
    
    
    var headers: Headers? = EndpointConfiguration.defaultHeaders
    var timeoutInterval: TimeInterval? = EndpointConfiguration.timeoutInterval
    
    init(
        method: Method = .get,
        path: Path,
        bodyParameters: BodyParameters? = nil,
        queryItems: QueryItems? = nil,
        headers: Headers? = nil,
        encoding: ParameterEncoding? = JSONEncoding.default,
        localResource: String? = nil,
        localResourceType: String? = nil,
        decode: @escaping (Data) throws -> Response
        ) {
        self.method = method
        self.path = path
        self.bodyParameters = bodyParameters
        self.queryItems = queryItems
        self.encoding = encoding
        self.localResource = localResource
        self.localResourceType = localResourceType
        self.decode = decode
    }
}

extension Endpoint where Response: Swift.Decodable {
    convenience init(
        method: Method = .get,
        path: Path,
        bodyParameters: BodyParameters? = nil,
        queryItems: QueryItems? = nil,
        headers: Headers? = nil,
        localResource: String? = nil,
        localResourceType: String? = nil,
        encoding: ParameterEncoding? = nil
        ) {
        self.init(
            method: method, path: path,
            bodyParameters: bodyParameters,
            queryItems: queryItems,
            encoding: encoding,
            localResource: localResource,
            localResourceType: localResourceType) { jsonData in
            try JSONDecoder().decode(Response.self, from: jsonData)
        }
    }
}

extension Endpoint where Response == Void {
    convenience init(
        method: Method = .get,
        path: Path,
        bodyParameters: BodyParameters? = nil,
        queryItems: QueryItems? = nil
        ) {
        self.init(
            method: method,
            path: path,
            bodyParameters: bodyParameters,
            queryItems: queryItems,
            decode: { result in
                print("void result– \(result)")
            }
        )
    }
}
