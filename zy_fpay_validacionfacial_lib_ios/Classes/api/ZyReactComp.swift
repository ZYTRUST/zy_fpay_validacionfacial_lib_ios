//
//  ZyReactComp.swift
//  zy_fpay_validacionfacial_lib_ios
//
//  Created by Developer on 15/05/22.
//

import Foundation

@objcMembers
public class ZyReactComp : NSObject{
    
    typealias completicion = (ReactResponse?) -> Void
    
    private var vc: UIViewController
    
    
    @objc public init (onView: UIViewController){
        vc = onView
    }
    
    /*@objc(reactValidacionFacial:completion:)
    public func reactValidacionFacial(reactRequest:ReactRequest, completion: @escaping ((ReactResponse) -> Void)) {
        let api = ZyApiCross(onView: vc)
        var request = ZyCrossRequest()
        
        request.bioTiDoc = reactRequest.bioTiDoc
        request.bioNuDoc = reactRequest.bioNuDoc
        request.bioPais = reactRequest.bioPais
        request.bioOperacion = ZyTipoOperacion.FULL
        request.bmoNuOperacionEmps = reactRequest.bmoNuOperacionEmps
        request.isDialogActivated = reactRequest.isDialogActivated
        request.token = reactRequest.token
        
        api.iniciarFlujo(request: request)
        { (result:ZyLibResult<ZyCrossResponse, ZyLibError>) in
            
            switch result {
            case .success(let response):
                let responseHandler = ReactResponse()
                responseHandler.coError = response.coError
                responseHandler.deError = response.deError
                responseHandler.soliNuOperacion = response.soliNuOperacion
                
                responseHandler.facebioApPat = response.bfResponseDto?.bioApPat ?? ""
                responseHandler.facebioApMat = response.bfResponseDto?.bioApMat ?? ""
                responseHandler.faceidTxn = response.bfResponseDto?.idTxn ?? ""
                responseHandler.facenuSolicitud = response.bfResponseDto?.nuSolicitud ?? ""
                responseHandler.facebioScore = response.bfResponseDto?.nuSolicitud ?? ""
                responseHandler.facebioCodError = response.bfResponseDto?.bioCodError ?? ""
                responseHandler.facebioDeError = response.bfResponseDto?.bioDeError ?? ""
                responseHandler.facebioCodErrorReniec = response.bfResponseDto?.bioCodErrorReniec ?? ""
                responseHandler.facebioDeErrorReniec = response.bfResponseDto?.bioDeErrorReniec ?? ""
                responseHandler.facefacialImageSearchwidth = response.bfResponseDto?.facialImageSearch?.width ?? ""
                responseHandler.facefacialImageSearchheight = response.bfResponseDto?.facialImageSearch?.height ?? ""
                responseHandler.facefacialImageSearchbuffer = response.bfResponseDto?.facialImageSearch?.buffer ?? ""
                responseHandler.facefacialImageSearchformatType = response.bfResponseDto?.facialImageSearch?.formatType ?? ""
                
                
                responseHandler.rsValidacionDocScoreValidacion = response.ocrDto?.rsValidacionDoc?.scoreValidacion ?? ""
                responseHandler.rsValidacionDocResultadoValidacion = response.ocrDto?.rsValidacionDoc?.resultadoValidacion ?? ""
                
                responseHandler.rsOcrAge = response.ocrDto?.rsOcr?.age ?? ""
                responseHandler.rsOcrSex = response.ocrDto?.rsOcr?.sex ?? ""
                responseHandler.rsOcrLastName = response.ocrDto?.rsOcr?.lastName ?? ""
                responseHandler.rsOcrFirstName = response.ocrDto?.rsOcr?.firstName ?? ""
                responseHandler.rsOcrDateOfBirth = response.ocrDto?.rsOcr?.dateOfBirth ?? ""
                responseHandler.rsOcrDateOfExpiry = response.ocrDto?.rsOcr?.dateOfExpiry ?? ""
                
                responseHandler.rsOcrResultadoBioCodError = response.ocrDto?.rsOcrResultado?.bioCodError ?? ""
                responseHandler.rsOcrResultadoBioDeError = response.ocrDto?.rsOcrResultado?.bioDeError ?? ""
                responseHandler.rsOcrResultadoBioCodErrorVB = response.ocrDto?.rsOcrResultado?.bioCodErrorVB ?? ""
                responseHandler.rsOcrResultadoBioCodesErrorVB = response.ocrDto?.rsOcrResultado?.bioCodesErrorVB ?? ""
                responseHandler.rsOcrResultadoBioScore = response.ocrDto?.rsOcrResultado?.bioScore ?? ""
                
                responseHandler.rsEvaluacionEdadEdadAprox = response.ocrDto?.rsEvaluacionEdad?.edadAprox ?? ""
                responseHandler.rsEvaluacionEdadEesultadoValidacion = response.ocrDto?.rsEvaluacionEdad?.resultadoValidacion ?? ""
                
                responseHandler.rsOcrSelfiebioCodError = response.ocrDto?.rsOcrSelfie?.bioCodError ?? ""
                responseHandler.rsOcrSelfiebioDeError = response.ocrDto?.rsOcrSelfie?.bioDeError ?? ""
                responseHandler.rsOcrSelfiebioCodErrorVB = response.ocrDto?.rsOcrSelfie?.bioCodErrorVB ?? ""
                responseHandler.rsOcrSelfiebioDeErrorVB = response.ocrDto?.rsOcrSelfie?.bioDeErrorVB ?? ""
                responseHandler.rsOcrSelfieidTxn = response.ocrDto?.rsOcrSelfie?.idTxn ?? ""
                responseHandler.rsOcrSelfienuSolicitud = response.ocrDto?.rsOcrSelfie?.nuSolicitud ?? ""
                responseHandler.rsOcrSelfiebioScore = response.ocrDto?.rsOcrSelfie?.bioScore ?? ""
                
                responseHandler.rsValidacionDatosbioCodError = response.ocrDto?.rsValidacionDatos?.bioCodError ?? ""
                responseHandler.rsValidacionDatosbioDeError = response.ocrDto?.rsValidacionDatos?.bioDeError ?? ""
                responseHandler.rsValidacionDatosbioCodErrorVB = response.ocrDto?.rsValidacionDatos?.bioCodErrorVB ?? ""
                responseHandler.rsValidacionDatosbioDeErrorVB = response.ocrDto?.rsValidacionDatos?.bioDeErrorVB ?? ""
                responseHandler.rsValidacionDatosbioScore = response.ocrDto?.rsValidacionDatos?.bioScore ?? ""
                
                completion(responseHandler)
                
            case .error(let error):
                let errorHandler = ReactResponse()
                errorHandler.coError = error.coError
                errorHandler.deError = error.deError
                completion(errorHandler)
                
            }
            
        }
    }*/
    
}
class ViewController: UIViewController {

