//
//  HKWebViewController+JSObject.swift
//  HKWebViewController
//
//  Created by 胡锦涛 on 2019/1/7.
//  Copyright © 2019 胡锦涛. All rights reserved.
//

import UIKit

import WebKit

let HKKeyWindow = UIApplication.shared.keyWindow

extension HKWebViewController: HKWebViewProtocol {
    
    //公共方法实现
    
    func toast(_ message:String) {
        HKKeyWindow?.showToast(message)
    }
    
    
    //其他方法子类按需重写即可
    
    func save(_ image: String) {
        
    }
    
}
