//
//  ZyModel.swift
//  Alamofire
//
//  Created by Developer on 1/12/21.
//

import Foundation

public enum ZyLibResult <T, E> {
    case success(T)
    case error(E)
}


public struct ZyLibError: Codable {
    public let coError:String?
    public let deError:String?
    public var soliNuOperacion:String?
    public var bmoNuSolicitud:String?
    public let bfResponseDto:BfResponseDto?
    public let ocrDto:OcrDto?

 
    public enum CodingKeys: String, CodingKey {
        case coError, deError, soliNuOperacion, bmoNuSolicitud
        case bfResponseDto = "BfResponseDto"
        case ocrDto = "OcrDto"
    }
}

//*************** validacion ****************//

public struct ZyValidacionRequest{
    
    public init(){}
    public var bioTiDoc:String = "1"
    public var bioNuDoc:String = ""
    public var token:String = ""
    public var bmoNombres:String = ""
    public var bmoApPaterno:String = ""
    public var bmoApMaterno:String = ""
    
    public var idSolicitudBmo:String = ""
    public var bmoNuOperacionEmps:String = ""
    public var isDialogActivated:Bool = false
    
}
public struct ZyValidacionResponse{
    public let bioCodError:String = ""
    public let bioDeError:String = ""
    public let bioCodErrorReniec:String
    public let bioDeErrorReniec:String
    public let bioPreNom:String = ""
    public let bioApPat:String = ""
    public let bioApMat:String = ""
    public let bioScore:String = ""
    public let bioNuSolicitud:String = ""
    public let bioIdTransaccion:String = ""
    public let bmoIdSolicitud:String = ""
    
}

//*************** CROSS ****************//

public struct ZyCrossRequest {
    
    public init(){}
    public var token:String=""
    public var bioOperacion:ZyTipoOperacion?
    public var bioPais:String=""
    public var bmoNuOperacionEmps:String = ""
    public var bmoNuSolicitud:String = ""
    public var bioTiDoc:String = "1"
    public var bioNuDoc:String = ""
    public var bmoNombres:String = ""
    public var bmoApPaterno:String = ""
    public var bmoApMaterno:String = ""
    public var isDialogActivated:Bool = true
}


public struct ZyCrossResponse : Codable {
    public var coError:String=""
    public var deError:String=""
    public var soliNuOperacion:String=""
    public var bmoNuSolicitud:String=""
    public var bfResponseDto:BfResponseDto?
    public var ocrDto:OcrDto?
      public enum CodingKeys: String, CodingKey {
           case coError, deError, soliNuOperacion, bmoNuSolicitud
           case bfResponseDto = "BfResponseDto"
           case ocrDto = "OcrDto"
       }
}

public struct BfResponseDto : Codable{
    public var bioCodError:String=""
    public var bioDeError:String=""
    public var bioCodErrorReniec:String?
    public var bioDeErrorReniec:String?
    public var bioTiDoc:String = ""
    public var bioNuDoc:String = ""
    public var bioPreNom:String = ""
    public var bioApPat:String = ""
    public var bioApMat:String = ""
    public var biofechaEmission:String = ""
    public var bioGenero:String = ""
    public var bioScore:String = ""
    public var idTxn:String = ""
    public var nuSolicitud:String = ""
    public var nuIntentos:String = ""
    public var nuIntentosCaptura:String = ""

    public var facialImageSearch:FacialImageSearch?
    
    public enum CodingKeys: String, CodingKey {

            case bioCodError,
                 bioDeError,
                 bioCodErrorReniec,
                 bioDeErrorReniec,
                 bioTiDoc,
                 bioNuDoc,
                 bioPreNom,
                 bioApPat,
                 bioApMat,
                 bioScore,
                 idTxn,
                 nuSolicitud,
                 nuIntentos
            case facialImageSearch = "FacialImageSearch"

        }
}

public struct FacialImageSearch : Codable{
    public var buffer:String = ""
    public var formatType:String = ""
    public var height:String = ""
    public var width:String = ""
    
    public enum CodingKeys: String, CodingKey {
           case buffer, formatType, height, width
       }
}

public struct OcrDto : Codable {
    public var nuIntentos:String = ""
    public var nuIntentosCaptura:String = ""
    public var rsValidacionDoc:RsValidacionDoc?
    public var rsOcr:RsOcr?
    public var rsOcrResultado:RsOcrResultado?
    public var rsEvaluacionEdad:RsEvaluacionEdad?
    public var rsOcrSelfie:RsOcrSelfie?
    public var rsValidacionDatos:RsValidacionDatos?
    
    public enum CodingKeys: String, CodingKey {
           case nuIntentos
           case rsValidacionDoc = "RsValidacionDoc"
           case rsOcr = "RsOcr"
           case rsOcrResultado = "RsOcrResultado"
           case rsEvaluacionEdad = "RsEvaluacionEdad"
           case rsOcrSelfie = "RsOcrSelfie"
           case rsValidacionDatos = "RsValidacionDatos"

       }
}

