//
//  ViewController.swift
//  HKWebViewController
//
//  Created by 胡锦涛 on 2019/1/7.
//  Copyright © 2019 胡锦涛. All rights reserved.
//

import UIKit

class ViewController: HKWebViewController {
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        webView?.frame = view.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let path:String! = Bundle.main.path(forResource: "index", ofType: "html")
        webView?.load(URLRequest(url: URL(fileURLWithPath: path)))
    }
    
    
    //实现子类自己的逻辑
    override func save(_ image: String) {
        print("js传递给ios的参数:" + image)
        self.webView?.evaluateJavaScript("\(callbackName ?? "")('这是ios回调给js的返回值');", completionHandler: nil)
    }
    
}

