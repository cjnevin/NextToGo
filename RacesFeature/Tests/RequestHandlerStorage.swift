//
//  RequestHandlerStorage.swift
//  RacesFeature
//
//  Created by Chris Nevin on 20/1/2026.
//

import Foundation

actor RequestHandlerStorage {
    private var requestHandler: ( @Sendable (URLRequest) async throws -> (HTTPURLResponse, Data))?

    func setHandler(_ handler: @Sendable @escaping (URLRequest) async throws -> (HTTPURLResponse, Data)) async {
        requestHandler = handler
    }

    func executeHandler(for request: URLRequest) async throws -> (HTTPURLResponse, Data) {
        guard let handler = requestHandler else {
            throw MockURLProtocolError.noRequestHandler
        }
        return try await handler(request)
    }
}
