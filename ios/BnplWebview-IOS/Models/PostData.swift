//
//  PostData.swift
//  HackerNews-SwiftUIApp
//
//  Created by Santiago Rodriguez Affonso on 21/04/2022.
//

import Foundation



struct Results: Codable {
    let hits: [CallbackUrl]
}

struct Post: Codable, Identifiable {
    var id: String {
        return objectID
    }
    let title: String
    let url: String?
    let points: Int
    let objectID: String
}

struct CallbackUrl: Codable, Identifiable {
    var id: String {
        return objectID
    }
    let title: String
    let url: String?
    let points: Int
    let objectID: String
    
}


struct GlobalState {
    static var currentUrl: String = "";
    static var successPayment: String  = "";
    static var failurePayment: String = "";
    static var token: String = "";
}



