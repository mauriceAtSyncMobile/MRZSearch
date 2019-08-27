//
//  NOURLEncoding.swift
//  IdSearch
//
//  Created by Maurice Carrier on 8/27/19.
//

import Alamofire

struct NOURLEncoding: ParameterEncoding {
    
    static let `default` = NOURLEncoding()
    
    /**
     Implements 'ParameterEncoding" protocol
     
     - Parameter urlRequest: URLRequest to be encoded.
     - Parameter parameters: URL parameters to be encoded.
     
     - Throws: 'AFError.parameterEncodingFailed()' if request is not able to be encoded.
     - Returns: An encoded URLRequest
     */
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()
        
        guard let parameters = parameters else { return urlRequest }
        
        if HTTPMethod(rawValue: urlRequest.httpMethod ?? "GET") != nil {
            guard let url = urlRequest.url else {
                throw AFError.parameterEncodingFailed(reason: .missingURL)
            }
            
            if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
                let percentEncodedQuery = (urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + query(parameters)
                urlComponents.percentEncodedQuery = percentEncodedQuery
                urlRequest.url = urlComponents.url
            }
        }
        
        return urlRequest
    }
    
    /**
     Appends query parameters into a single string value.
     
     - Parameter parameters: Values to be appended into a string
     
     - Returns: 'String' of encoded parameters.
     */
    private func query(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []
        
        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(fromKey: key, value: value)
        }
        
        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }
    
    /**
     Defines Alamofire parameters for query component handling.
     
     - Parameter key: String value used to define query component
     - Parameter value: Any object to be appended to the query component array.
     
     - Returns: An array of keyed query component tuples.
     */
    public func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        
        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
            }
        } else if let array = value as? [Any] {
            for value in array {
                components += queryComponents(fromKey: "\(key)[]", value: value)
            }
        } else if let value = value as? NSNumber {
            if value.isBool {
                components.append((escape(key), escape((value.boolValue ? "1" : "0"))))
            } else {
                components.append((escape(key), escape("\(value)")))
            }
        } else if let bool = value as? Bool {
            components.append((escape(key), escape((bool ? "1" : "0"))))
        } else {
            components.append((escape(key), escape("\(value)")))
        }
        
        return components
    }
    
    /**
     Defines which symbols will be escaped and returns an escaped string.
     
     - Parameter string: String to be escaped.
     
     - Returns: Escaped string based on embedded delimeters.
     */
    public func escape(_ string: String) -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*,;="
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        
        var escaped = ""
        
        escaped = string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
        
        return escaped
    }
    
}

extension NSNumber {
    fileprivate var isBool: Bool { return CFBooleanGetTypeID() == CFGetTypeID(self) }
}
