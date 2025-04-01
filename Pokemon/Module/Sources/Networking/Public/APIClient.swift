import Foundation
public extension API {
    struct Client {
        /// Networking API.
        ///
        /// Example:
        /// ```swift
        /// extension Repository {
        ///     static func live(
        ///         apiClient: API.Client = .live,
        ///         decoder: DecodeDataMapper<Response> = .live()
        ///     ) -> Self {
        ///         Self(
        ///             fetch: { postcode in
        ///                 let data = try await apiClient.makeRequest(
        ///                     .bare(
        ///                         path: "/path/to/content",
        ///                         method: .get,
        ///                         queries: ["key": value]
        ///                     )
        ///                 )
        ///                 return try decoder.map(data)
        ///             }
        ///         )
        ///     }
        /// }
        /// ```
        /// - Parameter request: StandardAPIRequest
        /// - Returns: Data
        public let makeRequest: (_ request: Request) async throws -> Data
    }
}

extension API.Client {
    public static func live(
        session: URLSession = URLSession(configuration: .default)
    ) -> Self {
        Self { request in
            do {
                return try await session.data(for: request.urlRequest).0
            } catch {
                if error.isNetworkConnectionError() {
                    throw API.Error.noConnection
                } else if error is DecodingError {
                    throw API.Error.decode
                }
                // Map other errors

                throw API.Error.server
            }
        }
    }
}
