//
//  Constantes.swift
//  Alamofire
//
//  Created by icaceres on 25/03/22.
//

public enum ZyTApiErrorEnum:Int {
    case EXITO = 8000
    case ERROR_VALIDATION = 2000
    case ERROR_UNSPECIFIED = 2001
    case BADREQUEST = 400
    case INTERNAL_SERVER = 500
    case UNAUTHORIZED = 401
    case FORBIDDEN = 403
    case NOTFOUND = 404
    
    var descripcion:String {
        switch self {
        case .EXITO:
            return "8000:Exito"
        case .BADREQUEST:
            return "400:No se puede procesar la petición"
        case .UNAUTHORIZED:
            return "401:Credenciales no válidas de autenticación"
        case .FORBIDDEN:
            return "403:Acceso denegado"
        case .NOTFOUND:
            return "404:No se puede encontrar el recurso solicitado"
        case .INTERNAL_SERVER:
            return "500:Error Interno del Servidor"
        default:
            return ""
        }
    }
}


public func tipoDocToDni(tipoDocInput:String ) -> String{
    
    switch(tipoDocInput){
    case "4":
        return "PASAPORTE"
    case "2":
        return "CARNET_EXTRANJERIA"
    default:
        return "DNI"
    }
    
    
    
}

public func versionLibreria() -> String {
    
    return  "{\"product\": \"BiometriaMovil-Facial-fpay\",\"vendor\":\"Zytrust S.A\",\"version\":\"0.9.7\",\"dependencies\":{\"SdkFacial\":{\"product\":\"SDK_ANDROID_FACIAL\",\"vendor\":\"IDEMIA\",\"version\":\"4.34.1\"},\"SdkOcr\":{\"product\":\"SDK_ANDROID_OCRL\",\"vendor\":\"BECOME\",\"version\":\"7.1.5\"}}}"
    
   
}
