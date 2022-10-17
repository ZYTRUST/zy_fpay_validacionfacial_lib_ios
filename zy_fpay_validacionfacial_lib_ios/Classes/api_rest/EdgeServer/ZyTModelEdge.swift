//
//  ZyTModelEdge.swift
//  zy_fpay_validacionfacial_lib_ios
//
//  Created by Edwin on 05/02/2022.
//

import Foundation


// SOLICITUD
struct SolicitudCrossRequest {
    var solTsolId:Int?
    var bmoSolicitudDetalles:SolicitudDetalleRequest?
    
    init(solTsolId: Int? = nil,
         bmoSolicitudDetalles: SolicitudDetalleRequest? = nil){
        self.solTsolId = solTsolId
        self.bmoSolicitudDetalles = bmoSolicitudDetalles
    }
}
struct SolicitudDetalleRequest {
    var sdetTopeId:Int?
    var sdetTiDoc:Int?
    var sdetNuDoc:String?
    var sdetFlujoFirma:Int?
    
    init(sdetTopeId: Int? = nil,
         sdetTiDoc: Int? = nil,
         sdetNuDoc: String? = nil,
         sdetFlujoFirma: Int? = nil){
        
        self.sdetTopeId = sdetTopeId
        self.sdetTiDoc = sdetTiDoc
        self.sdetNuDoc = sdetNuDoc
        self.sdetFlujoFirma = sdetFlujoFirma
    }
}


struct SolicitudCrossResponse:Decodable{
    let error:String
    let codigo:Int
    let mensaje:String
    let data:String?
}
struct SolicitudCrossData:Decodable{
    var codError:String?
    var deError:String?
    var soliId:Int
    var solNuOperacionEmps:String
    let solNumClientes:Int
    let solTsolId:Int
    let bmoSolicitudDetalles:[BmoSolicitudDetalle]
}

struct SolicitudCrossDataOptional{
    var soliId:Int
    var solNuOperacionEmps:String?
    let solNumClientes:Int?
    let solTsolId:Int?
    let bmoSolicitudDetalles:[BmoSolicitudDetalle]?
}
struct BmoSolicitudDetalle:Decodable{
    let sdetId:Int?
    var sdetTopeId:Int?
    var sdetTiDoc:Int?
    var sdetNuDoc:String?
}

// PROCESAR
struct ProcesarCrossRequest {
    var soliId:Int?
    var tipoOperacionType:String?
    var soliCliente:SoliClienteRequest?
}
struct SoliClienteRequest {
    var soliCliTiDoc:String?
    var soliCliNuDoc:String?
    var soliCliCodigo:String?
    var soliCliConfiguracion:SoliCliConfiguracionRequest?
    var bmofImagenReferencia:SoliImagenReferenciaRequest?
    var soliCliDniOcr:SoliCliDniOcr?
}
struct SoliCliConfiguracionRequest {
    //var confOperacion:String?
    var confMac:String="02:00:00:00:00:00"
    var confIp:String="127.0.0.1"
    var confPlataforma:String="iOS"
    var confVerPlataforma:String=UIDevice().systemVersion
    var confApkVersion:String?
    var confImei:String=UUID().uuidString
    var confMarca:String="Apple"
    var confModelo:String=UIDevice().type.rawValue
    var coError:String?
    var deError:String?

}
struct SoliImagenReferenciaRequest {
    var buffer:String?
    var formatType:String?
    var height:Int?
    var width:Int?
}

struct SoliCliDniOcr{
    var documento: DocumentoOcr?
    var status: StatusOcr?
    var registraduria: SoliCliDatos?

}

struct SoliCliDatos{
    var coError: String?
    var deError: String?
    var dni: String?
    var nombres: String?
    var apPaterno: String?
    var apMaterno: String?
    var feEmision: String?
    var distrito: String?
    var sex: String?
}

