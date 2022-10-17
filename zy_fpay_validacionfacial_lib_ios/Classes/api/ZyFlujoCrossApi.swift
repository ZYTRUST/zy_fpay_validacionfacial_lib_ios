//
//  ZyFlujoFacial.swift
//  zy_fpay_validacionfacial_lib_ios
//
//  Created by Edwin on 05/03/2022.
//

import Foundation
#if !targetEnvironment(simulator)
import zy_lib_idemia_face_ios
import zy_lib_become_ocr_ios
#endif
import zy_lib_ui_ios

class ZyFlujoCrossApi {
    
    public typealias CallbackFlujo = (ZyLibResult<ZyFlujoCrossResponse , ZyLibError >) -> Void
    var callback:CallbackFlujo!
    var vc: UIViewController!
    var timeToinit = 0.3
    var placeOfBirth:String?
    var dateOfIssue:String?
    var bioFechaEmission:String?
    var bioGenero:String?
    var nacionality:String?
    var apellidos:String?
    var feExpiry:String?
    var confirmView: ZyUILoadingView!

    
    static var shared: ZyFlujoCrossApi = {
        let instance = ZyFlujoCrossApi()
        // ... configure the instance
        return instance
    }()
    
    private init() {
        
    }
    
    private let edgeApi = ZyTEdgeClient.shared
    
