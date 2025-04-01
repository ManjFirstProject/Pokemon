import Foundation

/// Provides simple data mapping into a decodable object.
public struct DecodeDataMapper<T: Decodable> {
    public let map: (Data) throws -> T
}

// MARK: - Live implementation
public extension DecodeDataMapper {
    static func live() -> Self {
        Self(
            map: { data in
                let decoder = JSONDecoder()
                do {
                    return try decoder.decode(T.self, from: data)
                } catch let decodingError as DecodingError {
                    throw decodingError
                }
            }
        )
    }
}
