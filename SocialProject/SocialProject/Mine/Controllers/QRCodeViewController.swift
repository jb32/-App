//
//  QRCodeViewController.swift
//  SocialProject
//
//  Created by Mac on 2018/8/21.
//  Copyright © 2018年 ZYY. All rights reserved.
//

import UIKit
import WebKit

class QRCodeViewController: ZYYBaseViewController {
    
    private var webView: WKWebView!
    private let pool = WKProcessPool()
    private let progressView = UIProgressView(frame: CGRect.zero)
    
    var urlString: String = "http://47.92.101.248:8080/shejiaoappserver/goQRCode"
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.removeObserver(self, forKeyPath: "title")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userCC = WKUserContentController()
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.processPool = pool
        configuration.userContentController = userCC
        
        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = true
        configuration.preferences = preferences
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: DEVICE_WIDTH, height: DEVICE_HEIGHT - 64), configuration: configuration)
        view.addSubview(webView)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        webView.uiDelegate = self
        webView.navigationDelegate = self

        progressView.transform = CGAffineTransform(scaleX: 1, y: 1.5)
        progressView.tintColor = UIColor.red
        progressView.trackTintColor = UIColor.blue
        view.addSubview(progressView)
        progressView.frame = CGRect(x: 0, y: 0, width: DEVICE_WIDTH, height: 2)
        
        let request = URLRequest(url: URL(string: urlString)!, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 30)
        webView.load(request)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension QRCodeViewController: WKUIDelegate, WKNavigationDelegate {
    //MARK: WKNavigationDelegate
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        let rsp = navigationResponse.response as! HTTPURLResponse
        HTTPCookie.cookies(withResponseHeaderFields: rsp.allHeaderFields as! [String : String], for: rsp.url!).forEach { (cookie) in
            HTTPCookieStorage.shared.setCookie(cookie)
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    
    //MARK: WKUIDelegate
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        return webView
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
       
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
    }
}

extension QRCodeViewController {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UIView, obj == webView, let keyPath = keyPath {
            if keyPath == "estimatedProgress" {
                progressView.alpha = 1
                progressView.setProgress(Float(webView.estimatedProgress), animated: true)
                
                if webView.estimatedProgress == 1 {
                    UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut, animations: {
                        self.progressView.transform = CGAffineTransform(scaleX: 1, y: 1.4)
                    }, completion: { (_) in
                        self.progressView.isHidden = true
                    })
                }
            }
            
            if keyPath == "title" {
                title = webView.title
            }
        }
    }
}