    func generarExpediente(request:ZyCrossRequest,
                           completion:@escaping CallbackFlujo){
        print("===>>> func init generarExpediente ")
        
        self.confirmView.textUi.text = "Estamos activando tu cámara para el reconocimiento facial"
        callback = completion
        
        if (request.bmoNuSolicitud != ""){
            var soli = SolicitudCrossDataOptional(soliId: Int(request.bmoNuSolicitud)!, solNuOperacionEmps: "", solNumClientes: 1, solTsolId: 0, bmoSolicitudDetalles: nil)
            
            self.obtenerConfiguracion(request: request,
                                      solicitud: soli )
            return
        }
        
        
        var solicitud = SolicitudCrossRequest()
        solicitud.solTsolId = 14
        
        var solicitudDetalle = SolicitudDetalleRequest()
        solicitudDetalle.sdetTopeId = 1
        solicitudDetalle.sdetTiDoc = Int(request.bioTiDoc)
        solicitudDetalle.sdetNuDoc = request.bioNuDoc
        
        switch (request.bioPais.uppercased()){
        case "PE":
            print("=====>>> Flujo PERU")
            if (request.bioOperacion == ZyTipoOperacion.FACIAL){
                solicitudDetalle.sdetFlujoFirma =  ZyTipoOperacion.FACIAL.rawValue//15 //11
            }else{
                solicitudDetalle.sdetFlujoFirma =  ZyTipoOperacion.FULL.rawValue//12 //11
            }
            break
        case "CO":
            print("=====>>> Flujo COLOMBIA")
            solicitudDetalle.sdetFlujoFirma =  ZyTipoOperacion.FLUJO_COLOMBIA.rawValue//12 //11
            break
            
        default:
            self.dismissLoading(isDialogActivo: request.isDialogActivated)
            let zyError = ZyLibError(coError: String(ZyErronEnum.ERROR_BIO_PAIS_ERROR.rawValue),
                                     deError: ZyErronEnum.ERROR_BIO_PAIS_ERROR.descripcion,
                                     soliNuOperacion: nil ,
                                     bfResponseDto: nil ,
                                     ocrDto: nil )
            
            self.callback(.error(zyError))
            return
        }
        
        solicitud.bmoSolicitudDetalles = solicitudDetalle
        print("call generarSolicitud")
        edgeApi.generarSolicitudExpediente(request: solicitud)
        { (result:ZyTApiResult<SolicitudCrossData, ZyTApiError>) in
            
            switch result {
            case .success(let data):
                print("===>>> :: fin generarExpediente ")
                print("solicitud creada \(data.soliId)")
                
                var sol = SolicitudCrossDataOptional(soliId: data.soliId, solNuOperacionEmps: data.solNuOperacionEmps, solNumClientes: data.solNumClientes, solTsolId: data.solTsolId, bmoSolicitudDetalles: data.bmoSolicitudDetalles)
                
                self.obtenerConfiguracion(request: request,
                                          solicitud: sol)
                
            case .error(let error):
                print("===>>> :: fin generarExpediente ")
                
                self.dismissLoading(isDialogActivo: request.isDialogActivated)
                let zyError = ZyLibError(coError: String(error.coError ?? 0),
                                         deError: error.deError,
                                         soliNuOperacion: nil ,
                                         bfResponseDto: nil ,
                                         ocrDto: nil )
                
                self.callback(.error(zyError))
            }
        }
    }
    
    
    func obtenerConfiguracion(request:ZyCrossRequest,
                              solicitud:SolicitudCrossDataOptional){
        print("===>>> func init obtenerConfiguracion ")
        self.confirmView.textUi.text = "Estamos activando tu cámara para el reconocimiento facial"

        var process = ProcesarCrossRequest()
        process.soliId = solicitud.soliId
        process.tipoOperacionType = "CONSULTAR_CONFIGURACION_COMPONENTE"
        
        var soliClienteRequest = SoliClienteRequest()
        
        soliClienteRequest.soliCliTiDoc = tipoDocToDni(tipoDocInput:request.bioTiDoc)
        print("====>> tipoDoc \(soliClienteRequest.soliCliTiDoc) ")
        soliClienteRequest.soliCliNuDoc = request.bioNuDoc
        
        let soliCliConfiguracion = SoliCliConfiguracionRequest()
        
        soliClienteRequest.soliCliConfiguracion = soliCliConfiguracion
        process.soliCliente = soliClienteRequest
        
        print("call CONSULTAR_CONFIGURACION_COMPONENTE")
        edgeApi.procesarFlujo(request: process)
        { (result:ZyTApiResult<ProcesarCrossData, ZyTApiError>) in
            
            switch result {
            case .success(let data):
                print("===>>> :: fin obtenerConfiguracion ")
                
                //VALIDAMOS QUE NO SEAN NULO
                guard let responseDto = data.bmoComponenteResponseDto,
                      let bmoCompId = responseDto.bmoCompId else{
                    
                    let zyError =
                    ZyLibError(coError: String(ZyErronEnum.ERROR_RESPONSE_DATOS_NULOS.rawValue),
                               deError: ZyErronEnum.ERROR_RESPONSE_DATOS_NULOS.descripcion,
                               soliNuOperacion: nil ,
                               bfResponseDto: nil ,
                               ocrDto: nil )
                    self.dismissLoading(isDialogActivo: request.isDialogActivated)
                    self.callback(.error(zyError))
                    return
                }
                
                print("bmoCompId =\(bmoCompId) 1=CAPTURA PDV")
                
                var result = ZyFlujoCrossResponse()
                result.solicitud = solicitud
                result.configuracion = data
                result.bmoCompId = bmoCompId   // INDICADOR DE ETAPA
                self.callback(.success(result))
                
            case .error(let error):
                print("===>>> :: fin obtenerConfiguracion ")
                self.dismissLoading(isDialogActivo: request.isDialogActivated)
                
                let zyError = ZyLibError(coError: String(error.coError ?? 0),
                                         deError: error.deError,
                                         soliNuOperacion:error.data?.soliNuOperacion,
                                         bmoNuSolicitud: String(solicitud.soliId),
                                         bfResponseDto: nil ,
                                         ocrDto: nil )
                
                self.callback(.error(zyError))
            }
        }
    }
    
    
    func iniciarComponenteFacial(request:ZyCrossRequest,
                                 solicitud:SolicitudCrossDataOptional,
                                 configuracion:ProcesarCrossData){
#if !targetEnvironment(simulator)
        
        //VALIDAMOS QUE NO SEAN NULO
        print("===>> init func iniciarComponenteFacial")
        print("CONFIGURACION")
        print(configuracion)
                
        guard let responseDto = configuracion.bmoComponenteResponseDto,
              let confDto = responseDto.bmoConfiguracionDTO else{
            
            let zyError =
            ZyLibError(coError: String(ZyErronEnum.ERROR_RESPONSE_DATOS_NULOS.rawValue),
                       deError: ZyErronEnum.ERROR_RESPONSE_DATOS_NULOS.descripcion,
                       bfResponseDto: nil ,
                       ocrDto: nil)
            self.callback(.error(zyError))
            return
        }
        
        let requestIdemia = ZyIdemFacialRequest()
        requestIdemia.zyTimeOut = confDto.confTimeoutPdv ?? "30"
        requestIdemia.zyTipoReto = confDto.confTipoRetoPdv ?? "PASSIVE"
        requestIdemia.zyNumeroPuntos = Int(responseDto.bmoConfiguracionDTO?.confNumeroPuntosPdv ?? "1")! as NSNumber
        requestIdemia.zyNivelSeguridad = confDto.confNivelSeguridadPdv ?? "LOW"
        
        let bio = ZyTFlujoFacial.init(ui: vc)
        
        bio.capturarSelfie(requestIdemia) { response in
            
            print("====>> Response Captura Facial ")
            print("coError:  \(response.coError)")
            print("deError:  \(response.deError)")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + self.timeToinit) {
                
                self.wsCapturaPDV(request: request,
                                  solicitud: solicitud,
                                  configuracion: configuracion,
                                  idemia: response)
                
            }
        }
#endif
        
    }
    
