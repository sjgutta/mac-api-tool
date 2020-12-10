//
//  File.swift
//  Mac API Tool
//
//  Created by Sajan  Gutta on 12/9/20.
//

import Foundation

extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}

extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}

func doRequest(url: String, auth_params: Dictionary<String, String>, params: Dictionary<String, String>, type: RequestType, completionBlock: @escaping (CustomResponse) -> CustomResponse) -> URLSessionTask {
    let urlComp = NSURLComponents(string: url)!
        
    var items = [URLQueryItem]()
        
    for (key,value) in auth_params {
        items.append(URLQueryItem(name: key, value: value))
    }
    
    if type == RequestType.get {
        for (key,value) in params {
            items.append(URLQueryItem(name: key, value: value))
        }
    }

    items = items.filter{!$0.name.isEmpty}

    if !items.isEmpty {
      urlComp.queryItems = items
    }

    var request = URLRequest(url: urlComp.url!)
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.httpMethod = type.rawValue
    
    if type != RequestType.get {
        request.httpBody = params.percentEncoded()
    }
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data,
            let response = response as? HTTPURLResponse,
            error == nil else {
            // check for fundamental networking error
            let result = CustomResponse(status: "ERROR", data: "An error occurred")
            completionBlock(result)
            return
        }
        
        guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
            let result = CustomResponse(status: response.statusCode, data: String(data: data, encoding: .utf8)! as NSString)
            completionBlock(result)
            return
        }
                
        let result = CustomResponse(status: response.statusCode, data: data.prettyPrintedJSONString!, error: false)
        completionBlock(result)
    }
    task.resume()
    return task
}