struct DocumentoOcr {
    var isoCountryAlpha2:String?
    var dni:String?
    var tipoDni:String?
    var imgFront:String?
    var imgRear:String?
    var apPaterno:String?
    var apMaterno:String?
    var nombres:String?
    var apellidos:String?
    var feNac:String?
    var deNacionalidad:String?
    var sex:String?
    var feExp:String?
    var feInscripcion:String?
    var feEmision:String?
    var estCivil:String?
    var ubigeo:String?
    var codOACI:String?
    var departamento:String?
    var provincia:String?
    var distrito:String?
    var direccion:String?
    var donanteOrganos:String?
    var grupoVotacion:String?
    var digitoVerificador:String?
    var dniDigitoChequeoMrz:String?
    var dniBarcode:String?
    var isValidoDniDigitoChkMrz:Bool?
    
}

struct StatusOcr {
    var codigoRespuesta:String?
    var descripcionRespuesta:String?
    var lvScore:String?
    var qaScore:String?
    var lvProbability:String?

}

struct ProcesarCrossResponse:Decodable{
    let error:String
    let codigo:Int
    let mensaje:String
    let data:String?
}
struct ProcesarCrossData:Decodable{
    var codError:String?
    var deError:String?
    let soliRefId:Int?
    let soliNuOperacion:String?
    let soliAliasEmpresa:String?
    let bmoBioResponse:BmoBioResponse?
    let bmoComponenteResponseDto:BmoComponenteResponseDto?
    let bmoDataBiometriaDto:BmoDataBiometriaDto?
    let bmoResultBioDto:BmoResultBioDto?

}
struct BmoResultBioDto:Decodable{
    let bmoResultFace:BmoResultFace?
    let bmoResultOcr:BmoResultOcr?
}
struct BmoResultOcr:Decodable{
    let resultNuIntentosCap:String?
    let resultNuIntentosVal:String?
    let resultValDoc:ResultValDoc?
    let resultCapOcr:ResultCapOcr?
    let resultValFotos:ResultValFotos?
    let resultValDatos:ResultValDatos?
    let resultValOcrTotal:ResultValOcrTotal?
    
}
struct ResultValOcrTotal:Decodable{
    let valOcrCoError:String?
    let valOcrDeError:String?
    let valOcrScore:String?
}

struct ResultValDatos:Decodable{
    let valDatosCoError:String?
    let valDatosDeError:String?
    let valDatosScore:String?

}

struct ResultValFotos:Decodable{
    let valFotosCoError:String?
    let valFotosDeError:String?
    let valFotosCoErrorBio:String?
    let valFotosDeErrorBio:String?
    let valFotosTxnId:String?
    let valFotosSolId:String?
    let valFotosScore:String?

}

struct ResultCapOcr:Decodable{
    let capOcrNombres:String?
    let capOcrApellidos:String?
    let capOcrApPaterno:String?
    let capOcrApMaterno:String?
    let capOcrNombresCompletos:String?
    let capOcrFeExp:String?
    let capOcrFeNac:String?
    let capOcrGen:String?
    let capOcrEdad:String?
}

struct ResultValDoc:Decodable{
    let valDocCoError:String?
    let valDocDeError:String?
    let valDocQAScore:String?
    let valDocLvProbabilityScore:String?
}

struct BmoResultFace:Decodable{
    let resultNuIntentosCap:String?
    let resultNuIntentosVal:String?
    let resultCapFace:ResultCapFace?
    let resultValFace:ResultValFace?
    let resultDataBio:ResultDataBio?
}

struct ResultDataBio:Decodable{
    let bioTiDoc:String?
    let bioNuDoc:String?
    let bioNombres:String?
    let bioApPaterno:String?
    let bioApMaterno:String?
    let bioNombresCompletos:String?
    let valFaceSolId:String?
    
}
struct ResultValFace:Decodable{
    let valFaceCoError:String?
    let valFaceDeError:String?
    let valFaceCoErrorBio:String?
    let valFaceDeErrorBio:String?
    let valFaceScore:String?
    let valFaceTxnId:String?
    let valFaceSolId:String?
    
}


