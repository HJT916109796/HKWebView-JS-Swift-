//
//  HKWebViewProtocol.swift
//  HKWebViewController
//
//  Created by 胡锦涛 on 2019/1/7.
//  Copyright © 2019 胡锦涛. All rights reserved.
//

import UIKit

@objc protocol HKWebViewProtocol:NSObjectProtocol{
    
    @objc optional func toast(_ message:String)
    
    @objc optional func save(_ image:String)
    
}
