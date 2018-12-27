import UIKit
import Alamofire
import RxSwift
import RxCocoa

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