struct ResultCapFace:Decodable{
    let capFaceBuffer:String?
    let capFaceFormat:String?
    let capFaceHeight:String?
    let capFaceWidth:String?
}

struct BmoBioResponse:Decodable{
    let codBioError:String?
    let deBioError:String?
}

struct BmoDataBiometriaDto:Decodable{
    let bmoDataFacialDto:BmoDataFacialDto?
    let bmoDataOcrDto:BmoDataOcrDto?

}

struct BmoDataOcrDto:Decodable{
    let ocrNuIntentos:String?
    let ocrValidacionDoc:OcrValidacionDoc?
    let ocrDataPersona:OcrDataPersona?
    let ocrResultado:OcrResultado?
    let ocrValidacionEdad:OcrValidacionEdad?
    let ocrValidacionSelfie:OcrValidacionSelfie?
    let ocrValidacionDatos:OcrValidacionDatos?
}

struct OcrValidacionDoc:Decodable{
    let validaDocQualityScore:String?
    let validaDocLivenessScore:String?
    let validaDocResultado:String?
}
struct OcrDataPersona:Decodable{
    let dataPerNombreCompleto:String?
    let dataPerNombres:String?
    let dataPerApellidos:String?
    let dataPerDocCaduca:String?
    let dataPerNacimiento:String?
    let dataPerGenero:String?
    let dataPerEdad:String?
}
struct OcrResultado:Decodable{
    let ocrCodError:String?
    let ocrDeError:String?
    let ocrCodErrorVb:String?
    let ocrDeErrorVb:String?
    let ocrScore:String?
}
struct OcrValidacionEdad:Decodable{
    let validaEdadAprox:String?
    let validaEdadResultado:String?
}
struct OcrValidacionSelfie:Decodable{
    let validaSelfieCodError:String?
    let validaSelfieDeError:String?
    let validaSelfieCodErrorVb:String?
    let validaSelfieDeErrorVb:String?
    let validaSelfieTransaccionId:String?
    let validaSelfieSolicitudId:String?
    let validaSelfieScore:String?
}
struct OcrValidacionDatos:Decodable{
    let validaDatosCodError:String?
    let validaDatosDeError:String?
    let validaDatosCodErrorVb:String?
    let validaDatosDeErrorVb:String?
    let validaDatosScore:String?
    let validaDatosRegistraduria:ValidaDatosRegistraduria?
}
struct ValidaDatosRegistraduria:Decodable{
    let dataRegisNumeroDocumento:String?
    let dataRegisFechaEmision:String?
    let dataRegisNombreCompleto:String?
    let dataRegisGenero:String?
}

struct BmoDataFacialDto:Decodable{
    let faceCodError:String?
    let faceDeError:String?
    let faceCodErrorReniec:String?
    let faceDeErrorReniec:String?
    let faceTiDoc:String?
    let faceNuDoc:String?
    let faceNombres:String?
    let faceApPaterno:String?
    let faceApMaterno:String?
    let faceScore:String?
    let faceTransaccionId:String?
    let faceSolicitudId:String?
    let faceNuIntentos:String?
    let faceImage:FaceImgBuffer?
}
struct FaceImgBuffer:Decodable{
    let faceImgBuffer:String?
    let faceImgFormat:String?
    let faceImgHeight:String?
    let faceImgWidth:String?
}

struct BmoComponenteResponseDto:Decodable{
    let compIntentos:Int?
    var bmoCompId:Int?
    var bmoCompFlujoFirma:Int?
    var bmoConfiguracionDTO:BmoConfiguracionDTO?
}
struct BmoConfiguracionDTO:Decodable{
    let confTipoRetoPdv:String?
    var confTimeoutPdv:String?
    var confNivelSeguridadPdv:String?
    var confNumeroPuntosPdv:String?
    var confUrlFinal:String?
    var confOcrUrlModel:String?
    var confOcrUrlProcess:String?
    var confOcrTimeOut:Int?
    var confCodigoPais:String?
    var confContratoId:String?
    var confTokenBecome:String?
    
}
