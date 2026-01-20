//
//  MockURLProtocol.swift
//  RacesFeature
//
//  Created by Chris Nevin on 20/1/2026.
//

import Foundation

enum MockURLProtocolError: Error {
    case noRequestHandler
}

final class MockURLProtocol: URLProtocol, @unchecked Sendable {
    private static let requestHandlerStorage = RequestHandlerStorage()

    static func setHandler(_ handler: @Sendable @escaping (URLRequest) async throws -> (HTTPURLResponse, Data)) async {
        await requestHandlerStorage.setHandler { request in
            try await handler(request)
        }
    }

    func executeHandler(for request: URLRequest) async throws -> (HTTPURLResponse, Data) {
        try await Self.requestHandlerStorage.executeHandler(for: request)
    }

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        Task {
            do {
                let (response, data) = try await self.executeHandler(for: request)
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                client?.urlProtocol(self, didLoad: data)
                client?.urlProtocolDidFinishLoading(self)
            } catch {
                client?.urlProtocol(self, didFailWithError: error)
            }
        }
    }

    override func stopLoading() {}
}
