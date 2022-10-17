//
//  APIInterceptor.swift
//  zy-onefinger-ios
//
//  Created by Edwin on 07/22/2020.
//  Copyright © 2020 Edwin. All rights reserved.
//

import Foundation

class ZyTRequestInterceptor: RequestInterceptor {
    
    // Retry your request by providing the retryLimit. Used to break the flow if we get repeated 401 error
    var retryLimit = 0

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {

        print ("====>>> func retry en ZyTRequestInterceptor ")
        guard let statusCode = request.response?.statusCode else {
            print("📲","====>>> zy statusCode: \(request.response?.statusCode)")
            print("📲","====>>> zy error: \(error)")
            print("📲","====>>> zy errorlocalizedDescription: \(error.localizedDescription)")
            //completion(.doNotRetryWithError(error))
            completion(.doNotRetry)
            return
        }
        switch statusCode {
        case 200...299:
            print("🟡","===>> zy_Retries: Server response OK")
            completion(.doNotRetry)
        default:
            print("🟡","===>> Init zy_Retries WS SERVER Connection")
            if ((request.retryCount) < retryLimit ){
                print("🟡","===>> zy_Retries: Reintento \(request.retryCount + 1) de \(retryLimit)")
                completion(.retry)
                return
            }
            print("🟡","===>> zy_Retries: doNotRetry")
            completion(.doNotRetry)
        }
    }
    
    
    //This method is called on every API call, check if a request has to be modified optionally
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        //Add any extra headers here
        /*aqui se agrega el Token
         para realizar los intentos con el interceptor
         */
        print ("====>>> func adapt en ZyTRequestInterceptor")
        var zyurlRequest = urlRequest
        
        let zyToken = "bearer " + LoginSetting.token
        #if DEBUG
        print("🟡","=====>>>> zyToken: \(zyToken)")
        #endif
        zyurlRequest.addValue(zyToken, forHTTPHeaderField: "Authorization")

        completion(.success(zyurlRequest))
        
    }
}
