//
//  HKWebViewController.swift
//  HKWebViewController
//
//  Created by 胡锦涛 on 2019/1/7.
//  Copyright © 2019 胡锦涛. All rights reserved.
//

import UIKit
import WebKit

class HKWebViewController: UIViewController {
    
    var webView : HKWebView?
    var urlString : String?
    var progressView = UIProgressView()
    var callbackName : String?
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        webView?.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webView?.evaluateJavaScript("HKWebListener('viewAppear')", completionHandler: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webView?.evaluateJavaScript("HKWebListener('viewDisappear')", completionHandler: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = HKWebView(frame: CGRect.zero, delegate: self)
        webView?.backgroundColor = .white
        view.addSubview(webView!)
        automaticallyAdjustsScrollViewInsets = false
        if #available(iOS 11.0, *) {
            webView?.scrollView.contentInsetAdjustmentBehavior = .never
        }
    }
    
    public func load(withUrl url:String , cachePolicy:URLRequest.CachePolicy = .reloadIgnoringLocalCacheData) {
        
        self.urlString = url
        let request = URLRequest(url: URL(string: url)!, cachePolicy: cachePolicy, timeoutInterval: 20)
        webView?.load(request)
        
        
    }
    
    
    deinit {
        
        if webView != nil {
            webView!.removeObserver(self, forKeyPath: "estimatedProgress", context: nil)
            webView!.removeObserver(self, forKeyPath: "loading", context: nil)
            webView!.configuration.userContentController.removeScriptMessageHandler(forName: JSObjectName)
            webView!.uiDelegate = nil
            webView!.navigationDelegate = nil
            webView = nil
        }
        progressView.removeFromSuperview()
    }
    
    
}
