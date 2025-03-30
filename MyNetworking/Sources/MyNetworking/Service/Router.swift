//
//  Router.swift
//  Manj
//
//  Created by Manjinder Singh on 29/03/2025.
//  Copyright © 2025 Manjinder Singh. All rights reserved.
//

import Foundation

public typealias NetworkRouterCompletion = (Data, URLResponse)

public enum NetworkEnvironment: Sendable {
    case production
    case staging
    case dev
}

protocol NetworkRouter: AnyObject {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint) async throws -> NetworkRouterCompletion
    func cancel()
}

public protocol URLSessionDataTaskProtocol {
    func resume()
    func cancel()
}

public protocol URLSessionProtocol {
    
    func dataTask(with request: URLRequest) async throws -> NetworkRouterCompletion
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}

extension URLSession: URLSessionProtocol {
    public func dataTask(with request: URLRequest) async throws -> NetworkRouterCompletion {
        return try await data(for: request)
    }
}

class Router<EndPoint: EndPointType>: NetworkRouter {
    
    private let session: URLSessionProtocol
    private var task: URLSessionDataTaskProtocol?
    
    init(currentSession session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func request(_ route: EndPoint) async throws -> NetworkRouterCompletion {
        do {
            let request = try await self.buildRequest(from: route)
            NetworkLogger.log(request: request)
            
            let result = try await session.dataTask(with: request)
            return result
        } catch {
            throw error
        }
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    fileprivate func buildRequest(from route: EndPoint) async throws -> URLRequest {
        
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        
        request.httpMethod = route.httpMethod.rawValue
        let task = await route.task()
        
        switch task {
        case .request:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        case .requestParameters(let bodyParameters,
                                let bodyEncoding,
                                let urlParameters):
            
            try self.configureParameters(bodyParameters: bodyParameters,
                                         bodyEncoding: bodyEncoding,
                                         urlParameters: urlParameters,
                                         request: &request)
            
        case .requestParametersAndHeaders(let bodyParameters,
                                          let bodyEncoding,
                                          let urlParameters,
                                          let additionalHeaders):
            
            self.addAdditionalHeaders(additionalHeaders, request: &request)
            try self.configureParameters(bodyParameters: bodyParameters,
                                         bodyEncoding: bodyEncoding,
                                         urlParameters: urlParameters,
                                         request: &request)
        }
        return request
    }
    
    fileprivate func configureParameters(bodyParameters: Parameters?,
                                         bodyEncoding: ParameterEncoding,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters,
                                    urlParameters: urlParameters)
        } catch {
            throw error
        }
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}
