//
//  ZyTOauthClient.swift
//  zy_fpay_validacionfacial_lib_ios
//
//  Created by Edwin on 05/03/2022.
//

import Foundation

class ZyTOauthClient {
    
    static var shared: ZyTOauthClient = {
        let instance = ZyTOauthClient()
        // ... configure the instance
        // ...
        return instance
    }()
    
    private init() {}
    
    func autenticar(completion: @escaping (ZyTApiResult<String, ZyTApiError>) -> Void) {
        
        ZyAlamofireApi.shared.executeWith(request: ZyTEndpointOauth.autenticar)
        { (result:ZyTApiResult<ZyTAuthResponse,ZyTApiError>) in
            
            switch result {
            case .success(let authResponse):
                guard let token = authResponse.access_token else{
                    print("token blank..")
                    completion(.success(""))
                    return
                }
                LoginSetting.token = token
                completion(.success(token))
            case .error(let error):
                completion(.error(error))
            }
        }
    }
}