    class func instantiate() -> ViewController {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Identifier") as! ViewController
        return controller
    }

}

@objcMembers public class ReactRequest : NSObject{
    public var token:String=""
    public var bioOperacion:String = "FULL"
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

@objcMembers public class ReactResponse : NSObject {
    public var coError:String="8000"
    public var deError:String="8000:Operación correcta"
    public var soliNuOperacion:String=""
    public var facebioCodError:String=""
    public var facebioDeError:String=""
    public var facebioCodErrorReniec:String?
    public var facebioDeErrorReniec:String?
    public var facebioTiDoc:String = "1"
    public var facebioNuDoc:String = ""
    public var facebioPreNom:String = ""
    public var facebioApPat:String = ""
    public var facebioApMat:String = ""
    public var facebioScore:String = ""
    public var faceidTxn:String = ""
    public var facenuSolicitud:String = ""
    public var facefacialImageSearchbuffer:String = ""
    public var facefacialImageSearchformatType:String = ""
    public var facefacialImageSearchheight:String = ""
    public var facefacialImageSearchwidth:String = ""
    
    public var rsValidacionDocScoreValidacion:String = ""
    public var rsValidacionDocResultadoValidacion:String = ""
    
    public var rsOcrFirstName:String?
    public var rsOcrLastName:String?
    public var rsOcrDateOfExpiry:String?
    public var rsOcrDateOfBirth:String?
    public var rsOcrSex:String?
    public var rsOcrAge:String?
    
    public var rsOcrResultadoBioCodError:String?
    public var rsOcrResultadoBioDeError:String?
    public var rsOcrResultadoBioCodErrorVB:String?
    public var rsOcrResultadoBioCodesErrorVB:String?
    public var rsOcrResultadoBioScore:String?
    
    public var rsEvaluacionEdadEdadAprox:String?
    public var rsEvaluacionEdadEesultadoValidacion:String?
    
    public var rsOcrSelfiebioCodError:String?
    public var rsOcrSelfiebioDeError:String?
    public var rsOcrSelfiebioCodErrorVB:String?
    public var rsOcrSelfiebioDeErrorVB:String?
    public var rsOcrSelfieidTxn:String?
    public var rsOcrSelfienuSolicitud:String?
    public var rsOcrSelfiebioScore:String?
    
    public var rsValidacionDatosbioCodError:String?
    public var rsValidacionDatosbioDeError:String?
    public var rsValidacionDatosbioCodErrorVB:String?
    public var rsValidacionDatosbioDeErrorVB:String?
    public var rsValidacionDatosbioScore:String?
    
}
