
# BNPL Webview IOS Application

This application is having a bridging for BNPL onboarding flow and create payment to payment flow.

## Installation

Clone this repository and import into **xCode**

```bash
git clone git@github.com:kredx-eng/kredx-paylater-sample-apps.git
```

## Getting started

This App contain 2 screens splash screen and main screen with dialogbox `BNPL webview`

```text
 |
 |  BnplWebview-IOS/
 |       |                    
 |       |__ MainView.swift                     
 |       |__ WebviewController.swift               
 |       |__ Main.storyboard
 |       |
 |       |_______  Networking
 |       |            |__ NetworkManager.swift
 |       |            |__ CreateOrder.swift
 |       |
 |       |
 |       |_______  Modal                   
 |       |           |__ storage.swift
 |       |           |__ apiData.swift
 |       |           |__ constant.swift
 |       |           |__ PostData.swift
 |       |           |__ helper.swift
 |       |
 |       |
 |       |__ Info.plist

```

- [MainView](https://github.com/kredx-eng/BNPL-Webview-app/blob/main/ios/BnplWebview-IOS/MainView.swift) is connected to main.storyboard which is the main landing page which is having two buttons which opens up conditionaly.
  - **First button** `Register Flow` having a intent which opens webview which is having in `WebviewController`. first this will check all user permission. If all per granted then only it navigate to bnpl page.
  - **Second button** `Payment Flow` this check where user has onboardeded successfully or not. If onboardeded this store the token of user in local storage and then this button will hit the Order Create Api and pass url intent into webview `MainActivity`.
- [WebviewController](https://github.com/kredx-eng/BNPL-Webview-app/blob/main/ios/MainActivity.kt) this actvity is having a dialog box which contains a webview and this webview is having a certian modifications according to the requirement.


## Libraries

```sh
'WKDownloadHelper'
```
###### This Async https we are using for api calling
```sh
'SwiftyJSON'
```

## Tutorial to use this code into your project

**Step1.** 		Create a event to open onboarding flow and pass below url into our custom bridge intent webview
```sh
https://redirect-staging.mandii.com/    + `customer tag`
```

``
before calling this please take all user permission or you can use our checkPermission function from [MainView]() after this create a below function and call whenever you need to open your webview
``

```sh
    @IBAction func onClickOnboarding(_ sender: Any) {
        GlobalState.currentUrl = onboardingUrl
        let webViewController = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController")
        DispatchQueue.main.async {
            self.present(webViewController!, animated: true, completion: nil)
        }
    }
```

``
[Note: ]() We are naming this webview with Webview Controller you can name something else
``


**Step2.**	Create BNPL Modal and Network folder and inside project for data storage, constants, variables and Api calling
that create kotlin class for webview and use below code. (class name example **WebviewController.swift**)

````html
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
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.isNavigationBarHidden = true
        
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.scrollView.delegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false


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
//           webView!!.destroy()
//          finish()
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
            self.navigationController?.navigationBar.prefersLargeTitles = false
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


````
**Step3: ** Create storyboard for first and second screen UI layout. (class name example **BnplWebview.xml**)

```html

```

##Payment Flow If required

##### After onboarding you can intregate a payment flow code which required a auth token which we are storing thi preference storage which we can store in some other local db or global state. after this we need to intregate a order creating api which we can pass our order amount user personal details and user shipping and billing addresses. this will generate a payment redirected link with calls urls. this callback urls will navigate you once payment will get sucess and failure.

## API Reference

#### Create order for redirecting path

```http
  POST /order
```

| Parameter | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `order_amount` | `number` | **Required**. API key |
| `merchant_order_number` | `string` | **Required**. API key |
| `discounts` | `[]` | **Required**. API key |
| `tax_amount` | `object` | **Required**. API key |
| `order_description` | `string` | **Required**.  API key |
| `customer_details` | {"first_name": "string", "last_name": "string", "email": "string","phone": "string","company_pan": "string"} | **Required**. API key |
| `billing_address` | `object` | **Required**. API key |
| `shipping_address` | `object` | **Required**. API key |
| `order_lines` | `[{}]` | **Required**. API key |
| `urls` | `object` | **Required**. API key |


###### In this project we are using swiftyJson and WKDownloadHelper you can use any other library according to your project requirement


### This api will return you the payment redirected url which we need to pass in above [webview class](https://github.com/kredx-eng/kredx-paylater-sample-apps/blob/main/ios/BnplWebview-IOS/WebViewController.swift) func

[34]: https://github.com/kredx-eng/kredx-paylater-sample-apps/blob/main/ios/BnplWebview-IOS/MainView.swift "SplashActvity"


## Demo

Video and screenshot
