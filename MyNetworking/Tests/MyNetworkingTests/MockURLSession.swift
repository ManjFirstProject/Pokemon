//
//  File.swift
//  MyNetworking
//
//  Created by Manjinder Singh on 29/03/2025.
//

import Foundation
@testable import MyNetworking

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    var resumeCalled = false
    var cancelCalled = false
    
    func resume() {
        resumeCalled = true
    }
    
    func cancel() {
        cancelCalled = true
    }
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

struct MockEndPoint: EndPointType {
    var baseURL: URL
    var path: String
    var httpMethod: HTTPMethod
    var bodyParameters: Parameters?
    var urlParameters: Parameters?
    var additionalHeaders: HTTPHeaders?
    
    init(baseURL: URL = URL(string: "https://mockapi.com")!,
         path: String = "/test",
         httpMethod: HTTPMethod = .get,
         bodyParameters: Parameters? = nil,
         urlParameters: Parameters? = nil,
         additionalHeaders: HTTPHeaders? = nil) {
        self.baseURL = baseURL
        self.path = path
        self.httpMethod = httpMethod
        self.bodyParameters = bodyParameters
        self.urlParameters = urlParameters
        self.additionalHeaders = additionalHeaders
    }
    
    // The task method will return different cases depending on the mock parameters
    func task() async -> HTTPTask {
        if let bodyParameters = bodyParameters, let urlParameters = urlParameters {
            return .requestParametersAndHeaders(bodyParameters: bodyParameters,
                                                 bodyEncoding: .urlEncoding,
                                                 urlParameters: urlParameters,
                                                additionHeaders: additionalHeaders)
        } else if let bodyParameters = bodyParameters {
            return .requestParameters(bodyParameters: bodyParameters,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: nil)
        } else {
            return .request
        }
    }
    
    // Headers are optional, so you can mock them
    func headers() async -> HTTPHeaders? {
        return additionalHeaders
    }
}
