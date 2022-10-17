//
//  ZyTModelOauth.swift
//  zy_fpay_validacionfacial_lib_ios
//
//  Created by Edwin on 05/03/2022.
//

import Foundation

// AUTH
struct ZyTAuthResponse : Decodable {
    let access_token:String?
    let refresh_token:String?
}

enum LoginSetting {
    
    private enum Keys {
        static let ruc = "ruc"
        static let usuario = "usuario"
        static let passwd = "passwd"
        static let token = "token"
    }
    
    private static let defaults = UserDefaults.standard
    
    static func reset(){
        ruc = ""
        usuario = ""
        passwd = ""
        token = ""
    }
    
    static var ruc: String {
        get{ return defaults.value(forKey: Keys.ruc) as! String }
        set{ defaults.set(newValue, forKey: Keys.ruc)
             defaults.synchronize()
        }
    }
    
    static var usuario: String {
        get{ return defaults.value(forKey: Keys.usuario) as! String }
        set{ defaults.set(newValue, forKey: Keys.usuario)
             defaults.synchronize()
        }
    }
    
    static var passwd: String {
        get{ return defaults.value(forKey: Keys.passwd) as! String }
        set{ defaults.set(newValue, forKey: Keys.passwd)
             defaults.synchronize()
        }
    }
    
    static var token: String {
        get{ return defaults.value(forKey: Keys.token) as! String }
        set{ defaults.set(newValue, forKey: Keys.token)
             defaults.synchronize()
        }
    }
    
}
