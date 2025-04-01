import Foundation
public extension API {
    struct Request {
        public enum Method: String {
            case get, put, post, patch, delete
        }
        public enum ContentType: String {
            case json = "application/json"
        }

        public var domain: String { "https://pokeapi.co/api/v2/" }
        public let path: String
        public let method: Method
        public let bodyData: Data?
        public let contentType: ContentType
        public let headers: [String: String]?
        public let queries: [String: String]?
    }
}

extension API.Request {
    var urlRequest: URLRequest {
        var request = URLRequest(
            url: endpoint,
            timeoutInterval: 60
        )
        request.httpBody = bodyData
        request.httpMethod = method.rawValue.uppercased()

        headers?
            .compactMapValues { $0 }
            .forEach { content in
                request.setValue(content.value, forHTTPHeaderField: content.key)
            }

        request.setValue(
            contentType.rawValue,
            forHTTPHeaderField: "Content-Type"
        )

        return request
    }
    var endpoint: URL {
        guard
            !domain.isEmpty, !path.isEmpty,
            let baseUrl = URL(string: domain),
            let url = URL(string: path, relativeTo: baseUrl),
            let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        else {
            preconditionFailure("Failed to construct valid url")
        }

        guard let url = components.url else {
            preconditionFailure("Failed to construct valid url")
        }

        return url
    }
}

public extension API.Request {
    static func bare(
        path: String,
        method: Method,
        body: Data? = nil,
        headers: [String: String]? = nil,
        queries: [String: String]? = nil,
        contentType: ContentType = .json
    ) -> Self {
        Self(
            path: path,
            method: method,
            bodyData: body,
            contentType: contentType,
            headers: headers,
            queries: queries
        )
    }
}
