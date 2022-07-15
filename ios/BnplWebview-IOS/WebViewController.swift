//
//  WebViewController.swift
//  mobilesis
//
//  Created by 서울신문사 on 2020/07/30.
//  Copyright © 2020 서울신문사. All rights reserved.
//

import UIKit
import WebKit
import SwiftyJSON
import WKDownloadHelper
import struct WKDownloadHelper.MimeType


let APP_IMAGE_DIR = "images"
let WEBVIEW_LOCAL_CURRENT_STAGE = "javascript:window.sessionStorage.getItem('current_stage');"
let WEBJS_SESSION_STORAGE = "(function() { return JSON.stringify(sessionStorage); })();"
let LOCAL_STORAGE_JS = "(function() { return JSON.stringify(localStorage); })();"
let WEBVIEW_AUTH_JS = "(function() { return localStorage.getItem('auth'); })();"
let WEBJS_PAN_NUMBER = "(function() { return localStorage.getItem('company_pan'); })();"


class WebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate, UIScrollViewDelegate {
//    let WKDownloadMimeType = WKDownloadHelper.MimeType
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var webView: WKWebView!
    @IBOutlet var backBtn: UIBarButtonItem!
    var downloadHelper: WKDownloadHelper!
    var lastPage: String = "";
    var pageChanged: Bool = false;
    var payment_status: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        let contentController = WKUserContentController()
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = WKWebsiteDataStore.default()
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        configuration.preferences.isSiteSpecificQuirksModeEnabled = true
        configuration.defaultWebpagePreferences = preferences
        configuration.userContentController = contentController
        
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.scrollView.delegate = self
        webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 15_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.4 Mobile/15E148 Safari/604.1"
        webView.isUserInteractionEnabled = true
        let cookieValue = String(format:"document.cookie ='platform=%@;path=/;domain=medlinker.com;expires=Sat, 02 May 2019 23:38:25 GMT；';document.cookie = 'sess=%@;path=/;domain=medlinker.com;expires=Sat, 02 May 2018 23:38:25 GMT；';")
        let cookieScript = WKUserScript(source: cookieValue, injectionTime: .atDocumentStart , forMainFrameOnly: true)
        contentController.addUserScript(cookieScript)
        configuration.userContentController = contentController
        webView.allowsBackForwardNavigationGestures = true
        webView.translatesAutoresizingMaskIntoConstraints = false
        configuration.websiteDataStore = WKWebsiteDataStore.default()
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let url = URL(string: GlobalState.currentUrl)
        let request = URLRequest(url: url!)
        webView.load(request)
    }
    
    @objc func onResume() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let expiredTimeStr = UserDefaults.standard.string(forKey: "expiredTime")
        let expiredTime:Date = dateFormatter.date(from: expiredTimeStr!)!
        
        if Date() > expiredTime {
            showLoginAlert()
        }
        print("--webView onResume")
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()

        let url = webView.url!
        let urlStr = url.absoluteString
        print("didStartProvisionalNavigation", urlStr)
