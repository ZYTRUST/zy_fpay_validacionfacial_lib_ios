//
//  ZyApiCross.swift
//  zy_fpay_validacionfacial_lib_ios
//
//  Created by Edwin on 05/03/2022.
//

import Foundation

@objc(ZyApiCross)
public class ZyApiCross:NSObject{
    
    public typealias CallbackLogin = (ZyLibResult<String, ZyLibError>) -> Void
    public typealias CallbackResponse = (ZyLibResult<ZyCrossResponse, ZyLibError>) -> Void
    
    private var vc: UIViewController
    private var callback:CallbackResponse!
    
    private let oauthApi : ZyTOauthClient
    private let flujoApi : ZyFlujoCrossApi
    //private let flujoOcrApi : ZyFlujoOcr
    private var request : ZyCrossRequest!
    private var confirmView:ZyUILoadingView!

    @objc public init(onView:UIViewController){
        
        vc = onView
        oauthApi = ZyTOauthClient.shared
        flujoApi = ZyFlujoCrossApi.shared
        //flujoOcrApi = ZyFlujoOcr.shared
    }
    
    public func login(ruc:String,
                      user:String,
                      pass:String,
                      completion:@escaping CallbackLogin){
        LoginSetting.ruc = ruc
        LoginSetting.passwd = pass
        LoginSetting.usuario = user
        
        oauthApi.autenticar()
        { (result:ZyTApiResult<String, ZyTApiError>) in
            
            switch result {
            case .success(let data):
                completion(.success(data))
            case .error(let error):
                completion(.error(ZyLibError(coError: String(error.coError ?? 0),
                                             deError: error.deError,
                                             soliNuOperacion: "",
                                             bfResponseDto: nil,
                                             ocrDto: nil
                                             
                                            ) ))
            }
        }
    }
    
    
    
    public func iniciarFlujo(request:ZyCrossRequest,
                             completion:@escaping CallbackResponse){
        callback = completion
#if !targetEnvironment(simulator)
        LoginSetting.token = request.token
        
        confirmView = ZyUILoadingView.instantiate(fromStoryboard: "zyfpaydialog",withBundle: type(of: self))
        var req = ZyUILoadingRequest()
        confirmView.modalPresentationStyle = .overCurrentContext
        confirmView.request = req
        //confirmView.delegate = vc as! any ZyUILoadingDelegateProtocol
        vc.present(confirmView,animated: true, completion:{})
        
        flujoApi.vc = confirmView
        flujoApi.confirmView = confirmView
        self.request = request
        
        flujoCross(request: request)
#else
        let zyError =
        ZyLibError(coError: String(ZyErronEnum.ERROR_NO_FUNCIONA_SIMULADOR.rawValue),
                   deError: ZyErronEnum.ERROR_NO_FUNCIONA_SIMULADOR.descripcion,
                   soliNuOperacion: nil ,
                   bfResponseDto: nil ,
                   ocrDto: nil
        )
        
        self.callback(.error(zyError))
#endif
        
    }
    
    
    func flujoCross(request:ZyCrossRequest){
        
        flujoApi.generarExpediente(request: request)
        { (result:ZyLibResult<ZyFlujoCrossResponse, ZyLibError>) in
            
            switch result {
            case .success(let response):
                
                switch response.bmoCompId {
                case 1:print("ZYT INICIA CAPTURA FACIAL")
                    self.confirmView.textUi.text = "Estamos activando tu cámara para el reconocimiento facial"
                    self.flujoApi.iniciarComponenteFacial(request: request,
                                                          solicitud: response.solicitud!,
                                                          configuracion: response.configuracion!)
                case 2:print("ZYT INICIA VALIDAR FACIAL")
                    self.confirmView.textUi.text = "El siguiente paso es verificar tu DNI, asegúrate de tenerlo a mano"
                    self.flujoApi.validarFacial(request: request,
                                                solicitud: response.solicitud!,
                                                configuracion: response.configuracion!)
                case 3:print("ZYT INICIA CAPTURA OCR")
                    if (request.bioPais.uppercased() == "CO"){
                        self.confirmView.textUi.text = "El siguiente paso es verificar tu cédula, asegúrate de tenerla a mano"
                    }else{
                        self.confirmView.textUi.text = "El siguiente paso es verificar tu DNI, asegúrate de tenerlo a mano"
                    }
                    self.flujoApi.iniciarCapturaOcr(request: request,
                                                    solicitud: response.solicitud!,
                                                    configuracion: response.configuracion!)
                case 4:print("ZYT INICIA VALIDACION OCR")
                    self.confirmView.textUi.text = "Estamos confirmando la captura de la imagen"
                    self.flujoApi.validacionOcr(request: request,
                                                solicitud: response.solicitud!,
                                                configuracion: response.configuracion!)
                case 19:print("ZYT INICIA OBTENER RESULTADO")
                    self.confirmView.textUi.text = "Recuerda que este proceso es exclusivamente por tu seguridad"
                    self.flujoApi.obtenerResultados(request: request,
                                                    solicitud: response.solicitud!,
                                                    configuracion: response.configuracion!)
                case 0:
                    self.apiCrossResponse(response:response)
                    
                default:
                    let zyError =
                    ZyLibError(coError: String(ZyErronEnum.ERROR_RESPONSE_DATOS_NULOS.rawValue),
                               deError: ZyErronEnum.ERROR_RESPONSE_DATOS_NULOS.descripcion,
                               soliNuOperacion: nil ,
                               bfResponseDto: nil ,
                               ocrDto: nil)
                    
                    self.callback(.error(zyError))
                    
                }
                
            case .error(let error):
                print("FIN DE FLUJO POR ERROR")
                print(error.deError)
                self.callback(.error(error))
            }
        }
    }
    
