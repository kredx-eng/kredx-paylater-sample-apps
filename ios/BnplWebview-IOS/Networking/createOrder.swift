////
////  createOrder.swift
////  BnplWebview-IOS
////
////  Created by shivam khandelwal on 13/07/22.
////
//
//import Foundation
//
//let json = """
//{
//  "order_amount": "100",
//  "merchant_order_number": 4545454,
//  "order_description": "abc34344545",
//  "payment_confirmation_url": "https://example.com/",
//  "payment_notification_api": "https://example.com/",
//  "customer_details": {
//    "first_name": "shivam",
//    "last_name": "khandelwal",
//    "email": "user@example.com",
//    "phone": "9045283038",
//    "company_pan": "ABCDED"
//  },
//  "billing_address": {
//    "city": "bangalore",
//    "state": "karnataka",
//    "pincode": "506103",
//    "address_line_1": "kredx",
//    "address_line_2": "bellendur",
//    "name": "test user",
//    "phone": "9045283038"
//  },
//  "shipping_address": {
//    "city": "bangalore",
//    "state": "karnataka",
//    "pincode": "506103",
//    "address_line_1": "kredx",
//    "address_line_2": "bellendur",
//    "name": "test user",
//    "phone": "9045283038"
//  },
//  "order_lines": [
//    {
//      "name": "test user",
//      "sku": "abcdef",
//      "quantity": "100",
//      "price": {
//        "amount": "100",
//        "currency": "INR"
//      }
//    }
//  ],
//  "discounts": [],
//  "tax_amount": {
//    "amount": "0",
//    "currency": "INR"
//  },
//  "notes": "testing iOS App"
//}
//"""
//
//
//
////struct ApiResponse {
////    let orderAmount, merchantOrderNumber, orderDescription: String
////    let paymentConfirmationURL, paymentNotificationAPI: String
////    let customerDetails: CustomerDetails
////    let billingAddress, shippingAddress: IngAddress
////    let orderLines: [OrderLine]
////    let discounts: [Any?]
////    let taxAmount: TaxAmount
////    let notes: String
////}
////
////// MARK: - IngAddress
////struct IngAddress {
////    let city, state, pincode, addressLine1: String
////    let addressLine2, name, phone: String
////}
////
////// MARK: - CustomerDetails
////struct CustomerDetails {
////    let firstName, lastName, email, phone: String
////    let companyPan: String
////}
////
////// MARK: - OrderLine
////struct OrderLine {
////    let name, sku, quantity: String
////    let price: TaxAmount
////}
////
////// MARK: - TaxAmount
////struct TaxAmount {
////    let amount, currency: String
////}
//
//
//func createOrder() {
//    let phoneNo = Defaults.getMobileNumber()
//    let pan = Defaults.getPanNumber()
//    let orderId = Int.random(in: 100000..<999999)
//    let marchentId = "ABCD\(orderId)"
//    var json: [String: Any] = ["title": "Ankit",
//                              "dict": ["1":"Ankit", "2":"Krunal"]]
////    var p: [String: AnyObject] = ["order_amount" : "1000"];
////    if let n = { p["name"] = "\(orderId)" as AnyObject }
//
//
//    do {
//        let decoder = JSONDecoder()
//        let jsonData = Data(json.utf8)
//        let people = try decoder.decode([Person].self, from: jsonData)
//        print(people)
//
////        if let dict = try JSONSerialization.jsonObject(with: json, options: .allowFragments) as? [String: Any] {
////            let model = RootClass(dict)
//        }
//    } catch {
//        // Handle error
//    }
//
////    let params = {
////    }
////    params["order_id"] = orderId
////    params["order_amount"] = 1000
////    params["payment_confirmation_url"] = "https://facebook.com"
////    params["merchant_order_number"] = marchentId
////    params["order_description"] = "testing webview app"
////    params["payment_notification_api"] = "https://facebook.com"
//}