#if !targetEnvironment(simulator)
    
    func wsCapturaPDV(request:ZyCrossRequest,
                      solicitud:SolicitudCrossDataOptional,
                      configuracion:ProcesarCrossData,
                      idemia:ZyIdemFacialResponse){
        print("===>>> func init wsCaptura PDV ")
        //idemia.coError = "9105"
        if (request.bioPais.uppercased() == "CO"){
            self.confirmView.textUi.text = "El siguiente paso es verificar tu cédula, asegúrate de tenerla a mano"
        }else{
            self.confirmView.textUi.text = ""
        }
        var process = ProcesarCrossRequest()
        process.soliId = solicitud.soliId
        process.tipoOperacionType = "COMP_CAPTURAR_PDV"
        
        var soliClienteRequest = SoliClienteRequest()
        soliClienteRequest.soliCliTiDoc = tipoDocToDni(tipoDocInput:request.bioTiDoc)
        soliClienteRequest.soliCliNuDoc = request.bioNuDoc
        
        var soliCliConfiguracion = SoliCliConfiguracionRequest()
        soliCliConfiguracion.coError = idemia.coError
        soliCliConfiguracion.deError = idemia.deError
        
        print("===>>> IDEMIA :")
        print("===>>> IDEMIA coError: \(idemia.coError)")
        print("===>>> IDEMIA deError: \(idemia.deError)")
        
        soliClienteRequest.soliCliConfiguracion = soliCliConfiguracion
        
        var soliImagenRefRequest = SoliImagenReferenciaRequest()
        if (idemia.coError == "8000"){
            soliImagenRefRequest.buffer = idemia.bioFaceImg
            soliImagenRefRequest.formatType = "JPEG"
            soliImagenRefRequest.width = Int(truncating: idemia.bioFaceWidth)
            soliImagenRefRequest.height = Int(truncating: idemia.bioFaceHeigh)
        }else {
            soliImagenRefRequest.buffer = ""
            soliImagenRefRequest.formatType = "JPEG"
            soliImagenRefRequest.width = 0
            soliImagenRefRequest.height = 0
        }
        
        
        soliClienteRequest.bmofImagenReferencia = soliImagenRefRequest
        
        process.soliCliente = soliClienteRequest
        print("call COMP_CAPTURAR_PDV")
        
        capturaPdvAsincrono(request:request,
                            solicitud:solicitud,
                            configuracion:configuracion,
                            process:process,
                            idemia:idemia )
    }
    
    func capturaPdvAsincrono(request:ZyCrossRequest,
                             solicitud:SolicitudCrossDataOptional,
                             configuracion:ProcesarCrossData,
                             process:ProcesarCrossRequest ,
                             idemia:ZyIdemFacialResponse){
        
        var isSilence:Bool = false
        switch idemia.coError {
        case "9104":
            print("isSilence")
            isSilence = true
        default:
            print("not Silence")
            isSilence = false
        }
        
        if (isSilence){
            let zyError =
            ZyLibError(coError: String(idemia.coError),
                       deError: idemia.deError,
                       soliNuOperacion: nil ,
                       bmoNuSolicitud: String(solicitud.soliId),
                       bfResponseDto: nil ,
                       ocrDto: nil)
            self.dismissLoading(isDialogActivo: true)
            
            self.callback(.error(zyError))
        }
        edgeApi.procesarFlujo(request: process)
        { (result:ZyTApiResult<ProcesarCrossData, ZyTApiError>) in
            
            switch result {
            case .success(let data):
                print("===>>> fin :: registrarIntento PDV success 1")
                if (isSilence){
                    return
                }
                //VALIDAMOS QUE NO SEAN NULO
                guard let responseDto = data.bmoComponenteResponseDto,
                      let bmoCompId = responseDto.bmoCompId else {
                    print("===>>> wsCaptura Pdv Error  :: ERROR_RESPONSE_DATOS_NULOS ")
                    let zyError =
                    ZyLibError(coError: String(ZyErronEnum.ERROR_RESPONSE_DATOS_NULOS.rawValue),
                               deError: ZyErronEnum.ERROR_RESPONSE_DATOS_NULOS.descripcion,
                               soliNuOperacion: nil ,
                               bmoNuSolicitud: String(solicitud.soliId),
                               bfResponseDto: nil ,
                               ocrDto: nil)
                    self.dismissLoading(isDialogActivo: request.isDialogActivated)
                    
                    self.callback(.error(zyError))
                    return
                }
                print("bmoCompId =\(bmoCompId) VALOR ESPERADO 2=VERIFICACION FACIAL")
                
                var result = ZyFlujoCrossResponse()
                
                result.solicitud = solicitud
                //result.configuracion = configuracion
                result.configuracion = data
                
                result.bmoCompId = bmoCompId   // INDICADOR DE ETAPA
                self.callback(.success(result))
                
            case .error(let error):
                print("===>>> fin :: registrarIntento PDV Error")
                if (isSilence){
                    return
                }
                self.mostrarUi(error:error ,solicitud:solicitud , configuracion:configuracion )
                
            }
        }
    }
    