//        backBtn.isEnabled = (urlStr.range(of: "Home.aspx") != nil) ? false : true
        
        print("--webView didStartProvisionalNavigation (" + urlStr + ")")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        activityIndicator.stopAnimating()
        print("--webView didFinish")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let key = change?[NSKeyValueChangeKey.newKey] {
            let currentUrl = "\(key)";
            if(lastPage != currentUrl) {
                lastPage = currentUrl;
                print(lastPage, currentUrl)
                checkPageChanges(path : currentUrl)
//                if (currentUrl == "https://redirect-staging.mandii.com/dashboard") {
//                                        updateSessionStatus()
//                                        Handler().postDelayed({
//                                            updateWebToLocal()
//                                        }, 10000)
//                                    }
            }
            print("observeValue \(key)") // url value
        }
    }
    

    func checkPageChanges(path: String) {
        if(!path.isEmpty) {
        let url = URL(string: path)!
        let components = URLComponents(
            url: url,
            resolvingAgainstBaseURL: false
        )!
//        print("host", components.host, url.host)
        let endParam = url.lastPathComponent
//        let endParamArray = url.path.split(separator: "/");
        if (endParam == "success" || endParam == "failure") {
               payment_status = endParam
       }
        if(components.host == "m.facebook.com") {
            //close modal
        }
        if (path == "https://redirect-staging.mandii.com/") {
            // close modal
//                                webView!!.destroy()
//                                finish()
        }
        if (endParam == "logout") {
                                /// clear prefernce storage
        }
        getAuth(webView);
        }
    }
    
    func getAuth(_ webView: WKWebView) {
        webView.evaluateJavaScript(WEBVIEW_AUTH_JS, completionHandler: { result, error in
            if let error = error {
                print ("evaluateJavaScript WEBVIEW_AUTH_JS \(error)")
};
           
           if let datHtml = result as? String {
               print(datHtml, "datHtml")
               let json1 = JSON.init(parseJSON: datHtml)
               let token = json1["access_token"].rawValue
               let mobile = json1["phone_number"].rawValue
               Defaults.setToken(token)
               Defaults.setMobile(mobile)
               }
           })
        
        webView.evaluateJavaScript(WEBJS_PAN_NUMBER, completionHandler: { result, error in
            if let error = error {};
           if let panNumber = result as? String {
               Defaults.setMobile(panNumber);
               }
           })
    }
    func getSessionId(_ webView: WKWebView) {
        webView.evaluateJavaScript(WEBJS_SESSION_STORAGE, completionHandler: { result, error in
            if let error = error {
                print ("evaluateJavaScript \(error)")
};
        
           if let datHtml = result as? String {
               let json1 = JSON.init(parseJSON: datHtml)
               print("WEBJS_SESSION_STORAGE", datHtml)
//               let token = json1["access_token"].rawValue
//               let mobile = json1["phone_number"].rawValue
//               Defaults.setToken(token)
               }
           })
    }
    
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if (navigationAction.targetFrame == nil) {
                  let popup = WKWebView(frame: webView.bounds, configuration:configuration)
                  popup.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                  popup.uiDelegate = self
                  popup.navigationDelegate = self
                  popup.scrollView.contentInset = .zero
                view.addSubview(webView)
//                  self.addSubview(popup)
                  return popup
             }
             return nil
        
        
//    if !(navigationAction.targetFrame?.isMainFrame ?? false) {
//    webView.load(navigationAction.request)
//    }
//    return nil
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        webView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
        print("webView")
        getAuth(webView);
//        getSessionId(webView);
//        webView.evaluateJavaScript(WEBVIEW_AUTH_JS, completionHandler: { result, error in
//            if let error = error {
//                print ("evaluateJavaScript \(error)")
//};
//
//           if let datHtml = result as? String {
//               let json1 = JSON.init(parseJSON: datHtml)
//               let token = json1["access_token"].rawValue
//               let mobile = json1["phone_number"].rawValue
//               Defaults.setToken(token)
//               print(token, mobile, "tempValues")
//               }
//           })
//
        let url = navigationAction.request.url!
        let urlStr = url.description.lowercased()
        if navigationAction.targetFrame == nil {
            if let url = navigationAction.request.url {
                let app = UIApplication.shared
                if app.canOpenURL(url) {
                    app.open(url, options: [:], completionHandler: nil)
                }
            }
        }
        decisionHandler(.allow)
        
        
        view.addSubview(webView)
