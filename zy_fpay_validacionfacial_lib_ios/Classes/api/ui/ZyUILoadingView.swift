//
//  ZyUIView.swift
//  zy_lib_ui_ios
//
//  Created by Edwin on 05/20/2022.
//

import Foundation

protocol ZyUILoadingDelegateProtocol{
    
    func ok(data:String)
    func cancel(data:String)
}

public class ZyUILoadingView: UIViewController{
    
    var request = ZyUILoadingRequest()
    var delegate : ZyUILoadingDelegateProtocol? = nil
    
    @IBOutlet weak var textUi: UILabel!
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
}
