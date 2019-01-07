//
//  HKWebViewController+WebDelegate.swift
//  HKWebViewController
//
//  Created by 胡锦涛 on 2019/1/7.
//  Copyright © 2019 胡锦涛. All rights reserved.
//

import WebKit

func HKLog<T>(_ message : T,methodName: String = #function, lineNumber: Int = #line){
    #if DEBUG
    print("\(methodName)[\(lineNumber)]:\(message)")
    #endif
}

func JSON(parseJSON jsonString:String) -> [String : Any] {
    let jsonData:Data = jsonString.data(using: .utf8)!
    let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
    if let result = dict as? [String : Any] {
        return result
    }
    return [:]
}

extension HKWebViewController:WKNavigationDelegate{
    
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
    }
    
    /*
     * 决定导航的动作，通常用于处理跨域的链接能否导航。WebKit对跨域进行了安全检查限制，不允许跨域，因此我们要对不能跨域的链接
     * 单独处理。但是，对于Safari是允许跨域的，不用这么处理。
     */
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        progressView.alpha = 1
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
    }
    
}


extension HKWebViewController:WKUIDelegate{
    
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame?.isMainFrame == false {
            webView.load(navigationAction.request)
        }
        return nil
    }
    
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "确定", style: .default) { (action) in
            completionHandler()
        }
        alert.addAction(action)
        
        if isViewLoaded && (view.window != nil) {
            present(alert, animated: true, completion: nil)
        }else{
            completionHandler()
        }
        
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "确定", style: .default) { (action) in
            completionHandler(true)
        }
        let action2 = UIAlertAction(title: "取消", style: .cancel) { (action) in
            completionHandler(false)
        }
        alert.addAction(action1)
        alert.addAction(action2)
        present(alert, animated: true, completion: nil)
    }
    
}


extension HKWebViewController:WKScriptMessageHandler{
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        HKLog(message)
        
        if message.name == JSObjectName {
            if let body = checkString(message.body){
                let json = JSON(parseJSON: body)
                if var methodName = json["method"] as? String{
                    var params : String? = nil
                    if let p = json["params"] as? String{
                        params = p
                        methodName += ":"
                    }
                    let selector =  Selector(methodName)
                    if self.responds(to: selector){
                        if let callback = json["callback"] as? String{
                            self.callbackName = callback
                        }
                        //当前线程是否要被阻塞
                        self.performSelector(onMainThread: selector, with: params, waitUntilDone: true)
                    }else{
                        HKLog("webview not find method" + methodName)
                    }
                }
            }
        }
    }
    
    func checkString(_ string:Any?) -> String? {
        if let s = string as? String, !s.isEmpty{
            return s
        }
        return nil
    }
    
}


extension HKWebViewController{
    
    /*
     * webview kvo
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let ob = object,ob as? HKWebView == webView{
            if let key = keyPath{
                if key == "title"{
                    navigationItem.title =  change![.newKey] as? String
                }else if key == "estimatedProgress"{
                    progressView.setProgress(Float(truncating: change![.newKey] as! NSNumber) , animated: true)
                }
                
                if !webView!.isLoading {
                    UIView.animate(withDuration: 0.5, animations: {
                        self.progressView.alpha = 0
                        self.progressView.setProgress(1, animated: true)
                    }){ (c) in
                        self.progressView.setProgress(0, animated: false)
                    }
                }else{
                    self.progressView.alpha = 1
                }
            }
        }
    }
    
}
