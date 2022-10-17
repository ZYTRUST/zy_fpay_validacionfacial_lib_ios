//
//  ZyTEndpointOauth.swift
//  zy_fpay_validacionfacial_lib_ios
//
//  Created by Edwin on 05/03/2022.
//

import Foundation

enum ZyTEndpointOauth: URLRequestConvertible {
    
    case autenticar
    
    var method: HTTPMethod {
        switch self {
            case .autenticar:
                return .post
        }
    }
    
    var path: String {
        switch self {
            case .autenticar:
                return ZyTApiConstantes.path_auth
        }
    }
    
    var parameter : [String:Any]{
        var paramDict : [String: Any] = [:]
        
        switch self {
            case .autenticar:
                
                paramDict["username"] = LoginSetting.usuario
                paramDict["password"] = LoginSetting.passwd
                paramDict["grant_type"] = "password"
                
                return paramDict
        }
    }
    
    var headers:[String:String]{
        switch self {
        case .autenticar:
            let credentialData =
            "\(LoginSetting.ruc):\(ZyTApiConstantes.passwd)".data(using: String.Encoding.utf8)!
            //print("\(LoginSetting.ruc):\(ZyTApiConstantes.passwd)")
            
            let base64Credentials = credentialData.base64EncodedString(options: [])
            return [HTTPHeaderFields.authorization.rawValue: "Basic \(base64Credentials)"]
        }
    }
    var encoding: ParameterEncoding {
        switch self {
            case .autenticar:
                return URLEncoding.default
                //return JSONEncoding.prettyPrinted
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        
        var url = try ZyTApiConstantes.baseURL.asURL()
        let finalPath = path
    
        var config: [String: Any]?
                
        if let infoPlistPath = Bundle.main.url(forResource: "Info", withExtension: "plist") {
            do {
                let infoPlistData = try Data(contentsOf: infoPlistPath)
                
                if let dict = try PropertyListSerialization.propertyList(from: infoPlistData, options: [], format: nil) as? [String: Any] {
                    config = dict
                }
            } catch {
                print(error)
            }
        }
  
        if (config?["zyUrl"] != nil){
            let nurl = config?["zyUrl"] as? String
            url = try nurl!.asURL()
        }
        print("========>>> URL <<=================")
        print("========>>> URL <<=================")
        print("========>>> URL <<=================")
        print("========>>> URL <<=================")
        print("========>>>>NEW URL: \(url)")
        
        var request = URLRequest(url: url.appendingPathComponent(finalPath))
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(ZyTApiConstantes.timeoutService)
        
        /// Get the header data
        request.allHTTPHeaderFields = headers

        print("URL \(url)\(path)")
        print("HEADER \(String(describing: request.allHTTPHeaderFields))")
        print("PARAMETERS \n \(parameter)")
        
        return try encoding.encode(request, with: parameter)
    }
}