#endif
    func mostrarUi(error:ZyTApiError , solicitud:SolicitudCrossDataOptional,
                   configuracion:ProcesarCrossData ){
        print("mostrarUi ==>>> error: \(error)")
        print( "=====>>>> MOSTRAR UI <<<====")
        var req = ZyUIRequest()
        req.lblOk="Volver a intentarlo"
        req.titleHexColorOk="#FFFFFFFF"
        req.bgHexColorOk="#43B02AFF"
        req.lblCancel="En otro momento"
        req.titleHexColorCancel="#43B02AFF"
        req.animated = true
        
        if (error.data == nil){
            self.retornaControlAlUsuario(req:req , error:error,solicitud: solicitud,configuracion: configuracion)
            return
        }
        
        if (error.data?.bmoComponenteResponseDto != nil){
            print("====>>> bmoCompId: \(error.data?.bmoComponenteResponseDto?.bmoCompId)")
            if (error.data?.bmoComponenteResponseDto?.bmoCompId == 19){
                print( "=====>>>> BMOCOMPID FLUJO RESULTADO")
                var result = ZyFlujoCrossResponse(errorResult:error)
                result.solicitud = solicitud
                result.configuracion = configuracion
                result.bmoCompId = error.data?.bmoComponenteResponseDto?.bmoCompId
                self.callback(.success(result))
                return
            }
        }
        
        var validacion = ""
        if (error != nil){
            if (error.coError != ZyErrorUi.ERROR_FEIGN_CLIENT.rawValue ){
                validacion = String(error.coError ?? 0)
                print( "=====>>>> codigoValidacion:  \(validacion)")
                print( "=====>>>> decodigoValidacion:  \(error.deError)")

            } else{
                validacion = String(ZyErrorUi.ERROR_FEIGN_CLIENT.rawValue)
                print( "=====>>>> ERROR_FEIGN_CLIENT:  \(validacion)")
            }
        }
        
        switch (validacion){
        case "9104":
            self.retornaControlAlUsuario(req:req , error:error,solicitud: solicitud,configuracion: configuracion)
            break
        case "9116":
            req.message = "Se superó el tiempo de espera"
            showconfirm(req: req , error: error,solicitud:solicitud , configuracion:configuracion)
            break
        case "70007":
            req.message = "No pudimos validar tu identidad"
            showconfirm(req: req , error: error,solicitud:solicitud , configuracion:configuracion)
            break
            
        case "9041","8270","15114":
            print( "=====>>>> ERROR FLUJO 9041 , 8270")
            self.retornaControlAlUsuario(req:req , error:error,solicitud: solicitud,configuracion: configuracion)
            break
        default:
#if DEBUG
            if(validacion == "8087"){
                req.message = "Excepción al consumir servicio feignclient"
                req.lblOk="Entendido"
                showalert(req: req , error: error,solicitud:solicitud , configuracion:configuracion)
                break
            }
#endif
            req.message = "Algo salió mal"
            showconfirm(req: req , error: error,solicitud:solicitud , configuracion:configuracion)
            break
        }
        
        
    }
    
    func showalert(req:ZyUIRequest ,error:ZyTApiError  , solicitud:SolicitudCrossDataOptional,
                   configuracion:ProcesarCrossData  ){
        let apiUI = ZyApiUI(onView: self.confirmView)
        
        apiUI.showAlert(request: req)
        { (result:(ZyUIAlertResult<Bool>)) in
            switch result {
            case .ok(let ok):
                DispatchQueue.main.asyncAfter(deadline: .now() + self.timeToinit) {
                    print("==>> Showalert Retorno de error")
                    self.dismissLoading(isDialogActivo: true)
                    let zyError = ZyLibError(coError: String(error.coError ?? 0) ,
                                             deError: error.deError,
                                             soliNuOperacion:error.data?.soliNuOperacion,
                                             bmoNuSolicitud: String(solicitud.soliId) ,
                                             bfResponseDto: nil ,
                                             ocrDto: nil)
                    self.callback(.error(zyError))
                    return
                }
                
            }
        }
    }
    
    
    func showconfirm(req:ZyUIRequest ,error:ZyTApiError , solicitud:SolicitudCrossDataOptional,
                     configuracion:ProcesarCrossData ){
        let apiUI = ZyApiUI(onView: topMostController())
        
        apiUI.showConfirm(request: req)
        { (result:(ZyUIConfirmResult<Bool, Bool>)) in
            switch result {
            case .ok(let ok):
                print("SHOW ok pressed")
                var result = ZyFlujoCrossResponse()
                result.solicitud = solicitud
                result.configuracion = configuracion
                result.bmoCompId = error.data?.bmoComponenteResponseDto?.bmoCompId
                self.callback(.success(result))
                break
            case .cancel(let cancel):
                print("SHOW cancel pressed")
                self.dismissLoading(isDialogActivo: true)
                self.retornaControlAlUsuario(req:req , error:error,solicitud: solicitud,configuracion: configuracion)
                break
            }
        }
    }
    
    func retornaControlAlUsuario(req:ZyUIRequest ,error:ZyTApiError , solicitud:SolicitudCrossDataOptional,
                                 configuracion:ProcesarCrossData){
        print("====>>> retornaControlAlUsuario")
        var coError:String
        var deError:String
        if (error.coError != 0){
            coError = String( error.coError ?? 0)
            deError = error.deError ?? ""
        } else{
            coError = error.data?.codError ?? "9150"
            deError = error.data?.deError ?? "9150:Data en blanco al retorna control"
        }
        self.dismissLoading(isDialogActivo: true)
        let zyError = ZyLibError(coError: coError ,
                                 deError:  deError ,
                                 soliNuOperacion:error.data?.soliNuOperacion,
                                 bmoNuSolicitud: String(solicitud.soliId) ,
                                 bfResponseDto: nil ,
                                 ocrDto: nil)
        self.callback(.error(zyError))
    }
    
    
    func validarFacial(request:ZyCrossRequest,
                       solicitud:SolicitudCrossDataOptional,
                       configuracion:ProcesarCrossData){
        print("===>>> func init validarFacial ")
        
        var process = ProcesarCrossRequest()
        process.soliId = solicitud.soliId
        process.tipoOperacionType = "COMP_VALIDAR_SELFIE"
        
        var soliClienteRequest = SoliClienteRequest()
        soliClienteRequest.soliCliTiDoc = tipoDocToDni(tipoDocInput:request.bioTiDoc)
        soliClienteRequest.soliCliNuDoc = request.bioNuDoc
        
        let soliCliConfiguracion = SoliCliConfiguracionRequest()
        
        soliClienteRequest.soliCliConfiguracion = soliCliConfiguracion
        process.soliCliente = soliClienteRequest
        
        print("call COMP_VALIDAR_SELFIE")
        edgeApi.procesarFlujo(request: process)
        { (result:ZyTApiResult<ProcesarCrossData, ZyTApiError>) in
            switch result {
                
            case .success(let data):
                print("===>>> SUCCESS fin :: validarFacial ")
                DispatchQueue.main.asyncAfter(deadline: .now() + self.timeToinit) {
                    //VALIDAMOS QUE NO SEAN NULO
                    guard let responseDto = data.bmoComponenteResponseDto,
                          let bmoCompId = responseDto.bmoCompId else{
                        
                        let zyError =
                        ZyLibError(coError: String(ZyErronEnum.ERROR_RESPONSE_DATOS_NULOS.rawValue),
                                   deError: ZyErronEnum.ERROR_RESPONSE_DATOS_NULOS.descripcion,
                                   soliNuOperacion: nil ,
                                   bfResponseDto: nil ,
                                   ocrDto: nil)
                        self.dismissLoading(isDialogActivo: request.isDialogActivated)
                        self.callback(.error(zyError))
                        return
                    }
                    print("bmoCompId =\(bmoCompId) VALOR ESPERADO 3=CAPTURA OCR")
                    
                    var result = ZyFlujoCrossResponse()
                    result.solicitud = solicitud
                    result.bmoCompId = bmoCompId   // INDICADOR DE ETAPA
                    result.configuracion = data
                    self.callback(.success(result))
                }
                
            case .error(let error):
                print("===>>> ERROR fin :: validarFacial ")
                self.mostrarUi(error:error ,solicitud:solicitud , configuracion:configuracion )
                
            }
        }
    }
    
    func iniciarCapturaOcr(request:ZyCrossRequest,
                           solicitud:SolicitudCrossDataOptional,
                           configuracion:ProcesarCrossData){
        print("===>>> func init iniciarCapturaOcr ")
#if !targetEnvironment(simulator)
        //VALIDAMOS QUE NO SEAN NULO
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            guard let responseDto = configuracion.bmoComponenteResponseDto,
                  let confDto = responseDto.bmoConfiguracionDTO else{
                
                let zyError =
                ZyLibError(coError: String(ZyErronEnum.ERROR_RESPONSE_DATOS_NULOS.rawValue),
                           deError: ZyErronEnum.ERROR_RESPONSE_DATOS_NULOS.descripcion,
                           soliNuOperacion: nil ,
                           bfResponseDto: nil ,
                           ocrDto: nil)
                print("===>> ERROR_RESPONSE_DATOS_NULOS: iniciarCapturaOcr")
                self.callback(.error(zyError))
                return
            }
            
            var ocrRequest = ZyOcrRequest()
            ocrRequest.contractId = configuracion.bmoComponenteResponseDto?.bmoConfiguracionDTO?.confContratoId
            ocrRequest.token = configuracion.bmoComponenteResponseDto?.bmoConfiguracionDTO?.confTokenBecome
            print("===>>> Token Become: \(ocrRequest.token)")
            let mytime = Date()
            let format = DateFormatter()
            format.dateFormat = "yyMMddHHmmss"
            ocrRequest.userId = String(solicitud.soliId) + "_" + format.string(from: mytime)
            print("ocrBecome userId: \(ocrRequest.userId)")
            ocrRequest.allowLibraryLoading = true
            ocrRequest.formatoFecha = "dd/MM/yy"
            ocrRequest.stringTextName = "zyFPayText"
            ocrRequest.becomePais = request.bioPais
            let ocrBio = ZyOcr(onView: self.vc)
            
            ocrBio.capturar(request: ocrRequest, validarAutenticidad: true)
            { (result:(ZyOcrResult<ZyOcrResponse, ZyOcrError>)) in
                switch result {
                case .success(let response):
                    print("===>>> fin SUCCESS:: iniciarCapturaOcr ")
                    print("===>>> placeOfBirth \(response.zyBecomeOcr.placeOfBirth) ")
                    print("===>>>  :\(response.zyBecomeOcr.placeOfBirth) documentregistry: \(response.zyBecomeOcr.zyRegistraduria?.registraduriaDocumentNumber)")
                    
                    
                    self.placeOfBirth = response.zyBecomeOcr.placeOfBirth ?? ""
                    self.dateOfIssue =  response.zyBecomeOcr.dateOfIssue ?? ""
                    self.nacionality = response.zyBecomeOcr.nationality ?? ""
                    
                    self.wsCapturaOCR(request: request,
                                      solicitud: solicitud,
                                      configuracion: configuracion,
                                      ocrResponse: response,
                                      ocrError: nil)
                    break
                    
                case .error(let error):
                    print("===>>> fin ERROR :: iniciarCapturaOcr ")
                    self.wsCapturaOCR(request: request,
                                      solicitud: solicitud,
                                      configuracion: configuracion,
                                      ocrResponse: nil,
                                      ocrError: error)
                }
            }
        }
