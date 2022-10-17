//
//  Extension.swift
//  zy_lib_ui_ios
//
//  Created by Edwin on 05/20/2022.
//

import UIKit

/// A protocol used for instantiating a view controller from a storyboard.
protocol Storyboarded {
    static var defaultStoryboardName: String { get }
}

/// An extension with default implementation used for instantiating a view controller from a storyboard.
extension Storyboarded where Self: UIViewController {
    
    static var defaultStoryboardName: String {
        return String(describing: self)
    }
    
    static func instantiate(fromStoryboard name: String,
                            withBundle obj:AnyClass) -> Self {
        let bundle = Bundle(for: obj)
        let storyboard = UIStoryboard(name: name, bundle: bundle)

        guard let vc = storyboard.instantiateViewController(withIdentifier: defaultStoryboardName) as? Self else {
            fatalError("Could not instantiate initial storyboard with name: \(defaultStoryboardName)")
        }

        return vc
    }
}

extension UIViewController: Storyboarded { }

extension UIColor {
    public convenience init?(hex: String){
        let r, g, b, a: CGFloat
        
        if(hex.hasPrefix("#")){
            
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8{
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber){
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat((hexNumber & 0x000000ff)) / 255
                    //print("r=\(r) g=\(g) b=\(b) a=\(a)")
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        return nil
    }
}

extension UIViewController {
    func dismissMe(animated: Bool, completion: (()->())?) {
        var count = 0
        if let c = self.navigationController?.viewControllers.count {
            count = c
        }
        if count > 1 {
            print("Zy_ ==>>> popViewController")
            self.navigationController?.popViewController(animated: animated)
            if let handler = completion {
                handler()
            }
        } else {
            print("Zy_ ==>>> dismiss")
            dismiss(animated: animated, completion: completion)
        }
    }
}
