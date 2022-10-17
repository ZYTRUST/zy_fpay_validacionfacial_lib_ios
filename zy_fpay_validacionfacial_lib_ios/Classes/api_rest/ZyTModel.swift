//
//  ZyTModel.swift
//  zy-onefinger-ios
//
//  Created by Edwin on 07/27/2020.
//  Copyright © 2020 Edwin. All rights reserved.
//

import Foundation

struct ZyTApiConstantes{
    static let baseURL = "https://dev2.zytrust.com"
    //static let user = "20330401991"
    static let passwd = "!A@hwpwU22YzXDT&Gt"
    static let grant_type = "password"
    static let access_token = "access_token"
    static let credentials = "credentials"
    static let retries = 2
    static let timeoutService = 60
    static let path_auth = "/ztgateway/oauth-server/oauth/token"
    static let path_solicitud = "/ztgateway/biomatch-finger-server/api/solicitud/v1/nueva"
    static let path_configuracion = "/ztgateway/biomatch-finger-server/api/touchless/v1/config"
    static let path_intento_registro = "/ztgateway/biomatch-finger-server/api/touchless/v1/intento/registro"
    static let path_mejor_huella = "/ztgateway/mejorhuella-server/api/mejorhuella/v1.1/consulta"
    static let path_verifica_reniec = "/ztgateway/biogateway-server/api/verificacion/v1.1/cliente"
    static let path_mejor_huella_finger_Server = "/ztgateway/biomatch-finger-server/api/mejorhuella/v1/consulta/true"
    static let path_obtenerConfig_qapaq = "/ztgateway/biomatch-one-server/api/v1/configuraciones/faciales"
    static let path_regitraIntentoQapaq = "/ztgateway/biomatch-one-server/api/v1/configuraciones/faciales/registroIntento"
    static let path_verificacionFacialQapaq = "/ztgateway/biomatch-one-server/api/biomatchone/v1/procesar"
    static let path_configQapaqEncrypted = "/ztgateway/bmo-edge-server/api/bmo/v2/configuraciones/faciales"
    static let path_regitraIntentoQapaqEncryptedEncrypted = "/ztgateway/bmo-edge-server/api/bmo/v3/intentos"
    static let path_verificacionFacialQapaqEncrypted = "/ztgateway/bmo-edge-server/api/bmo/v2/verificacion"
    static let path_generaSolicitudBmo = "/ztgateway/biomatch-one-server/api/biomatchone/v1/procesar"
    
    //******************** EDGE-SERVER *********************
    static let path_solicitud_edge = "/ztgateway/bmo-edge-server/api/bmo/v1/generar"
    static let path_procesar_edge = "/ztgateway/bmo-edge-server/api/bmo/v2/procesar/flujo/cross"
    //******************************************************
    
    static let path_mejor_huella_fingerserver =
        "/ztgateway/biomatch-finger-server/api/mejorhuella/v1/consulta/true"
    
    static let path_verifica_reniec_fingerserver =
        "/ztgateway/biomatch-finger-server/api/cotejo/v1/verifica/identidad"

    
    static let pk_hex = "75C21899E6267FD2A9C43B84A3C67196D67491EAB8D2AD489D7AC51DB5DBDCA923D9D3E02F5B3F979FB87354B06D47A573E594C670AC3798552C69187AD2D3FD47DBB9E69FD5B1B584FC06CF3B49923632D360BF83D0B00E24FE67C549216CDAB09D9EE14BE24FE9CDA8F59E81693C31"
}

