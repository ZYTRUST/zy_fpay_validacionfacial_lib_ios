//
//  File.swift
//  zy_fpay_validacionfacial_lib_ios
//
//  Created by Edwin on 05/02/2022.
//

import Foundation

enum ZyTEndpointEdge: URLRequestConvertible {
    
    //EDGE-SERVER
    case generarSolicitud(request:SolicitudCrossRequest)
    case procesar(request:ProcesarCrossRequest)
    
    var method: HTTPMethod {
        switch self {
            //EDGE-SERVER
            case .generarSolicitud:
                return .post
            case .procesar:
                return .post
        }
    }
    
    var path: String {
        switch self {
            case .generarSolicitud:
                return ZyTApiConstantes.path_solicitud_edge
            case .procesar:
                return ZyTApiConstantes.path_procesar_edge
        }
    }
    
    var parameter : [String:Any]{
        var paramDict : [String: Any] = [:]
        
        switch self {
        case .generarSolicitud(request: let request):
            
            paramDict["solTsolId"] = request.solTsolId
            
            if let detalle = request.bmoSolicitudDetalles  {
                
                var bmoSolicitudDetalle = [String: Any].self()
                bmoSolicitudDetalle["sdetTopeId"] = detalle.sdetTopeId
                bmoSolicitudDetalle["sdetTiDoc"] = detalle.sdetTiDoc
                bmoSolicitudDetalle["sdetNuDoc"] = detalle.sdetNuDoc
                bmoSolicitudDetalle["sdetFlujoFirma"] = detalle.sdetFlujoFirma
             
                var existingItems =
                    paramDict["bmoSolicitudDetalles"] as? [[String: Any]] ?? [[String: Any]]()
                existingItems.append(bmoSolicitudDetalle)
                
                paramDict["bmoSolicitudDetalles"] = existingItems
            }
            
            return paramDict
            
        case .procesar(request: let request):
 
            paramDict["soliId"] = request.soliId
            paramDict["tipoOperacionType"] = request.tipoOperacionType
            
            if let soliClienteRequest = request.soliCliente  {
                
                var soliClienteObj = [String: Any].self()
                
                soliClienteObj["soliCliTiDoc"] = soliClienteRequest.soliCliTiDoc
                soliClienteObj["soliCliNuDoc"] = soliClienteRequest.soliCliNuDoc
                soliClienteObj["soliCliCodigo"] = soliClienteRequest.soliCliCodigo
                
                if let soliCliConfigRequest = soliClienteRequest.soliCliConfiguracion  {
                    
                    var soliCliConfiguracionObj = [String: Any].self()
                    
                    //soliCliConfiguracionObj["confOperacion"] = request.confOperacion
                    soliCliConfiguracionObj["confMac"] = soliCliConfigRequest.confMac
                    soliCliConfiguracionObj["confIp"] = soliCliConfigRequest.confIp
                    soliCliConfiguracionObj["confPlataforma"] = soliCliConfigRequest.confPlataforma
                    soliCliConfiguracionObj["confVerPlataforma"] = soliCliConfigRequest.confVerPlataforma
                    soliCliConfiguracionObj["confApkVersion"] = versionLibreria()
                    //soliCliConfiguracionObj["confNuSolicitud"] = request.soliId
                    soliCliConfiguracionObj["confImei"] = soliCliConfigRequest.confImei
                    soliCliConfiguracionObj["confMarca"] = soliCliConfigRequest.confMarca
                    soliCliConfiguracionObj["confModelo"] = soliCliConfigRequest.confModelo
                    soliCliConfiguracionObj["coError"] = soliCliConfigRequest.coError
                    soliCliConfiguracionObj["deError"] = soliCliConfigRequest.deError

                    soliClienteObj["soliCliConfiguracion"] = soliCliConfiguracionObj
                    
                }
                if let soliImagenRefRequest = soliClienteRequest.bmofImagenReferencia  {
                    
                    var bmofImagenReferenciaObj = [String: Any].self()
                    
                    bmofImagenReferenciaObj["buffer"]=soliImagenRefRequest.buffer
                    bmofImagenReferenciaObj["formatType"]=soliImagenRefRequest.formatType
                    bmofImagenReferenciaObj["height"]=soliImagenRefRequest.height
                    bmofImagenReferenciaObj["width"]=soliImagenRefRequest.width
                    
                    soliClienteObj["bmofImagenReferencia"] = bmofImagenReferenciaObj
                }
                if let soliCliDniOcr = soliClienteRequest.soliCliDniOcr {
                    var soliCliDniOcrObj = [String: Any].self()
                    
                    if let documento = soliCliDniOcr.documento {
                        var documentoObj = [String: Any].self()
                        documentoObj["dni"]=documento.dni
                        documentoObj["tipoDni"]=documento.tipoDni
                        documentoObj["imgFront"] = documento.imgFront
                        documentoObj["imgRear"] = documento.imgRear
                        documentoObj["nombres"] = documento.nombres
                        documentoObj["feNac"] = documento.feNac
                        documentoObj["deNacionalidad"] = documento.deNacionalidad
                        documentoObj["sex"] = documento.sex
                        documentoObj["feInscripcion"] = documento.feInscripcion
                        documentoObj["feEmision"] = documento.feEmision
                        documentoObj["estCivil"] = documento.estCivil
                        documentoObj["ubigeo"] = documento.ubigeo
                        documentoObj["codOACI"] = documento.codOACI
                        documentoObj["departamento"] = documento.departamento
                        documentoObj["provincia"] = documento.provincia
                        documentoObj["distrito"] = documento.distrito
                        documentoObj["direccion"] = documento.direccion
                        documentoObj["donanteOrganos"] = documento.donanteOrganos
                        documentoObj["grupoVotacion"] = documento.grupoVotacion
                        documentoObj["digitoVerificador"] = documento.digitoVerificador
                        documentoObj["dniDigitoChequeoMrz"] = documento.dniDigitoChequeoMrz
                        documentoObj["dniBarcode"] = documento.dniBarcode
                        documentoObj["isValidoDniDigitoChkMrz"] = documento.isValidoDniDigitoChkMrz
                        documentoObj["feExp"] = documento.feExp

                        switch(documento.isoCountryAlpha2){
                        case "PE":
                            print("====>>> Documento PE")
                            documentoObj["apMaterno"] = documento.apMaterno
                            documentoObj["apPaterno"] = documento.apPaterno

                            break
                        case "CO":
                            print("====>>> Documento CO")
                            documentoObj["apellidos"] = documento.apellidos

                            var registryObj = [String: Any].self()
                            //registryObj["coError"] = soliCliDniOcr.registraduria?.coError
                            //registryObj["deError"] = soliCliDniOcr.registraduria?.deError

                            registryObj["dni"] = soliCliDniOcr.registraduria?.dni
                            registryObj["nombres"] = soliCliDniOcr.registraduria?.nombres
                            registryObj["apPaterno"] = soliCliDniOcr.registraduria?.apPaterno
                            registryObj["apMaterno"] = soliCliDniOcr.registraduria?.apMaterno
                            registryObj["feEmision"] = soliCliDniOcr.registraduria?.feEmision
                            registryObj["distrito"] = soliCliDniOcr.registraduria?.distrito
                            registryObj["sex"] = soliCliDniOcr.registraduria?.sex
                            soliClienteObj["soliCliDatos"] = registryObj

                            break
                        default:
                            break
                        }
                        soliCliDniOcrObj["documento"] = documentoObj
                    }
                    
                    if let status = soliCliDniOcr.status {
                        var statusObj = [String: Any].self()
                        statusObj["codigoRespuesta"]=status.codigoRespuesta
                        statusObj["descripcionRespuesta"]=status.descripcionRespuesta
                        statusObj["lvScore"]=status.lvScore
                        statusObj["qaScore"]=status.qaScore
                        statusObj["lvProbability"]=status.lvProbability

                        soliCliDniOcrObj["status"] = statusObj
                    }
                    
                    soliClienteObj["soliCliDniOcr"] = soliCliDniOcrObj
                }
                
                paramDict["soliCliente"] = soliClienteObj
            }
            
            
            return paramDict
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
            case .generarSolicitud:
                return JSONEncoding.prettyPrinted
            case .procesar:
                return JSONEncoding.prettyPrinted
            default:
                return JSONEncoding.prettyPrinted
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        
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
        
        let dataJson : Data
        do {
            dataJson = try JSONSerialization.data(withJSONObject: parameter, options: [])
            let fixedJson = String(data: dataJson, encoding: String.Encoding.utf8)!
            let jsonencrypt = EncryptUtil.zyEncrypt(jsonText: fixedJson)
            #if DEBUG
            print("fixedString \n \(fixedJson)")
            #endif

            request.httpBody = jsonencrypt.data(using: String.Encoding.utf8)
            if request.headers["Content-Type"] == nil {
                request.headers.update(.contentType("application/json"))
            }
        } catch {
            throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
        }
        
        print("======>>>>>> http metodo :::")
        print("\(request.httpMethod ?? "") \(String(describing: request.url))")
        let bodyHttp = String(decoding: request.httpBody!, as: UTF8.self)
        //print("BODY\n \(bodyHttp)")
        print("HEADERS \n \(String(describing: request.allHTTPHeaderFields))")
        
        return try encoding.encode(request, with: nil)
    }
    
    
}
