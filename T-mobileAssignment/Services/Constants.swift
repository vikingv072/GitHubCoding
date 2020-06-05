//
//  Constants.swift
//  T-mobileAssignment
//
//  Created by Kevin Verghese on 6/5/20.
//  Copyright © 2020 Kevin Verghese. All rights reserved.
//

import Foundation

enum RequestPoint {
    /// this is for user-search
    static let apiLink = "https://api.github.com/search/users?q="
    
    static func makeURL(query: String) -> URL? {
        guard let urlString = (RequestPoint.apiLink + query).addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed) else {
            return nil
        }
        return URL(string: urlString)
    }
}