    func apiCrossResponse(response:ZyFlujoCrossResponse){
        flujoApi.dismissLoading(isDialogActivo: request.isDialogActivated)

        print("====>>>> RESULTADO LIB")
        print("====>>>> ZyFlujoCrossResponse")
        print("====>>>> ZyFlujoCrossResponse")
        
        var generalCrossResponse:ProcesarCrossData
        
        if (response.resultado != nil){
            print("====>>>> response.resultado != nil")
            generalCrossResponse = response.resultado!
        }else {
            if (response.errorResult == nil){
                print("====>>>> errorResult.data es nulo")
                let zyErrors = ZyLibError(coError: String(response.errorResult?.coError ?? 0 ) ,
                                          deError: response.errorResult?.deError,
                                          soliNuOperacion: response.solicitud?.solNuOperacionEmps ,
                                          bmoNuSolicitud: String(response.solicitud?.soliId ?? 0),
                                          bfResponseDto: nil ,
                                          ocrDto: nil)
                self.callback(.error(zyErrors))
                return
                
            }
            print("====>>>> generalCrossResponse = response.errorResult?.data")
            
            generalCrossResponse = (response.errorResult?.data)!
            //se setea el restultado en el CodError
            generalCrossResponse.codError = String(response.errorResult?.coError ?? 0)
            generalCrossResponse.deError = response.errorResult?.deError
        }
        
        
        
        var bfresponse = BfResponseDto(bioCodErrorReniec: "", bioDeErrorReniec: "" )
        
        bfresponse.bioCodError = generalCrossResponse.bmoDataBiometriaDto?.bmoDataFacialDto?.faceCodError ?? ""
        bfresponse.bioDeError = generalCrossResponse.bmoDataBiometriaDto?.bmoDataFacialDto?.faceDeError ?? ""
        bfresponse.bioCodErrorReniec = generalCrossResponse.bmoDataBiometriaDto?.bmoDataFacialDto?.faceCodErrorReniec ?? ""
        bfresponse.bioDeErrorReniec = generalCrossResponse.bmoDataBiometriaDto?.bmoDataFacialDto?.faceDeErrorReniec ?? ""
        bfresponse.bioNuDoc = generalCrossResponse.bmoDataBiometriaDto?.bmoDataFacialDto?.faceNuDoc ?? ""
        bfresponse.bioPreNom = generalCrossResponse.bmoDataBiometriaDto?.bmoDataFacialDto?.faceNombres ?? ""
        bfresponse.bioApPat = generalCrossResponse.bmoDataBiometriaDto?.bmoDataFacialDto?.faceApPaterno ?? ""
        bfresponse.bioApMat = generalCrossResponse.bmoDataBiometriaDto?.bmoDataFacialDto?.faceApMaterno ?? ""
        
        //TODO: Corregir , traer del servicio bioGenero y biofechaEmission
        bfresponse.bioGenero = flujoApi.bioGenero ?? ""
        bfresponse.biofechaEmission = flujoApi.bioFechaEmission ?? ""
        
        bfresponse.bioTiDoc = generalCrossResponse.bmoDataBiometriaDto?.bmoDataFacialDto?.faceTiDoc ?? ""
        bfresponse.bioScore = generalCrossResponse.bmoDataBiometriaDto?.bmoDataFacialDto?.faceScore ?? ""
        bfresponse.nuSolicitud = generalCrossResponse.bmoDataBiometriaDto?.bmoDataFacialDto?.faceSolicitudId ?? ""
        bfresponse.idTxn = generalCrossResponse.bmoDataBiometriaDto?.bmoDataFacialDto?.faceTransaccionId ?? ""
        bfresponse.nuIntentos = generalCrossResponse.bmoResultBioDto?.bmoResultFace?.resultNuIntentosVal ?? ""
        //TODO: Correcion de nuIntentosCaptura
        bfresponse.nuIntentosCaptura = generalCrossResponse.bmoResultBioDto?.bmoResultFace?.resultNuIntentosCap ?? ""
        
        bfresponse.facialImageSearch = FacialImageSearch(
            buffer:generalCrossResponse.bmoResultBioDto?.bmoResultFace?.resultCapFace?.capFaceBuffer ?? "" ,
            formatType:generalCrossResponse.bmoResultBioDto?.bmoResultFace?.resultCapFace?.capFaceFormat ?? "",
            height:generalCrossResponse.bmoResultBioDto?.bmoResultFace?.resultCapFace?.capFaceHeight ?? "",
            width:generalCrossResponse.bmoResultBioDto?.bmoResultFace?.resultCapFace?.capFaceWidth ?? ""
        )
        
        
        var ocrDto = OcrDto()
        ocrDto.nuIntentos = generalCrossResponse.bmoResultBioDto?.bmoResultOcr?.resultNuIntentosVal ?? ""
        
        //TODO: Correcion de nuIntentosCaptura
        ocrDto.nuIntentosCaptura = generalCrossResponse.bmoResultBioDto?.bmoResultOcr?.resultNuIntentosCap ?? ""
        
        ocrDto.rsValidacionDoc = RsValidacionDoc(
            validaDocQualityScore: generalCrossResponse.bmoDataBiometriaDto?.bmoDataOcrDto?.ocrValidacionDoc?.validaDocQualityScore ?? "",
            validaDocLivenessScore: generalCrossResponse.bmoDataBiometriaDto?.bmoDataOcrDto?.ocrValidacionDoc?.validaDocLivenessScore ?? "",
            resultadoValidacion:generalCrossResponse.bmoDataBiometriaDto?.bmoDataOcrDto?.ocrValidacionDoc?.validaDocResultado ?? ""
        )
        
        ocrDto.rsOcr = RsOcr(
            fullName:generalCrossResponse.bmoDataBiometriaDto?.bmoDataOcrDto?.ocrDataPersona?.dataPerNombreCompleto ?? "",
            firstName:generalCrossResponse.bmoDataBiometriaDto?.bmoDataOcrDto?.ocrDataPersona?.dataPerNombres ?? "",
            lastName:generalCrossResponse.bmoDataBiometriaDto?.bmoDataOcrDto?.ocrDataPersona?.dataPerApellidos ?? "",
            dateOfExpiry: generalCrossResponse.bmoResultBioDto?.bmoResultOcr?.resultCapOcr?.capOcrFeExp ?? "",
            dateOfBirth:generalCrossResponse.bmoDataBiometriaDto?.bmoDataOcrDto?.ocrDataPersona?.dataPerNacimiento ?? "",
            sex:generalCrossResponse.bmoDataBiometriaDto?.bmoDataOcrDto?.ocrDataPersona?.dataPerGenero ?? "",
            age:generalCrossResponse.bmoDataBiometriaDto?.bmoDataOcrDto?.ocrDataPersona?.dataPerEdad ?? "",
            placeOfBirth: flujoApi.placeOfBirth ?? "" ,
            dateOfIssue: flujoApi.dateOfIssue ?? ""

        )
        
        ocrDto.rsOcrResultado = RsOcrResultado(
            bioCodError:generalCrossResponse.bmoDataBiometriaDto?.bmoDataOcrDto?.ocrResultado?.ocrCodError ?? "",
            bioDeError:generalCrossResponse.bmoDataBiometriaDto?.bmoDataOcrDto?.ocrResultado?.ocrDeError ?? "",
            bioCodErrorVB:generalCrossResponse.bmoDataBiometriaDto?.bmoDataOcrDto?.ocrResultado?.ocrCodErrorVb ?? "",
            bioCodesErrorVB:generalCrossResponse.bmoDataBiometriaDto?.bmoDataOcrDto?.ocrResultado?.ocrDeErrorVb ?? "",
            bioScore:generalCrossResponse.bmoDataBiometriaDto?.bmoDataOcrDto?.ocrResultado?.ocrScore ?? ""
        )
        
        ocrDto.rsEvaluacionEdad = RsEvaluacionEdad (
            edadAprox:generalCrossResponse.bmoDataBiometriaDto?.bmoDataOcrDto?.ocrValidacionEdad?.validaEdadAprox ?? "",
            resultadoValidacion:generalCrossResponse.bmoDataBiometriaDto?.bmoDataOcrDto?.ocrValidacionEdad?.validaEdadResultado ?? ""
        )
        
        ocrDto.rsOcrSelfie = RsOcrSelfie(
            bioCodError:generalCrossResponse.bmoDataBiometriaDto?.bmoDataOcrDto?.ocrValidacionSelfie?.validaSelfieCodError ?? "",
            bioDeError:generalCrossResponse.bmoDataBiometriaDto?.bmoDataOcrDto?.ocrValidacionSelfie?.validaSelfieDeError ?? "",
            bioCodErrorVB:generalCrossResponse.bmoDataBiometriaDto?.bmoDataOcrDto?.ocrValidacionSelfie?.validaSelfieCodErrorVb ?? "",
            bioDeErrorVB:generalCrossResponse.bmoDataBiometriaDto?.bmoDataOcrDto?.ocrValidacionSelfie?.validaSelfieDeErrorVb ?? "",
            idTxn:generalCrossResponse.bmoDataBiometriaDto?.bmoDataOcrDto?.ocrValidacionSelfie?.validaSelfieTransaccionId ?? "",
            nuSolicitud:generalCrossResponse.bmoDataBiometriaDto?.bmoDataOcrDto?.ocrValidacionSelfie?.validaSelfieSolicitudId ?? "",
            bioScore:generalCrossResponse.bmoDataBiometriaDto?.bmoDataOcrDto?.ocrValidacionSelfie?.validaSelfieScore ?? ""
        )
        
        
        ocrDto.rsValidacionDatos = RsValidacionDatos(
            bioCodError:generalCrossResponse.bmoDataBiometriaDto?.bmoDataOcrDto?.ocrValidacionDatos?.validaDatosCodError ?? "",
            bioDeError:generalCrossResponse.bmoDataBiometriaDto?.bmoDataOcrDto?.ocrValidacionDatos?.validaDatosDeError ?? "",
            bioCodErrorVB:generalCrossResponse.bmoDataBiometriaDto?.bmoDataOcrDto?.ocrValidacionDatos?.validaDatosCodErrorVb ?? "",
            bioDeErrorVB:generalCrossResponse.bmoDataBiometriaDto?.bmoDataOcrDto?.ocrValidacionDatos?.validaDatosDeErrorVb ?? "",
            bioScore:generalCrossResponse.bmoDataBiometriaDto?.bmoDataOcrDto?.ocrValidacionDatos?.validaDatosScore ?? ""
            
        )
        
        var responseNew = ZyCrossResponse(bfResponseDto: bfresponse, ocrDto: ocrDto)
        
        responseNew.soliNuOperacion = generalCrossResponse.soliNuOperacion ?? ""
        
        responseNew.coError = generalCrossResponse.codError ?? ""
        responseNew.deError = generalCrossResponse.deError ?? ""
        
        let bmoNuSoli = response.solicitud!.soliId
        print("========>>>>> ANALISIS RESULTADO COMPONENTE")
        
        
        if (responseNew.coError == "8000" || responseNew.coError == "70006"  ){
            print("========>>>>> onSUCCESS")
            responseNew.bmoNuSolicitud = String(bmoNuSoli)
            //FPAY iOS toma como respuesta positiva el 70006
            responseNew.coError = String(ZyErronEnum.HIT.rawValue)
            responseNew.deError = ZyErronEnum.HIT.descripcion
            
            print("RESULTADO FINAL coError:\(responseNew.coError)")
            print("RESULTADO FINAL deError:\(responseNew.deError)")
            
            if (request.bioPais.uppercased() == "CO"){
                responseNew.ocrDto?.rsOcr?.lastName = flujoApi.apellidos ?? ""
                
                if (request.bioTiDoc == "2"){
                    responseNew.bfResponseDto?.bioTiDoc = request.bioTiDoc
                    responseNew.bfResponseDto?.bioNuDoc = request.bioNuDoc
                    
                    responseNew.ocrDto?.rsOcr?.placeOfBirth = flujoApi.nacionality ?? ""
                }
                
            }
            
            self.clean()
            self.callback(.success(responseNew))
            
        } else{
            print("========>>>>> onError")
            
            switch (responseNew.coError){
            case "70007" , "8383":
                responseNew.coError = String(ZyErrorUi.ERROR_SOLICITUD_BLOQUEADA.rawValue)
                responseNew.deError = ZyErrorUi.ERROR_SOLICITUD_BLOQUEADA.descripcion
                break
            default:
                break
            }
            print("RESULTADO FINAL coError:\(responseNew.coError)")
            print("RESULTADO FINAL deError:\(responseNew.deError)")
            
            let zyError = ZyLibError(coError: responseNew.coError,
                                     deError: responseNew.deError,
                                     soliNuOperacion: responseNew.soliNuOperacion ,
                                     bmoNuSolicitud: String(bmoNuSoli),
                                     bfResponseDto: responseNew.bfResponseDto ,
                                     ocrDto: responseNew.ocrDto
            )
            self.clean()
            
            self.callback(.error(zyError))
            
        }
        
    }
    
    func clean(){
        flujoApi.apellidos = ""
        flujoApi.bioFechaEmission = ""
        flujoApi.placeOfBirth = ""
        flujoApi.nacionality = ""
        flujoApi.dateOfIssue = ""
        flujoApi.bioGenero = ""
    }
    
}
