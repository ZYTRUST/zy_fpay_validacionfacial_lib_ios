//
//  ZyModelUI.swift
//  zy_lib_ui_ios
//
//  Created by Edwin on 05/20/2022.
//

import Foundation

public struct ZyUILoadingRequest{
    public init(){}
    
    public var message: String?
    
    public var animated: Bool=true
}

public enum ZyUILoadingResult <T,C> {
    case ok(T)
    case cancel(C)
}
