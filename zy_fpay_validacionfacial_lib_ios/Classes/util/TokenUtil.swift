//
//  TokenUtil.swift
//  zy_fpay_validacionfacial_lib_ios
//
//  Created by Edwin on 05/02/2022.
//

import Foundation
import JWTDecode

class TokenUtil {
    
    class func keydecode(oauthToken:String) -> String {
        let token = oauthToken
        var usuCoInterno:String = ""
        var usuEmpsId:String = ""
        do {
            let jwt = try decode(jwt: token)
            usuCoInterno = jwt.claim(name: "usuCoInterno").string ?? ""
            usuEmpsId = String (jwt.claim(name: "usuEmpsId").integer!)
            
            //print("======> JWT DECODE ")
            //print( "usuCoInterno:"  + "\(usuCoInterno)" + "\n" +
            //       "usuEmpsId: " + "\(usuEmpsId)" )
            
        } catch {
            print("Failed to decode JWT: \(error)")
        }
        
        let size = usuCoInterno.count
        let bearerToken = token.count
        var value = String(size) + String(bearerToken) + usuEmpsId
        //print("value: \(value)")
        
        let cutSize = sumDigit(value: value);
        
        
        var beginIndex:Int = size;
        
        var endIndex = cutSize;
        
        let diff = cutSize - size;
        if (diff < 0 || diff < 32) {
            beginIndex = 8;
            endIndex = 40;
        }
        
        if (diff > 64) {
            endIndex = 64;
        }
        
        value = token;
        //print("beginIndex: \(beginIndex) \n endIndex: \(endIndex)")
        
        let valueFinal = value.substring(with: beginIndex..<endIndex)
        print("valueFinal: \(valueFinal) ")
        
        return String(valueFinal)
        
    }
    
    private class func sumDigit(value:String) -> Int {
        var sum = 0
        
        let chars = value
        
        for char in chars {
            sum = sum + (char.hexDigitValue ?? 0)
        }
        
        return sum
        
    }
}
