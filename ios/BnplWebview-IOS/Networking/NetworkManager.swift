//
//  NetworkManager.swift
//  HackerNews-SwiftUIApp
//
//  Created by Santiago Rodriguez Affonso on 21/04/2022.
//

import Foundation

class NetworkManager: ObservableObject {
    
    @Published var urls = [Post]()
    
    func fetchData(params : [String: Any], completion: @escaping(Results) -> () ) {
        let token = Defaults.getToken();
        let url = URL(string: "https://staging.mandii.com/bnpl/v1/order")
//        let orderUrl = "https://staging.mandii.com/bnpl/v1/order"
//        let session = URLSession(configuration: .default)
        var session = URLRequest(url: url!)
        session.httpMethod = "POST"
        session.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        session.addValue("application/json", forHTTPHeaderField: "Content-Type")
        session.addValue("application/json", forHTTPHeaderField: "Accept")
        session.httpBody = try! JSONSerialization.data(withJSONObject: params, options: []);

        let task = URLSession.shared.dataTask(with: session) { data, response, error in
            if error != nil {
                print(String(describing: error))
            }
            if let safeData = data {
                do {
                    let decoder = JSONDecoder()
                    let results = try decoder.decode(Results.self, from: safeData)
                    DispatchQueue.main.async {
                        completion(results);
                        print(results, "results");
//                        self.urls = results
                    }
                }
                catch {
                    print(String(describing: error))
                }
            }
        }
        task.resume()
    }
}
