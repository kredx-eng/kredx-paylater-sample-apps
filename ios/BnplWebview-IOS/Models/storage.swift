import SwiftUI
import UIKit

struct Defaults {
    
    static let (tokenKey, mobileKey, panKey) = ("access_token", "mobile", "pan_number")
    static let userSessionKey = "com.bnpl.websample"
    private static let userDefault = UserDefaults.standard
    
    /**
       - Description - It's using for the passing and fetching
                    user values from the UserDefaults.
     */
    struct UserDetails {
        let token: String
        let mobile: String
        
        init(_ json: [String: String]) {
            self.token = json[tokenKey] ?? "default token"
            self.mobile = json[mobileKey] ?? "default mobile"
        }
    }
    
    /**
     - Description - Saving user details
     - Inputs - name `String` & address `String`
     */
    static func setToken (_ token: Any) {
        userDefault.set(token, forKey: tokenKey);
        
    }
    static func setMobile(_ mobile: Any) {
        userDefault.set(mobile, forKey: mobileKey);
    }
    static func setPan(_ pan: Any) {
        userDefault.set(pan, forKey: panKey)
    }
    
    static func getToken() -> String {
        return userDefault.string(forKey: tokenKey) ?? ""
    }
    
    static func getMobileNumber() -> String {
        return userDefault.string(forKey: mobileKey) ?? ""
    }
    
    static func getPanNumber() -> String {
        return userDefault.string(forKey: panKey) ?? ""
    }

    static func save(_ token: Any, mobile: Any){
        userDefault.set([tokenKey: token, mobileKey: mobile],
                        forKey: userSessionKey)
        userDefault.synchronize()
    }
    
    
    /**
     - Description - Fetching Values via Model `UserDetails` you can use it based on your uses.
     - Output - `UserDetails` model
     */
//    static func getTokenAndNumber()-> UserDetails {
//        let token = userDefault.string(forKey: tokenKey)
//        let mobile = userDefault.string(forKey: mobileKey)
//        let params = [tokenKey: token ?? "", mobileKey: mobile ?? ""]
//        return UserDetails(params)
//
////        return UserDetails((userDefault.value(forKey: userSessionKey) as? [String: String]) ?? [:])
//    }
    
    /**
        - Description - Clearing user details for the user key `com.save.usersession`
     */
    static func clearUserData(){
        userDefault.removeObject(forKey: userSessionKey)
    }
}

/**
 https:betterprogramming.pub/userdefaults-in-swift-4-d1a278a0ec79
 */