#endif
        
        
    }
    
#if !targetEnvironment(simulator)
    
    func wsCapturaOCR(request:ZyCrossRequest,
                      solicitud:SolicitudCrossDataOptional,
                      configuracion:ProcesarCrossData,
                      ocrResponse:ZyOcrResponse? ,
                      ocrError: ZyOcrError?) {
        print("===>>> func init wsCapturaOCR ")
        self.confirmView.textUi.text = ""

        
        var process = ProcesarCrossRequest()
        process.soliId = solicitud.soliId
        process.tipoOperacionType = "COMP_CAPTURAR_OCR"
        
        var soliClienteRequest = SoliClienteRequest()
        soliClienteRequest.soliCliTiDoc = tipoDocToDni(tipoDocInput:request.bioTiDoc)
        soliClienteRequest.soliCliNuDoc = request.bioNuDoc
        
        let soliCliConfiguracion = SoliCliConfiguracionRequest()
        soliClienteRequest.soliCliConfiguracion = soliCliConfiguracion
        
        
        var soliCliDniOcr = SoliCliDniOcr()
        var documento = DocumentoOcr()
        var status = StatusOcr()
        var registraduria = SoliCliDatos()
        
        if (ocrResponse != nil){
            let become = ocrResponse!.zyBecomeOcr
            documento.isoCountryAlpha2 = become.ocrIsoAlpha2CountryCode
            documento.dni = become.documentNumber
            documento.imgFront = become.frontImage!.jpegData(compressionQuality: 1)?.base64EncodedString()
            documento.imgRear = become.backImage!.jpegData(compressionQuality: 1)?.base64EncodedString()
            documento.feNac = become.dateOfBirth
            documento.deNacionalidad = ""
            documento.sex = become.sex
            documento.feInscripcion = ""
            documento.feEmision = become.dateOfIssue
            documento.estCivil = ""
            documento.ubigeo = ""
            documento.codOACI = ""
            documento.departamento = ""
            documento.provincia = ""
            documento.distrito = ""
            documento.direccion = ""
            documento.donanteOrganos = ""
            documento.grupoVotacion = ""
            documento.digitoVerificador = ""
            documento.dniDigitoChequeoMrz = ""
            documento.dniBarcode = ""
            documento.nombres = become.firstName
            
            //documento.isValidoDniDigitoChkMrz = true
            switch(become.typeDoc){
            case .typeAlienId:
                documento.tipoDni = "2"
                break
            case .typeId:
                documento.tipoDni = "1"
                break
            default:
                documento.tipoDni = "0"
                break
            }
            
            print("FeExp -> \(become.dateOfExpiry)")
            self.feExpiry = become.dateOfExpiry
            documento.feExp = become.dateOfExpiry
            
            switch (become.ocrIsoAlpha2CountryCode){
            case "PE":
                documento.apMaterno = become.apMaterno
                documento.apPaterno = become.apPaterno
                documento.feExp = become.dateOfExpiry
                
                break
            case "CO":
                self.apellidos = become.lastName
                documento.apellidos = become.lastName
                documento.distrito = become.placeOfBirth
                documento.deNacionalidad = become.nationality
                
                registraduria.coError = String(become.zyRegistraduria?.coErrorRegistraduria ?? 0)
                registraduria.deError = become.zyRegistraduria?.deErrorRegistraduria ?? ""
                registraduria.dni = request.bioNuDoc
                registraduria.nombres =  (become.zyRegistraduria?.registraduriaName ?? "") + " " + (become.zyRegistraduria?.registraduriaMiddleName ?? "")
                registraduria.apPaterno =  become.zyRegistraduria?.registraduriaSurname
                registraduria.apMaterno = become.zyRegistraduria?.registraduriaSecondSurname
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd"
                
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "dd/MM/yy"
                
                print("Registraduria coError: \(become.zyRegistraduria?.coErrorRegistraduria)")
                if (become.zyRegistraduria?.coErrorRegistraduria == ZyErronEnum.EXITO.rawValue){
                    do{
                        print("registraduria feEmision: \(become.zyRegistraduria?.registraduriaEmissionDate)")
                        
                        if !(become.zyRegistraduria?.registraduriaEmissionDate ?? "").isEmpty {
                            print("no vacioregistraduriaEmissionDate ")
                            let date: NSDate? = try dateFormatterGet.date(from: become.zyRegistraduria?.registraduriaEmissionDate ?? "1900-01-01") as NSDate?
                            registraduria.feEmision = try dateFormatterPrint.string(from: date! as Date)
                            print("registraduria.feEmision: \(registraduria.feEmision)")
                            self.bioFechaEmission = registraduria.feEmision
                            
                        }
                        if !(become.zyRegistraduria?.registraduriaGender ?? "").isEmpty {
                            print("no genero de registraduria ")
                            registraduria.sex = become.zyRegistraduria?.registraduriaGender
                            //TODO: Resolver gender de registraduria
                            self.bioGenero = become.zyRegistraduria?.registraduriaGender
                        }
                        
                    } catch{
                        print("registraduriaEmissionDate null")
                    }
                    print("feEmision:\(registraduria.feEmision)")
                    registraduria.distrito =  become.zyRegistraduria?.registraduriaIssuePlace
                    soliCliDniOcr.registraduria = registraduria
                }
                
                break
                
            default:
                break
                
            }
            
            soliCliDniOcr.documento = documento
            
            status.codigoRespuesta = String(ocrResponse!.coError)
            status.descripcionRespuesta = ocrResponse?.deError
            status.lvProbability = become.livenessProbability
            status.lvScore = become.livenessScore
            status.qaScore = become.qualityScore
            
        } else{
            status.codigoRespuesta = String(ocrError!.coError)
            status.descripcionRespuesta = ocrError?.deError
        }
        soliCliDniOcr.status = status
        
        soliClienteRequest.soliCliDniOcr = soliCliDniOcr

        process.soliCliente = soliClienteRequest
        process.soliId = solicitud.soliId
        process.tipoOperacionType = "COMP_CAPTURAR_OCR"

        print("call COMP_CAPTURAR_OCR")
        
        capturaOcrAsincrono(request:request,
                            solicitud:solicitud,
                            configuracion:configuracion,
                            process:process,
                            ocrResponse:ocrResponse,
                            ocrError: ocrError)
    }
    
    func capturaOcrAsincrono(request:ZyCrossRequest,
                             solicitud:SolicitudCrossDataOptional,
                             configuracion:ProcesarCrossData,
                             process:ProcesarCrossRequest ,
                             ocrResponse:ZyOcrResponse?,
                             ocrError: ZyOcrError?){
        
        var isSilence:Bool = false
        if (ocrError != nil){
            switch ocrError?.coError{
            case 9104:
                print("isSilence")
                isSilence = true
            default:
                print("not Silence")
                isSilence = false
            }
        }
        
        
        if (isSilence){
            let zyError =
            ZyLibError(coError: String(ocrError?.coError ?? 9104),
                       deError: ocrError?.deError,
                       soliNuOperacion: nil ,
                       bmoNuSolicitud: String(solicitud.soliId),
                       bfResponseDto: nil ,
                       ocrDto: nil)
            self.dismissLoading(isDialogActivo: true)
            self.callback(.error(zyError))
        }
        edgeApi.procesarFlujo(request: process)
        { (result:ZyTApiResult<ProcesarCrossData, ZyTApiError>) in
            
            switch result {
            case .success(let data):
                print("===>>> fin :: registrarIntento PDV success 1")
                if (isSilence){
                    return
                }
                //VALIDAMOS QUE NO SEAN NULO
                guard let responseDto = data.bmoComponenteResponseDto,
                      let bmoCompId = responseDto.bmoCompId else {
                    print("===>>> wsCaptura Pdv Error  :: ERROR_RESPONSE_DATOS_NULOS ")
                    let zyError =
                    ZyLibError(coError: String(ZyErronEnum.ERROR_RESPONSE_DATOS_NULOS.rawValue),
                               deError: ZyErronEnum.ERROR_RESPONSE_DATOS_NULOS.descripcion,
                               soliNuOperacion: nil ,
                               bmoNuSolicitud: String(solicitud.soliId),
                               bfResponseDto: nil ,
                               ocrDto: nil)
                    self.dismissLoading(isDialogActivo: request.isDialogActivated)
                    
                    self.callback(.error(zyError))
                    return
                }
                print("bmoCompId =\(bmoCompId) VALOR ESPERADO 2=VERIFICACION FACIAL")
                
                var result = ZyFlujoCrossResponse()
                result.solicitud = solicitud
                result.configuracion = configuracion
                result.bmoCompId = bmoCompId   // INDICADOR DE ETAPA
                self.callback(.success(result))
                
            case .error(let error):
                print("===>>> fin :: registrarIntento PDV Error")
                if (isSilence){
                    return
                }
                self.mostrarUi(error:error ,solicitud:solicitud , configuracion:configuracion )
                
            }
        }
    }
