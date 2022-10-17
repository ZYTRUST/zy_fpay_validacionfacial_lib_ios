//
//  utils.swift
//  zy-validaciondactilar-ios
//
//  Created by Developer on 29/06/21.
//

import Foundation


enum ZyErronEnum:Int {
    case EXITO = 8000
    case HIT = 70006

    case ERROR_REQUEST_TOKEN = 9156
    case ERROR_REEQUEST_IDSOLICITUD = 9157
    case ERROR_REEQUEST_NUDOC = 9158
    
    case ERROR_REEQUEST_TIPO_DOC = 9159
    case ERROR_REEQUEST_NuOperacionEmps = 9160
    case ERROR_REQUEST_APPEMPRESA = 9161
    
    case ERROR_RESPONSE_DATOS_NULOS = 9162

    case ERROR_OBTENER_MEJORES_HUELLAS = 22002
    case ERROR_RGISTRAR_INTENTO = 22003
    case ERROR_VALIDACION_RENIEC = 22004
    case ERROR_ENCRYPTACION = 22005
    case ERROR_HUELLAS_NO_LLENADAS = 22006
    case ERROR_NO_FUNCIONA_SIMULADOR = 22007

    case ERROR_BIO_PAIS_ERROR = 9164

    
    
    var descripcion:String {
        switch self {
        case .EXITO:
            return "\(self.rawValue):Todas las operaciones se efecturaron correctamente"
        case .ERROR_REQUEST_TOKEN:
            return "\(self.rawValue): REQUEST TOKEN NULO o VACIO "
        case .ERROR_REEQUEST_IDSOLICITUD:
            return "\(self.rawValue):REQUEST IDSOLICITUD  NULO o VACIO"
        case .ERROR_REEQUEST_NUDOC:
            return "\(self.rawValue): REQUEST NUMERO DOCUMENTO  NULO o VACIO"
            
        case .ERROR_REEQUEST_TIPO_DOC:
            return "\(self.rawValue):REQUEST TIPO DOCUMENTO  NULO o VACIO"
        case .ERROR_REEQUEST_NuOperacionEmps:
            return "\(self.rawValue):REQUEST NUMERO OPERACION EMPS  NULO o VACIO"
        case .ERROR_REQUEST_APPEMPRESA:
            return "\(self.rawValue):APP EMPRESA NO CONFIGURADO"
        case .ERROR_RESPONSE_DATOS_NULOS:
            return "\(self.rawValue):UNO O MAS VALORES EN LA RESPUESTA SON NULOS"
        case .ERROR_NO_FUNCIONA_SIMULADOR:
            return "\(self.rawValue):LIBRERIA ZYTRUST ES SOLO PARA DISPOSITIVOS FISICOS REALES"
            
        case .ERROR_BIO_PAIS_ERROR:
            return "\(self.rawValue):Pais no valido"
        case .HIT:
            return "\(self.rawValue):HIT: Persona Identificada"
            
        default:
            return ""
        }
    }
}