enum ZyErrorWebService:Int {
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




// SOLICITUD
struct ZyTSolicitudResponse : Decodable {
    let error:String?
    let codigo:Int
    let mensaje:String
    let data:ZyTSolicitudData?
}
struct ZyTSolicitudData: Decodable{
    let bioCodError:String
    let bioDeError:String
    let idTxn:String
    let nuSolicitud:String
}

// SOLICITUD BMO
struct ZyTSolicitudBMOResponse : Decodable {
    let error:String?
    let codigo:Int
    let mensaje:String
    let data:ZyTSolicitudBMOData?
}
struct ZyTSolicitudBMOData: Decodable{
    let bmoIdSolicitud:Int
    let bmoTsolId:Int
}


// ObtenerconfigQAPAQ
struct ZyTObtenerConfigQapaqResponse : Decodable {
    let error:String?
    let codigo:Int
    let mensaje:String
    let data:ZyTObtenerConfigData?
}
struct ZyTObtenerConfigData: Decodable{
    let soliId:Int
    let soliUrlRedirectFinProceso:String
    let soliInVerificacion:Int
    let soliInFirmado:Int
    let soliFlagFlujoEncriptado:Bool?
    let soliInFinProceso:Bool
    var soliClientes:[ZyTSoliClientesData] = []
}

struct ZyTSoliClientesData: Decodable{
    let soliCliTiDoc:String
    let soliCliNuDoc:String
    let soliCliConfiguracion:ZyTSoliCliConfiguracionData?
}

struct ZyTSoliCliConfiguracionData: Decodable{
    let configAppLvnNivelSeguridad:String
    let configAppLvnTimeout:Int
    let configAppLvnTipoReto:String
    let configAppLvnNumeroPuntos:Int
    let configAppLvnNumeroIntentos:Int
    let configAppTipoBiometria:Int
    let configNumeroSolicitud:String
    
}


// ObtenerconfigQAPAQEncrypted
struct ZyTEncryptedResponse : Decodable {
    let error:String?
    let codigo:Int
    let mensaje:String
    let data:String?
}

// RegistroIntento QAPAQ
struct ZyTRegistroIntentoBMOResponse : Decodable {
    let codigo:Int
    let mensaje:String
}

// Verificacion Facial QAPAQ
struct ZyTVerficacionFacialQapaqResponse : Decodable {
    let error:String?
    let codigo:Int
    let mensaje:String
    let data:ZyTVerificacionFacialData?
}
struct ZyTVerificacionFacialData: Decodable{
    let bmoIdSolicitud:Int
    let bmoTsolId:Int
    let bmoBioResponse:ZyTbmoBioResponseData?
}
struct ZyTbmoBioResponseData: Decodable{
    let bioCodError:String
    let bioDeError:String
    let bioCodErrorReniec:String
    let bioDeErrorReniec:String
    let bioPreNom:String?
    let bioApPat:String?
    let bioApMat:String?
    let bioScore:String
    let bioNuSolicitud:String
    let bioIdTransaccion:String
}

// CONFIGURACION
struct ZyTConfiguracionResponse : Decodable {
    let error:String?
    let codigo:Int
    let mensaje:String
    let data:ZyTConfiguracionData?
}
struct ZyTConfiguracionData: Decodable{
    let appTlessNivelSeguridad:String?
    let appTlessTimeout:String?
    let appBiometriaAlterna:String?
    let appTlessNumeroIntentosDni:String?
    let appDuracionBloqueoDni:String?
    let appTlessNumeroIntentosUuid:String?
    let appDuracionBloqueoUuid:String?
    let numeroIntentosDni:String?
    let estadoBloqueoDni:String?
    let numeroIntentosUuid:String?
    let estadoBloqueoUuid:String?
    let tiDocCliente:String?
    let nuDocCliente:String?
}

// INTENTOS
struct ZyTIntentoResponse:Decodable{
    let error:String?
    let codigo:Int
    let mensaje:String
}

// MEJORES HUELLA
struct APIMejorHuellaResponse:Decodable{
    let codigo:Int
    let errot:String?
    let mensaje:String
    let data:APIMejorHuellaData?
}
struct APIMejorHuellaData:Decodable{
    let id:String?
    let coErrorReniec:Int
    let deErrorReniec:String
    let codDedoDer:Int
    let deDedoDer:String
    let codDedoIzq:Int
    let deDedoIzq:String
    let indicadorMano:String?
}


// VALIDAR HUELLA
struct APIValidaHuellaRequest {
    var tiDocCliente:String
    var nuDocCliente:String
    var idDedoDer:Int
    var wsqDer:String?
    var idDedoIzq:Int
    var wsqIzq:String?
}
struct APIValidaHuellaResponse:Decodable{
    let codigo:Int
    let mensaje:String
    let data:APIValidaHuellaData?
}




// MEJORES HUELLAS FINGER SERVER
struct APIMejorHuellaFingerServerResponse : Decodable {
    let error:String?
    let codigo:Int
    let mensaje:String?
    let data:ZyTMejoresHuellasFingerData?
}

struct ZyTMejoresHuellasFingerData: Decodable{
    let sessionId:String?
    let coErrorReniec:Int
    let deErrorReniec:String?
    let coDedoDer:Int
    let deDedoDer:String?
    let coDedoIzq:Int
    let deDedoIzq:String?
    let indicadorMano:String?
    let operacion:String?
    let inMhReniec:Bool

}



struct APIValidaHuellaData:Decodable{
    /**let id:String?
    let idTransaccion:String?*/
    let nuTransaccion:String?
    let coErrorReniec:Int
    let deErrorReniec:String
    let apPaterno:String?
    let apMaterno:String?
    let preNombre:String?
    /**let tiDocIdentidad:Int?
    let nuDocIdentidad:String?
    let feNacimiento:String?
    let inVigencia:String?
    let inRestriccion:String?
    let inGrupoRestriccion:String?
    let calidadMorpho:Int?
    let confirmarEnrolamiento:Bool
    let enrolExpira:Int?
    let operacion:String?*/
}



