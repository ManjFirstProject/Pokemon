#if DEBUG
import Foundation
extension API.Client {
    public static func mock(
        make: @escaping (API.Request) async throws -> Data = { _ in .init() }
    ) -> Self {
        Self { request in
            try await make(request)
        }
    }
}
#endif