public struct RsValidacionDoc:Codable{
    public var validaDocQualityScore:String = ""
    public var validaDocLivenessScore:String? = ""
    public var resultadoValidacion:String = ""
    public enum CodingKeys: String, CodingKey {
           case validaDocQualityScore,validaDocLivenessScore,resultadoValidacion
       }
}

public struct RsOcr : Codable{
    public var fullName:String = ""
    public var firstName:String = ""
    public var lastName:String = ""
    public var dateOfExpiry:String = ""
    public var dateOfBirth:String = ""
    public var sex:String = ""
    public var age:String = ""
    public var placeOfBirth:String = ""
    public var dateOfIssue:String = ""

    public enum CodingKeys: String, CodingKey {
            case fullName,firstName, lastName, dateOfExpiry, dateOfBirth, sex, age,placeOfBirth
        }
}

public struct RsOcrResultado : Codable{
    public var bioCodError:String = ""
    public var bioDeError:String = ""
    public var bioCodErrorVB:String = ""
    public var bioCodesErrorVB:String = ""
    public var bioScore:String = ""
    public enum CodingKeys: String, CodingKey {
            case bioCodError, bioDeError, bioCodErrorVB, bioCodesErrorVB, bioScore
        }
}
public struct RsEvaluacionEdad:Codable{
    public var edadAprox:String = ""
    public var resultadoValidacion:String = ""
    public enum CodingKeys: String, CodingKey {
            case edadAprox, resultadoValidacion
        }
}

public struct RsOcrSelfie:Codable{
    public var bioCodError:String = ""
    public var bioDeError:String = ""
    public var bioCodErrorVB:String = ""
    public var bioDeErrorVB:String = ""
    public var idTxn:String = ""
    public var nuSolicitud:String = ""
    public var bioScore:String = ""
    public enum CodingKeys: String, CodingKey {
          case bioCodError, bioDeError, bioCodErrorVB, bioDeErrorVB, idTxn, nuSolicitud, bioScore
      }
}

public struct RsValidacionDatos : Codable{
    public var bioCodError:String = ""
    public var bioDeError:String = ""
    public var bioCodErrorVB:String = ""
    public var bioDeErrorVB:String = ""
    public var bioScore:String = ""

    public enum CodingKeys: String, CodingKey {
        case bioCodError, bioDeError, bioCodErrorVB, bioDeErrorVB, bioScore
        }
}

//*************** CROSS ****************//

struct ZyFlujoCrossResponse{
    var bmoCompId:Int?
    var coErrorDeNivel:String?
    var deErrorDeNivel:String?
    var solicitud:SolicitudCrossDataOptional?
    var configuracion:ProcesarCrossData?
    var validacionFacial:ProcesarCrossData?
    var resultado: ProcesarCrossData?
    var errorResult: ZyTApiError?
    
    init(bmoCompId:Int? = nil,
         solicitud: SolicitudCrossDataOptional? = nil,
         configuracion:ProcesarCrossData? = nil,
         validacionFacial:ProcesarCrossData? = nil,
         resultado:ProcesarCrossData? = nil,
         errorResult: ZyTApiError? = nil ){
        
        self.bmoCompId = bmoCompId
        self.solicitud = solicitud
        self.configuracion = configuracion
        self.validacionFacial = validacionFacial
        self.resultado = resultado
        self.errorResult = errorResult
    }
    
    var datos: ZyCrossResponse {
        get{
            var bfResponseDto = BfResponseDto(bioCodErrorReniec: "", bioDeErrorReniec: "")
            var ocrDto = OcrDto()
            var res = ZyCrossResponse(bfResponseDto: bfResponseDto,
                                      ocrDto: ocrDto)
            return res
        }
    }
}

public enum ZyTipoOperacion:Int {
    case FACIAL = 15
    case FULL = 11
    
    case FLUJO_COLOMBIA = 12
    case RESULTADO = 19
    
}
public enum ZyErrorUi:Int {
    case EXITO = 8000
    case ERROR_DOC_INVALIDO = 8383
    case ERROR_TIMEOUT = 9116
    case ERROR_NO_HIT = 70007
    case ERROR_SOLICITUD_BLOQUEADA = 8270
    case ERROR_FEIGN_CLIENT = 8087
    
    var descripcion:String {
        switch self {
        case .EXITO:
            return "8000"
        case .ERROR_TIMEOUT:
            return "9116: se superò el tiempo de captura"
        case .ERROR_NO_HIT:
            return "70007: No hit ,persona no identificada"
        case .ERROR_SOLICITUD_BLOQUEADA:
            return "8270:La solicitud se encuentra bloqueada"
        case .ERROR_FEIGN_CLIENT:
            return "8087: Feign cleint error"
        case .ERROR_DOC_INVALIDO:
            return "8383: Documento capturado inválido"
        default:
            return ""
        }
    }
}


