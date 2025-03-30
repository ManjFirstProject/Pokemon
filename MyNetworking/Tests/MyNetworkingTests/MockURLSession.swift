//
//  File.swift
//  MyNetworking
//
//  Created by Manjinder Singh on 29/03/2025.
//

import Foundation
@testable import MyNetworking

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    func resume() {}
    func cancel() {}
}

class MockURLSession: URLSessionProtocol {
    var data: Data?
    var response: URLResponse?
    var error: Error?

    func dataTask(with request: URLRequest) async throws -> NetworkRouterCompletion {
        if let error = error {
            throw error
        }
        return (data ?? Data(), response ?? URLResponse())
    }
}
