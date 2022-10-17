//
//  ZyUIConfirmApi.swift
//  zy_lib_ui_ios
//
//  Created by Edwin on 05/20/2022.
//

import Foundation

class ZyUILoadingApi: ZyUILoadingDelegateProtocol {

    public typealias CallbackLoadingUI = (ZyUILoadingResult<Bool, Bool>) -> Void
    private var callback:CallbackLoadingUI!
    
    private var vc: UIViewController
    
    private var confirmView:ZyUILoadingView!
    
    public init(onView:UIViewController){
        vc = onView
    }
    
    public func showConfirm(request:ZyUILoadingRequest,
                            completion:@escaping CallbackLoadingUI){
        self.callback = completion
        
        confirmView = ZyUILoadingView.instantiate(fromStoryboard: "zyfpaydialog",withBundle: type(of: self))
        confirmView.modalPresentationStyle = .overCurrentContext
        confirmView.request = request
        confirmView.delegate = self
        vc.present(confirmView,animated: true, completion:{})
    }
    
    func ok(data: String) {
        callback(.ok(true))
    }
    
    func cancel(data: String) {
        callback(.cancel(true))
    }
}
