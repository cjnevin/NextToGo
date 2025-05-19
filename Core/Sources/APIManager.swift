//
//  APIManager.swift
//  Core
//
//  Created by Chris Nevin on 18/5/2025.
//

import Foundation

/// `APIManager` defines the types required for making an API call and decoding the response.
public actor APIManager {
    public let decoder: JSONDecoder
    public let urlSession: URLSession

    public init(
        decoder: JSONDecoder = .default,
        // Use ephemeral to fix fetching issue: https://developer.apple.com/forums/thread/777999 in iOS 18.4 simulator
        urlSession: URLSession = URLSession(configuration: .ephemeral)
    ) {
        self.decoder = decoder
        self.urlSession = urlSession
    }
}
