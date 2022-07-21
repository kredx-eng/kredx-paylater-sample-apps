//
//  ViewController.swift
//  BnplWebview-IOS
//
//  Created by shivam khandelwal on 07/07/22.
//

import UIKit

var paymentUrl = "https://www.sample-videos.com/download-sample-jpg-image.php";
//"https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf";
let onboardingUrl: String = "https://redirect-staging.mandii.com/okie";

class MainViewController: UIViewController {
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var register: UIBarButtonItem!
    var token, empno, nounce, pwd, sessionid: String!
    let semaphore = DispatchSemaphore(value: 0)
    var animated = false;
    
    @IBAction func onPaymentClick(_ sender: Any) {
        onPayment()
    }
    
    @IBAction func onClickOnboarding(_ sender: Any) {
        GlobalState.currentUrl = onboardingUrl
        let webViewController = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController")
        print(GlobalState.currentUrl, "print")
        DispatchQueue.main.async {
            self.present(webViewController!, animated: true, completion: nil)
        }
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.id.delegate = self
//        self.register.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func showAlert(title: String, msg: String) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .cancel)
        alertController.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func getUrl(status: String) {
    
    }
    
    func createOrder() {
        let phoneNo = Defaults.getMobileNumber()
        let pan = Defaults.getPanNumber()
        let orderId = Int.random(in: 100000..<999999)
        let marchentId = "ABCD\(orderId)"
        let params = {
            
        };
        
//            let data = NetworkManager.fetchData(params, getUrl);
        
    }
    
    func onPayment() {
     let token =  Defaults.getToken()
    
        print("onPayment token:", token)
        if(!token.isEmpty) {
            self.showAlert(title: "Error", msg: "Please Register or login first")
        } else {
//            var params = {};
//            let data = NetworkManager.fetchData(params, getUrl);
            GlobalState.currentUrl = paymentUrl
            let webViewController = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController")
            DispatchQueue.main.async {
                self.present(webViewController!, animated: true, completion: nil)
            }
    }
    }
}

