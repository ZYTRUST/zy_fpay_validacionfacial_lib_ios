//
//  ZyApiUI.swift
//  zy_lib_ui_ios
//
//  Created by Edwin on 05/20/2022.
//

import Foundation

public class ZyLoadingApiUI {
    
    public typealias CallbackLoadingUI = (ZyUILoadingResult<Bool, Bool>) -> Void
    
    private var vc: UIViewController
    
    public init(onView:UIViewController){
        vc = onView
    }
    
    public func showConfirm(request:ZyUILoadingRequest,
                            completion:@escaping CallbackLoadingUI){
        let confirmApi = ZyUILoadingApi(onView: vc)
        confirmApi.showConfirm(request: request)
        { (result:(ZyUILoadingResult<Bool, Bool>)) in
            
            switch result {
                case .ok(let result):
                    completion(.ok(result))
                case .cancel(let result):
                    completion(.cancel(result))
            }
        }
    }
    
    
    
}
