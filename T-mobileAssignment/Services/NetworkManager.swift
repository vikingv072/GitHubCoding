//
//  NetworkManager.swift
//  T-mobileAssignment
//
//  Created by Kevin Verghese on 6/4/20.
//  Copyright © 2020 Kevin Verghese. All rights reserved.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    let session = URLSession.shared
    
    func downloadData<T:Decodable>(from url: URL, type: T.Type, _ completion: @escaping (T) -> Void) {
        session.dataTask(with: url) { data,_,_ in
            guard let usefulData = data else {
                print("some issue")
                return
            }
            do {
                let decoded = try JSONDecoder().decode(T.self, from: usefulData)
                completion(decoded)
            }
            catch {
                print(error)
                print(try? JSONSerialization.jsonObject(with: usefulData, options: .mutableLeaves) )
            }
        }.resume()
    }
    
    func downloadAvatar(from url: URL, _ completion: @escaping (Data?) -> Void) {
        session.dataTask(with: url) { (data,_,_) in
            completion(data)
        }.resume()
    }
    
    // Download Repos/User details
    
    
}
