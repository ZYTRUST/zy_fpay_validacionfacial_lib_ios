//
//  APIRouter.swift
//  zy-onefinger-ios
//
//  Created by Edwin on 07/22/2020.
//  Copyright © 2020 Edwin. All rights reserved.
//

import Foundation
import CoreVideo
import JWTDecode
import CryptoSwift



enum ZyTEndpoint: URLRequestConvertible {
    
    case generarSolicitud(tiDoc:String,nuDoc:String)
    case obtenerConfiguracion(param:String)
    case registraIntento(nuSolicitud:String,coError:String,deError:String)
    case obtenerMejorHuella(tiDoc:String,nuDoc:String)
    case validarHuella(request:APIValidaHuellaRequest)
    case obtenerMejorHuellaFingerServer(nuSolicitud:String)
    case obtenerConfigQapaq(tiDoc:String,nuDoc:String,idSolicitud:String)
    case regitraIntentoQapaq(coError:String,deError:String,soliId:String,nuDni:String,confNuSolicitud:String)
    case verificacionFacialQapaq(img:String,height:Int,width:Int,nuDni:String,confNuSolicitud:String,bmoNuOperacionEmps:String,idSolicitud:String)
    case obtenerConfigQapaqEncrypted(tiDoc:String,nuDoc:String,idSolicitud:String)
    case regitraIntentoQapaqEncrypted(coError:String,deError:String,soliIdBMO:String,nuDni:String,confNuSolicitud:String)
    case verificacionFacialQapaqEncrypted(img:String,height:Int,width:Int,nuDni:String,confNuSolicitud:String,bmoNuOperacionEmps:String,idSolicitud:String)
    
    case generaSolicitudBmo(tiDoc:String,nuDoc:String,appEmps:String,nuOperacionEmps:String,nombres:String,apPaterno:String,apMaterno:String)
    
    // The http method to be used
    var method: HTTPMethod {
        switch self {
            case .generarSolicitud:
                return .post
            case .obtenerConfiguracion:
                return .get
            case .registraIntento:
                return .post
            case .obtenerMejorHuella:
                return .post
            case .validarHuella:
                return .post
            case .obtenerMejorHuellaFingerServer:
                return .get
            case .obtenerConfigQapaq:
                return .post
            case .obtenerConfigQapaqEncrypted:
                return .post
            default:
                return .post
            
        }
    }
    
    var isEdgeEncrypted:Bool{
        switch self {
        case .obtenerConfigQapaqEncrypted:
            return true
        case .regitraIntentoQapaqEncrypted:
            return true
        case .verificacionFacialQapaqEncrypted:
            return true
        default:
            return false
            
        }
        
    }
    // path of the request
    var path: String {
        switch self {
            case .generarSolicitud:
                return ZyTApiConstantes.path_solicitud
            case .obtenerConfiguracion(let nuSolicitud):
                return "\(ZyTApiConstantes.path_configuracion)/\(nuSolicitud)"
            case .registraIntento:
                return ZyTApiConstantes.path_intento_registro
            case .obtenerMejorHuella:
                return ZyTApiConstantes.path_mejor_huella
            case .validarHuella:
                return ZyTApiConstantes.path_verifica_reniec
            case .obtenerMejorHuellaFingerServer(let nuSolicitud):
                return "\(ZyTApiConstantes.path_mejor_huella_finger_Server)/\(nuSolicitud)"
            case .obtenerConfigQapaq:
                return ZyTApiConstantes.path_obtenerConfig_qapaq
            case .regitraIntentoQapaq:
                return ZyTApiConstantes.path_regitraIntentoQapaq
            case .verificacionFacialQapaq:
                return ZyTApiConstantes.path_verificacionFacialQapaq
            case .obtenerConfigQapaqEncrypted:
                return ZyTApiConstantes.path_configQapaqEncrypted
            case .regitraIntentoQapaqEncrypted:
                return ZyTApiConstantes.path_regitraIntentoQapaqEncryptedEncrypted
            case .verificacionFacialQapaqEncrypted:
                return ZyTApiConstantes.path_verificacionFacialQapaqEncrypted
            case .generaSolicitudBmo(let tiDoc,let nuDoc,let appEmps ,let nuOperacionEmps,let nombres,let apPaterno,let apMaterno):
                return ZyTApiConstantes.path_generaSolicitudBmo
                //commit
        }
    }
    
