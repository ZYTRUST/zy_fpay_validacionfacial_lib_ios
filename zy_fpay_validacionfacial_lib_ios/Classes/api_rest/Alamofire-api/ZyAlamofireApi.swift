//
//  ZyAlamofireApi.swift
//  zy_fpay_validacionfacial_lib_ios
//
//  Created by Edwin on 05/03/2022.
//

import Foundation


// RESULTADO GENERICO
enum ZyTApiResult <T, E> {
    case success(T)
    case error(E)
}

// ERROR
struct ZyTApiError {
    var coError:Int?
    var deError:String?
    var data:ProcesarCrossData?
    init (coError:Int = 0 , deError:String? = nil , data:ProcesarCrossData? = nil){
        self.coError = coError
        self.deError = deError
        self.data = data
    }
}

enum HTTPHeaderFields: String {
    case authorization  = "Authorization"
    case contentType    = "Content-Type"
    case acceptType     = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case requestName    = "RequestName"
}
enum ContentType: String {
    case json = "application/json"
}

class ZyAlamofireApi{
    
    /// The static field that controls the access to the singleton instance.
    ///
    /// This implementation let you extend the Singleton class while keeping
    /// just one instance of each subclass around.
    static var shared: ZyAlamofireApi = {
        let instance = ZyAlamofireApi()
        // ... configure the instance
        // ...
        return instance
    }()
    
    /// The Singleton's initializer should always be private to prevent direct
    /// construction calls with the `new` operator.
    private init() {}
    
    let session = Session()
    
    func executeWith<T:Decodable>(request: URLRequestConvertible,
                                  completion: @escaping (ZyTApiResult<T,ZyTApiError>) -> Void) {
        let interceptor = ZyTRequestInterceptor()
        interceptor.retryLimit = 2
        print("🌐","====>>>> Inicio WS REQUEST")
        session.request(request, interceptor: interceptor)
            .validate()
            .responseDecodable(of: T.self)
        {
            response in
            print("====>>>> Response in executeWith : \(response)")
            switch response.result {
            case .success(let obj):
                print("🌐","====>>>> FIN SUCCESS WS REQUEST")
                completion(.success(obj))
                break
                
            case .failure(let error):
                print("🌐","====>>>> FIN FAILURE WS REQUEST")

                switch error {
                    
                case .sessionTaskFailed(let nsError as NSError):
                    print("📶","Analisis Internet🗿: code: \(nsError.code)")
                    print("📶","Analisis Internet🗿: description:\(nsError.localizedDescription)")
                    guard case let errorCodeObtein = nsError.code else {
                        completion(.error(ZyTApiError(coError: ZyErrorWebService.ERROR_UNSPECIFIED.rawValue,
                                                      deError: error.localizedDescription,
                                                      data: nil)))
                        return
                    }
                    switch (errorCodeObtein){
                    case (-1001):
                        let zyerror = ZyTApiError(coError: 9111, deError: "9111:token expirado o no válido ", data: nil)
                        completion(.error(zyerror))
                        return
                    case (-1020):
                        let zyerror = ZyTApiError(coError: 9113, deError: "9113:No tiene conexiòn a internet ", data: nil)
                        completion(.error(zyerror))
                        return
                    case (-1009):
                        let zyerror = ZyTApiError(coError: 9112, deError: "9112:Conexion a Internet inestable , por favor vuelva a intentarlo ", data: nil)
                        completion(.error(zyerror))
                        return
                    default:
                        completion(.error(ZyTApiError(coError: nsError.code,
                                                      deError: nsError.localizedDescription, data: nil)))
                        return
                    }
                                        
                case .responseValidationFailed(let reason):
                    switch reason {
                    case .unacceptableStatusCode(let code):
                        var apiError:ZyTApiError
                        switch code {
                        case 400:
                            apiError = ZyTApiError(coError: ZyErrorWebService.BADREQUEST.rawValue,
                                                   deError: ZyErrorWebService.BADREQUEST.descripcion,
                                                   data: nil)
                            break
                        case 401:
                            apiError = ZyTApiError(coError: 9111,
                                                   deError: "9111:token expirado o no válido ",
                                                   data: nil)
                            break
                        case 403:
                            apiError = ZyTApiError(coError: ZyErrorWebService.FORBIDDEN.rawValue,
                                                   deError: ZyErrorWebService.FORBIDDEN.descripcion,
                                                   data: nil)
                            break
                        case 404:
                            apiError = ZyTApiError(coError: ZyErrorWebService.NOTFOUND.rawValue,
                                                   deError: ZyErrorWebService.NOTFOUND.descripcion,
                                                   data: nil)
                            break
                        case 500:
                            apiError = ZyTApiError(coError: ZyErrorWebService.INTERNAL_SERVER.rawValue,
                                                   deError: ZyErrorWebService.INTERNAL_SERVER.descripcion,
                                                   data: nil)
                            break
                            
                        default:
                            apiError = ZyTApiError(coError: code,
                                                   deError: error.localizedDescription,
                                                   data: nil)
                            break
                        }
                        completion(.error(apiError))
                        break
                    default:
                        completion(.error(ZyTApiError(coError: ZyErrorWebService.ERROR_VALIDATION.rawValue,
                                                      deError: error.localizedDescription,data: nil)))
                        break
                    }
                    
                default:
                    print("🌍 📶","Zy  default ERROR_UNSPECIFIED")
                    
                    completion(.error(ZyTApiError(coError: ZyErrorWebService.ERROR_UNSPECIFIED.rawValue,
                                                  deError: error.localizedDescription,
                                                  data: nil)))
                    break
                }
                
            default:
                print("🌐","====>>> zy default Analityc Service error")
                completion(.error(ZyTApiError(coError: ZyErrorWebService.ERROR_UNSPECIFIED.rawValue,
                                              deError: ZyErrorWebService.ERROR_UNSPECIFIED.descripcion,
                                              data: nil)))
                break
            }
            
        }
    }
}