//        self.view = self.webView
        print("navigationResponse", webView.url!)
        let mimeTypes = [
            MimeType(type: "ms-excel", fileExtension: "xls"),
            MimeType(type: "pdf", fileExtension: "pdf"),
            MimeType(type: "xml", fileExtension: "xml"),
            MimeType(type: "png", fileExtension: "png"),
            MimeType(type: "zip", fileExtension: "zip"),
            MimeType(type: "jpeg", fileExtension: "jpeg"),
            MimeType(type: "image/jpeg", fileExtension: "jpg"),
            MimeType(type: "image/jpeg", fileExtension: "png"),
////            MimeType(type: "", fileExtension: ""),
//            MimeType(type: "video", fileExtension: "*"),
//            MimeType(type: "*", fileExtension: "*"),
//            MimeType(type: "*", fileExtension: "*")
        ]
        
        downloadHelper = WKDownloadHelper(webView: webView,
                                          supportedMimeTypes: mimeTypes,
                                          delegate: self)
        print("--webView decidePolicyFor (" + urlStr + ")")
    }
    
    // 뒤로가기 버튼 클릭
    @IBAction func onBackBtnClicked(_ sender: Any) {
        let url = webView.url!
        let urlStr = url.absoluteString
        
        if urlStr.range(of: "BoardDetail.aspx") != nil {
            let url = URL(string: urlStr.replacingOccurrences(of: "BoardDetail", with: "BoardList"))
            let request = URLRequest(url: url!)
            
            webView.load(request)
        }
        else if urlStr.range(of: "ApprList.aspx") != nil || urlStr.range(of: "ApprGongmun.aspx") != nil ||
            urlStr.range(of: "BoardList.aspx") != nil || urlStr.range(of: "Family.aspx") != nil ||
            urlStr.range(of: "MyunList.aspx") != nil || urlStr.range(of: "SMS.aspx") != nil ||
            urlStr.range(of: "Work.aspx") != nil || urlStr.range(of: "Settings.aspx") != nil {
            let url = URL(string: GlobalState.currentUrl)
            let request = URLRequest(url: url!)
            
            webView.load(request)
        }
        else {
            webView.goBack()
        }
    }
    
    
    @IBAction func onHomeBtnClicked(_ sender: Any) {
        let url = URL(string: GlobalState.currentUrl)
        let request = URLRequest(url: url!)
        
        webView.load(request)
    }
    
    @IBAction func onLogoutBtnClicked(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
    
    func showLoginAlert() {
        let alertController = UIAlertController(title: "로그인", message: "세션이 만료되었습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .cancel) { _ in
            self.presentingViewController?.dismiss(animated: true, completion: nil)
            print("--Session Expired")
        }
        
        alertController.addAction(okAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage msg: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: "Okay", message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "cancel", style: .cancel) { _ in
            completionHandler()
        }
        
        alertController.addAction(okAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
        print("first webview")
    }
    
    
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage msg: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            completionHandler(true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completionHandler(false)
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
        print("second webview")
    }
    
  public func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
          print("didReceiveServerRedirectForProvisionalNavigation: \(navigation.debugDescription)")
      }
    
    @available(iOS 14.5, *)
    public func webView(_ webView: WKWebView, navigationResponse: WKNavigationResponse, didBecome download: WKDownload) {
    }
}

extension WebViewController: WKDownloadHelperDelegate {
  func didFailDownloadingFile(error: Error) {
      print("error while downloading file \(error)")
  }

    public func download(_ download: WKDownload, decideDestinationUsing response: URLResponse, suggestedFilename: String, completionHandler: @escaping (URL?) -> Void) {
        let temporaryDir = NSTemporaryDirectory()
        let fileName = temporaryDir + "/" + suggestedFilename
        let url = URL(fileURLWithPath: fileName)
//        fileDestinationURL = url
        completionHandler(url)
    }

    public func download(_ download: WKDownload, didFailWithError error: Error, resumeData: Data?) {
//        delegate?.didFailDownloadingFile(error: error)
    }
    
  func didDownloadFile(atUrl: URL) {
      print("did download file!")
      DispatchQueue.main.async {
          let activityVC = UIActivityViewController(activityItems: [atUrl], applicationActivities: nil)
          activityVC.popoverPresentationController?.sourceView = self.view
          activityVC.popoverPresentationController?.sourceRect = self.view.frame
          activityVC.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
          self.present(activityVC, animated: true, completion: nil)
      }
  }

}