    var parameter : [String:Any]{
        var paramDict : [String: Any] = [:]
        
        switch self {
        case .generaSolicitudBmo(let tiDoc,let nuDoc,let appEmps ,let nuOperacionEmps,let nombres,let apPaterno,let apMaterno):
            
            var bmoDetalle = [String: Any].self()
            bmoDetalle["bmodTipoOperacion"] = "CREAR"
            bmoDetalle["bmodTiDoc"] = tiDoc
            bmoDetalle["bmodNuDoc"] = nuDoc
            bmoDetalle["bmodNombres"] = nombres
            bmoDetalle["bmodApPaterno"] = apPaterno
            bmoDetalle["bmodApMaterno"] = apMaterno
            
            var existingItems = paramDict["items"] as? [[String: Any]] ?? [[String: Any]]()
            existingItems.append(bmoDetalle)
            
            
            paramDict["bmoTipoSolicitud"] = "CONTRATO_FACIAL_ONE"
            paramDict["bmoNuOperacionEmps"] = nuOperacionEmps
            paramDict["bmoNuClientes"] = "1"
            paramDict["bmoAppEmps"] = appEmps
            paramDict["bmoMac"] = "02:00:00:00:00:00"
            paramDict["bmoPlataforma"] = "iOS"
            paramDict["bmoVerPlataforma"] = UIDevice().systemVersion
            paramDict["bmoDetalles"] = existingItems

            
            return paramDict
            
        case .obtenerConfigQapaqEncrypted(let tiDoc,let nuDoc,let idSolicitud):
            
            paramDict["soliId"] = idSolicitud
            
            var soliClienteObj = [String: Any].self()
            
            var soliCliConfiguracion = [String: Any].self()
            soliCliConfiguracion["confOperacion"] = "GENERA_SOLICITUD"
            soliCliConfiguracion["confMac"] = "02:00:00:00:00:00"
            soliCliConfiguracion["confIp"] = "127.0.0.0"
            soliCliConfiguracion["confPlataforma"] = "iOS"
            soliCliConfiguracion["confVerPlataforma"] = UIDevice().systemVersion
            soliCliConfiguracion["confApkVersion"] = versionLibreria()
            soliCliConfiguracion["confVerificaReniec"] = "2"
            
            soliClienteObj["soliCliTiDoc"] = "DNI"
            soliClienteObj["soliCliNuDoc"] = nuDoc
            soliClienteObj["soliCliConfiguracion"] = soliCliConfiguracion
            
            paramDict["soliCliente"] = soliClienteObj
            
            return paramDict
            
        case .obtenerConfigQapaq(let tiDoc,let nuDoc,let idSolicitud):
            
            paramDict["soliId"] = idSolicitud
            
            var soliClienteObj = [String: Any].self()
            
            var soliCliConfiguracion = [String: Any].self()
            soliCliConfiguracion["confOperacion"] = "GENERA_SOLICITUD"
            soliCliConfiguracion["confMac"] = "02:00:00:00:00:00"
            soliCliConfiguracion["confIp"] = "127.0.0.0"
            soliCliConfiguracion["confPlataforma"] = "iOS"
            soliCliConfiguracion["confVerPlataforma"] = UIDevice().systemVersion
            soliCliConfiguracion["confApkVersion"] = versionLibreria()
            soliCliConfiguracion["confVerificaReniec"] = "2"
            
            soliClienteObj["soliCliTiDoc"] = "DNI"
            soliClienteObj["soliCliNuDoc"] = nuDoc
            soliClienteObj["soliCliConfiguracion"] = soliCliConfiguracion
            
            paramDict["soliCliente"] = soliClienteObj
            
            return paramDict
        case .regitraIntentoQapaqEncrypted(let coError,let deError,let soliId,let nuDni, let confNuSolicitud):
            paramDict["soliId"] = soliId
            var soliCliente = [String: Any].self()
            soliCliente["soliCliTiDoc"] = "DNI"
            soliCliente["soliCliNuDoc"] = nuDni
            var soliCliConfiguracion = [String: Any].self()
            soliCliConfiguracion["confNuSolicitud"] = confNuSolicitud
            soliCliConfiguracion["confOperacion"] = "NONE"
            soliCliConfiguracion["confMac"] = "02:00:00:00:00:00"
            soliCliConfiguracion["confIp"] = "127.0.0.0"
            soliCliConfiguracion["confPlataforma"] = "iOS"
            soliCliConfiguracion["confVerPlataforma"] = UIDevice().systemVersion
            soliCliConfiguracion["confApkVersion"] = versionLibreria()
            soliCliConfiguracion["confVerificaReniec"] = "2"
            soliCliConfiguracion["coError"] = coError
            soliCliConfiguracion["deError"] = deError
            
            var soliCliIntento = [String: Any].self()
            soliCliIntento["scliInTiOperacion"] = "CAPTURA_VIDA"
            
            soliCliente["soliCliConfiguracion"] = soliCliConfiguracion
            soliCliente["soliCliIntento"] = soliCliIntento
            
            paramDict["soliCliente"] = soliCliente
            
            return paramDict
            
        case .regitraIntentoQapaq(let coError,let deError,let soliId,let nuDni, let confNuSolicitud):
            
            
            paramDict["soliId"] = soliId
            var soliCliente = [String: Any].self()
            soliCliente["soliCliTiDoc"] = "DNI"
            soliCliente["soliCliNuDoc"] = nuDni
            var soliCliConfiguracion = [String: Any].self()
            soliCliConfiguracion["confNuSolicitud"] = confNuSolicitud
            soliCliConfiguracion["confOperacion"] = "NONE"
            soliCliConfiguracion["confMac"] = "02:00:00:00:00:00"
            soliCliConfiguracion["confIp"] = "127.0.0.0"
            soliCliConfiguracion["confPlataforma"] = "iOS"
            soliCliConfiguracion["confVerPlataforma"] = UIDevice().systemVersion
            soliCliConfiguracion["confApkVersion"] = versionLibreria()
            soliCliConfiguracion["confVerificaReniec"] = "2"
            soliCliConfiguracion["coError"] = coError
            soliCliConfiguracion["deError"] = deError
            
            var soliCliIntento = [String: Any].self()
            soliCliIntento["scliInTiOperacion"] = "CAPTURA_VIDA"
            
            soliCliente["soliCliConfiguracion"] = soliCliConfiguracion
            soliCliente["soliCliIntento"] = soliCliIntento
            
            paramDict["soliCliente"] = soliCliente
            
            return paramDict
            
        case .verificacionFacialQapaq(let img,let height,let width,let nuDni,let confNuSolicitud,let bmoNuOperacionEmps,let idSolicitud):
            
            paramDict["bmoIdSolicitud"] = idSolicitud
            paramDict["bmoTipoSolicitud"] = "CONTRATO_FACIAL_ONE"
            paramDict["bmoNuOperacionEmps"] = bmoNuOperacionEmps
            paramDict["bmoNuClientes"] = 1
            paramDict["bmoAppEmps"] = "APP02"
            paramDict["bmoMac"] = "02:00:00:00:00:00"
            paramDict["bmoIp"] = "127.0.0.0"
            paramDict["bmoPlataforma"] = "iOS"
            paramDict["bmoVerPlataforma"] = UIDevice().systemVersion
            
            var item = [String: Any].self()
            item["bmodNuSolicitud"] = confNuSolicitud
            item["bmodTipoOperacion"] = "VERIFICAR"
            item["bmodTiDoc"] = 1
            item["bmodNuDoc"] = nuDni
            item["bmodProceso"] = "CREDITO_DIGITAL"
            
            var bmodFacial = [String: Any].self()
            bmodFacial["bmofOperacion"] = "FACIAL_ENROLL_VERIFY_TO_DB"
            
            var bmofImagenReferencia = [String: Any].self()
            bmofImagenReferencia["formatType"] = "JPEG"
            bmofImagenReferencia["height"] = height
            bmofImagenReferencia["width"] = width
            bmofImagenReferencia["buffer"] = img
            
            bmodFacial["bmofImagenReferencia"] = bmofImagenReferencia
            
            
            item["bmodFacial"] = bmodFacial

            
            var existingItems = paramDict["items"] as? [[String: Any]] ?? [[String: Any]]()
            existingItems.append(item)
            
            paramDict["bmoDetalles"] = existingItems
            
            
            return paramDict
            
        case .verificacionFacialQapaqEncrypted(let img,let height,let width,let nuDni,let confNuSolicitud,let bmoNuOperacionEmps,let idSolicitud):
            
            paramDict["bmoIdSolicitud"] = idSolicitud
            paramDict["bmoTipoSolicitud"] = "CONTRATO_FACIAL_ONE"
            paramDict["bmoNuOperacionEmps"] = bmoNuOperacionEmps
            paramDict["bmoNuClientes"] = 1
            paramDict["bmoAppEmps"] = "APP02"
            paramDict["bmoMac"] = "02:00:00:00:00:00"
            paramDict["bmoIp"] = "127.0.0.0"
            paramDict["bmoPlataforma"] = "iOS"
            paramDict["bmoVerPlataforma"] = UIDevice().systemVersion
            
            var item = [String: Any].self()
            item["bmodNuSolicitud"] = confNuSolicitud
            item["bmodTipoOperacion"] = "VERIFICAR"
            item["bmodTiDoc"] = 1
            item["bmodNuDoc"] = nuDni
            item["bmodProceso"] = "CREDITO_DIGITAL"
            
            var bmodFacial = [String: Any].self()
            bmodFacial["bmofOperacion"] = "FACIAL_ENROLL_VERIFY_TO_DB"
            
            var bmofImagenReferencia = [String: Any].self()
            bmofImagenReferencia["formatType"] = "JPEG"
            bmofImagenReferencia["height"] = height
            bmofImagenReferencia["width"] = width
            bmofImagenReferencia["buffer"] = img
            
            bmodFacial["bmofImagenReferencia"] = bmofImagenReferencia
            
            
            item["bmodFacial"] = bmodFacial
            
            
            var existingItems = paramDict["items"] as? [[String: Any]] ?? [[String: Any]]()
            existingItems.append(item)
            
            paramDict["bmoDetalles"] = existingItems
            
            
            return paramDict
            
            
        case .generarSolicitud(let tiDoc,let nuDoc):
            
            paramDict["tiDoc"] = tiDoc
            paramDict["nuDoc"] = nuDoc
            paramDict["mac"] = "02:00:00:00:00:00"
            paramDict["ip"] = "127.0.0.0" //UIDevice.current.ipAddress() ?? "127.0.0.0"
            paramDict["plataforma"] = UIDevice().systemName
            paramDict["versionPlataforma"] = UIDevice().systemVersion
            paramDict["uuid"] = UUID().uuidString
            paramDict["marca"] = "Apple"
            paramDict["modelo"] = UIDevice().type.rawValue
            paramDict["apkVersion"] = versionLibreria()
            
            return paramDict
            
        case .obtenerConfiguracion:
            return [:]
            
        case .registraIntento(let nuSolicitud,let coError,let deError):
            
            paramDict["nuSolicitud"] = nuSolicitud
            paramDict["coError"] = coError
            paramDict["deError"] = deError
            
            return paramDict
            
        case .obtenerMejorHuella(let tiDoc,let nuDoc):
            
            paramDict["tiDocCliente"] = tiDoc
            paramDict["nuDocCliente"] = nuDoc
            paramDict["ipPcConsulta"] = "127.0.0.0" //UIDevice.current.ipAddress()
            paramDict["macPcConsulta"] = "02:00:00:00:00:00" //no es posible por politicas de apple
            
            return paramDict
            
        case .validarHuella(let request):
            
            paramDict["id"] = "1"
            paramDict["tiDocCliente"] = request.tiDocCliente
            paramDict["nuDocCliente"] = request.nuDocCliente
            paramDict["ipPcConsulta"] = "127.0.0.0" //UIDevice.current.ipAddress()
            paramDict["macPcConsulta"] = "02:00:00:00:00:00"  // no es posible por politicas de apple
            paramDict["idPcConsulta"] = "123124554hnm5"
            paramDict["nuSerieTerminal"] = "SDK-Identy-i2.9.1.20"
            paramDict["txnOperacionId"] = "154"
            paramDict["operacionType"] = "ENROLL"
            paramDict["feIniCliente"] = "2020-04-21T09:45:00.000+02:00"
            paramDict["datoBiometrico"] = "NONE"
            
            
            var mejorHuellaDer:[String:Any]=[:]
            
            mejorHuellaDer["idDedo"] = request.idDedoDer
            mejorHuellaDer["inCalidad"] = "80"
            mejorHuellaDer["verify"] = "NONE"
            mejorHuellaDer["pkHex"] = ZyTApiConstantes.pk_hex
            mejorHuellaDer["wsqHex"] = request.wsqDer
            
            paramDict["mejorhuellaDer"] = mejorHuellaDer
            
            var mejorHuellaIzq:[String:Any]=[:]
            
            mejorHuellaIzq["idDedo"] = request.idDedoIzq
            mejorHuellaIzq["inCalidad"] = "80"
            mejorHuellaIzq["verify"] = "NONE"
            mejorHuellaIzq["pkHex"] = ZyTApiConstantes.pk_hex
            mejorHuellaIzq["wsqHex"] = request.wsqIzq
            
            paramDict["mejorhuellaIzq"] = mejorHuellaIzq
            
            return paramDict
            
        case .obtenerMejorHuellaFingerServer:
            return [:]
            
        }
    }
    var headers:[String:String]{
        switch self {
                
            default:
                return [:]
        }
    }
    var encoding: ParameterEncoding {
        switch self {
            case .obtenerConfiguracion:
                return URLEncoding.default
            case .obtenerMejorHuellaFingerServer:
                return URLEncoding.default
            default:
                return JSONEncoding.prettyPrinted
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
        
#if DEBUG
        print("Calling \(url)\(path)")
        print(request.allHTTPHeaderFields)
        print("PARAMETERS \n \(parameter)")
#else
#endif
        if (isEdgeEncrypted){
            let dataJson : Data
            do {
                dataJson = try JSONSerialization.data(withJSONObject: parameter, options: [])
                let fixedJson = String(data: dataJson, encoding: String.Encoding.ascii)!
                let jsonencrypt = EncryptUtil.zyEncrypt(jsonText: fixedJson)
                //print("fixedString \n \(fixedJson)")
                
                
                request.httpBody = jsonencrypt.data(using: String.Encoding.utf8)
                if request.headers["Content-Type"] == nil {
                    request.headers.update(.contentType("application/json"))
                }
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
#if DEBUG
            print("=================================")
            print("======>>>>>> http metodo :::")
            print("\(request.httpMethod ?? "") \(request.url)")
            let bodyHttp = String(decoding: request.httpBody!, as: UTF8.self)
            print("BODY \n \(bodyHttp)")
            print("HEADERS \n \(request.allHTTPHeaderFields)")
#else
#endif
            return try encoding.encode(request, with: nil)
        }else{
            return try encoding.encode(request, with: parameter)
        }
    }
    
}


/**

func secureRandomBytes(count: Int) throws -> [UInt8] {
    var bytes = [UInt8](repeating: 0, count: count)
    
    // Fill bytes with secure random data
    let status = SecRandomCopyBytes(
        kSecRandomDefault,
        count,
        &bytes
    )
    return bytes
    
    // A status of errSecSuccess indicates success
    if status == errSecSuccess {
        return bytes
    }
    
}*/



