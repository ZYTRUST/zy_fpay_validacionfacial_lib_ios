//
//  ZyTEdgeClient.swift
//  zy_fpay_validacionfacial_lib_ios
//
//  Created by Edwin on 05/03/2022.
//

import Foundation

class ZyTEdgeClient {
    
    static var shared: ZyTEdgeClient = {
        let instance = ZyTEdgeClient()
        // ... configure the instance
        // ...
        return instance
    }()
    
    private init() {}
    
    
    func generarSolicitudExpediente(request:SolicitudCrossRequest,
                                    completion: @escaping (ZyTApiResult<SolicitudCrossData, ZyTApiError>) -> Void){
        ZyAlamofireApi.shared.executeWith(request: ZyTEndpointEdge.generarSolicitud(request: request))
        { (result:ZyTApiResult<SolicitudCrossResponse, ZyTApiError>) in
            
            switch result {
            case .success(let response):
                
                guard response.codigo==ZyErrorWebService.EXITO.rawValue,
                      let data=response.data else{
                    
                    let error = ZyTApiError(coError: response.codigo,
                                            deError: response.mensaje, data: nil)
                    
                    completion(.error(error))
                    return
                }
                let json = EncryptUtil.zyDecrypt(jsonText: data)
                
                let resultObj: SolicitudCrossData = try! JSONDecoder().decode(SolicitudCrossData.self, from: json.data(using: String.Encoding.ascii)!)
                print("resultObj \(resultObj)")
                
                completion(.success(resultObj))
                
            case .error(let error):
                print("ZyTEdgeClient error \(error.deError)")
                completion(.error(error))
            }
        }
    }
    
    func procesarFlujo(request:ProcesarCrossRequest,
                       completion: @escaping (ZyTApiResult<ProcesarCrossData, ZyTApiError>) -> Void){
        ZyAlamofireApi.shared.executeWith(request: ZyTEndpointEdge.procesar(request: request))
        { (result:ZyTApiResult<ProcesarCrossResponse, ZyTApiError>) in
            
            switch result {
            case .success(let response):
                
                print("Mostrar 1er Nivel SOLICITUD BLOQUEADA codigo:\(response.codigo)")
                print("Mostrar 1er Nivel SOLICITUD BLOQUEADA error: \(response.error)")
                print("Mostrar 1er Nivel SOLICITUD BLOQUEADA mensaje: \(response.mensaje)")
                
                
                if (response.data == nil){
                    print("===>> Analisis 1er Nivel onError, DATA NULL")
                    let error = ZyTApiError(coError: response.codigo,
                                            deError: response.mensaje,
                                            data: nil)
                    completion(.error(error))
                    return
                }
                
                
                let json = EncryptUtil.zyDecrypt(jsonText: response.data!)
                let resultObj: ProcesarCrossData = try! JSONDecoder().decode(ProcesarCrossData.self, from: json.data(using: String.Encoding.utf8)!)
                print ("=======>>>>>> WS OBJ RESULTADO  :::::")
                print ("=======>>>>>> WS OBJ RESULTADO  :::::")
                print ("=======>>>>>> WS OBJ RESULTADO  :::::")
                print ("WS_OBJ_RESULTADO: \(resultObj)")
                
                if (resultObj.bmoComponenteResponseDto != nil){
                    print("⏭" ,"===>> bmoCompId: \(String(describing: resultObj.bmoComponenteResponseDto?.bmoCompId))")
                }
                
                
                if(response.codigo == ZyErrorUi.ERROR_SOLICITUD_BLOQUEADA.rawValue ||
                   response.codigo == 8131 ||
                   response.codigo == 8087 ||
                   response.codigo == 8206 ||
                   response.codigo == 8100 ){
                    let error = ZyTApiError(coError: response.codigo ,
                                            deError: response.mensaje,
                                            data: nil)
                    print("Analisis 1er Nivel error-> onError:\(response.codigo) , \(response.mensaje)")
                    completion(.error(error))
                    return
                }
                
                
                print("Analisis 3er Nivel")
                if (resultObj.codError != nil){
                    if(resultObj.bmoBioResponse != nil){
                        print("Dentro del Analisis 3er Nivel")
                        if (resultObj.bmoBioResponse?.codBioError != "70006") {
                            print("3er nivel -> codBioError: \(resultObj.bmoBioResponse?.codBioError)")
                            
                            let error = ZyTApiError(coError: Int(resultObj.bmoBioResponse?.codBioError ?? "0") ?? 0 ,
                                                    deError: resultObj.bmoBioResponse?.deBioError ?? "",
                                                    data: resultObj)
                            completion(.error(error))
                            return
                        }
                    }
                    print("Analisis 2er Nivel")
                    if ( !(resultObj.codError == "8000" ||  resultObj.codError == "70006")) {
                        print("Dentro 2er nivel -> referencia 1er Nivel -> codigo: \(response.codigo)")
                        print("Dentro 2er nivel -> referencia 1er Nivel -> mensaje: \(response.mensaje)")
                        print("Dentro 2er nivel -> codError: \(resultObj.codError)")
                        switch (response.codigo){
                        case ZyErrorUi.ERROR_SOLICITUD_BLOQUEADA.rawValue:// bloqueo BMO SOLICITUD
                            let error = ZyTApiError(coError: response.codigo ,
                                                    deError: response.mensaje,
                                                    data: resultObj)
                            print("Analisis 2er Nivel SOLICITUD BLOQUEADA onError")
                            completion(.error(error))
                            return
                        default:
                            let error = ZyTApiError(coError: Int(resultObj.codError ?? "0") ?? 0 ,
                                                    deError: resultObj.deError ?? "",
                                                    data: resultObj)
                            print("Analisis 2er Nivel onError")
                            completion(.error(error))
                            return
                        }
                        
                        
                    }
                }
                
                print("Analisis 1er Nivel")
                if response.codigo != ZyErrorWebService.EXITO.rawValue{
                    print("Dentro 1er nivel -> codigo: \(response.codigo)")
                    let error = ZyTApiError(coError: response.codigo,
                                            deError: response.mensaje,
                                            data: resultObj)
                    print("Analisis 1er Nivel onError")
                    completion(.error(error))
                    return
                }
                print("===>>>> Analisis OnSuccess")
                completion(.success(resultObj))
                
                
            case .error(let error):
                
                print("ZyTEdgeClient coError:\(error.coError) ,deError \(error.deError)")
                completion(.error(error))
            }
        }
    }
    
    
}