#endif
    
    func validacionOcr(request:ZyCrossRequest,
                       solicitud:SolicitudCrossDataOptional,
                       configuracion:ProcesarCrossData){
        print("===>>> func init validacionOcr ")
        
        var process = ProcesarCrossRequest()
        process.soliId = solicitud.soliId
        process.tipoOperacionType = "COMP_VALIDAR_OCR"
        
        var soliClienteRequest = SoliClienteRequest()
        soliClienteRequest.soliCliTiDoc = tipoDocToDni(tipoDocInput:request.bioTiDoc)
        soliClienteRequest.soliCliNuDoc = request.bioNuDoc
        
        let soliCliConfiguracion = SoliCliConfiguracionRequest()
        soliClienteRequest.soliCliConfiguracion = soliCliConfiguracion
        
        process.soliCliente = soliClienteRequest
        print("call COMP_VALIDAR_OCR")
        
        edgeApi.procesarFlujo(request: process)
        { (result:ZyTApiResult<ProcesarCrossData, ZyTApiError>) in
            
            switch result {
            case .success(let data):
                print("===>>> fin :: validacionOcr ")
                //VALIDAMOS QUE NO SEAN NULO
                guard let responseDto = data.bmoComponenteResponseDto,
                      let bmoCompId = responseDto.bmoCompId else{
                    
                    let zyError =
                    ZyLibError(coError: String(ZyErronEnum.ERROR_RESPONSE_DATOS_NULOS.rawValue),
                               deError: ZyErronEnum.ERROR_RESPONSE_DATOS_NULOS.descripcion,
                               soliNuOperacion: nil ,
                               bfResponseDto: nil ,
                               ocrDto: nil)
                    self.dismissLoading(isDialogActivo: request.isDialogActivated)
                    self.callback(.error(zyError))
                    return
                }
                print("bmoCompId =\(bmoCompId) VALOR ESPERADO 4=VALIDACION OCR")
                
                var result = ZyFlujoCrossResponse()
                result.solicitud = solicitud
                result.configuracion = configuracion
                result.bmoCompId = bmoCompId   // INDICADOR DE ETAPA
                self.callback(.success(result))
                
            case .error(let error):
                print("===>>> ERROR fin :: WS VALIDACION OCR ")
                self.mostrarUi(error:error ,solicitud:solicitud , configuracion:configuracion )
            }
        }
    }
    
    func obtenerResultados(request:ZyCrossRequest,
                           solicitud:SolicitudCrossDataOptional,
                           configuracion:ProcesarCrossData){
        
        print("===>>> func init obtenerResultados ")
                
        var process = ProcesarCrossRequest()
        process.soliId = solicitud.soliId
        print("==>>> BMO ID SOLICITUD: \(process.soliId)")
        
        process.tipoOperacionType = "COMP_OBTENER_RESULTADOS_BIO"
        
        var soliClienteRequest = SoliClienteRequest()
        soliClienteRequest.soliCliTiDoc = tipoDocToDni(tipoDocInput:request.bioTiDoc)
        soliClienteRequest.soliCliNuDoc = request.bioNuDoc
        
        let soliCliConfiguracion = SoliCliConfiguracionRequest()
        soliClienteRequest.soliCliConfiguracion = soliCliConfiguracion
        
        process.soliCliente = soliClienteRequest
        print("call COMP_OBTENER_RESULTADOS_BIO")
        
        edgeApi.procesarFlujo(request: process)
        { (result:ZyTApiResult<ProcesarCrossData, ZyTApiError>) in
            
            switch result {
            case .success(let data):
                print("===>>> fin :: obtenerResultados ")
                var result = ZyFlujoCrossResponse()
                result.solicitud = solicitud
                result.configuracion = configuracion
                result.resultado = data
                result.bmoCompId = 0   // INDICADOR FIN ETAPA
                
                self.callback(.success(result))
                break
                
            case .error(let error):
                print("===>>> fin :: obtenerResultados ")
                self.dismissLoading(isDialogActivo: request.isDialogActivated)
                
                if (error.data != nil){
                    var resError = ZyFlujoCrossResponse(errorResult: error)
                    resError.solicitud = solicitud
                    resError.configuracion = configuracion
                    resError.bmoCompId = 0   // INDICADOR DE ETAPA
                    self.callback(.success(resError))
                    return
                }
                
                let zyError = ZyLibError(coError: String(error.coError ?? 0),
                                         deError: error.deError,
                                         soliNuOperacion: nil ,
                                         bfResponseDto: nil ,
                                         ocrDto: nil)
                self.dismissLoading(isDialogActivo: request.isDialogActivated)
                self.callback(.error(zyError))
                break
            }
        }
    }
    
    func dismissLoading(isDialogActivo:Bool){
        if(isDialogActivo){
            print("=====>>> Zy dismiss loading")
            self.vc.dismiss(animated: false, completion: nil)
        }
    }
    
    func topMostController() -> UIViewController {
        var topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        while (topController.presentedViewController != nil) {
            topController = topController.presentedViewController!
        }
        return topController
    }
    
}
