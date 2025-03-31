
import Foundation

enum CustomResult<String>{
    case success
    case failure(String)
}

public enum AuthError: Error, Equatable {
    case network
    case unknown
    case coding
    case error(String)
    case unauthorized
}

public protocol NetworkProtocol {
    func requestWith(_ route: EndPointType) async throws -> Data
}

public class NetworkConfiguration {
    nonisolated(unsafe) public static let shared = NetworkConfiguration()
    public var environment: NetworkEnvironment = .staging
}

public class NetworkManager<T: EndPointType>: NetworkProtocol {

    var router: Router<T>
    
    public init(_ session: URLSessionProtocol) {
        self.router = Router<T>(currentSession: session)
    }
    
    public func requestWith(_ route: any EndPointType) async throws -> Data {
      
        do {
            let (data, response) = try await router.request(route)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw AuthError.network
            }
            
            let result = self.handleNetworkResponse(httpResponse)
            switch result {
            case .success:
                return data
            case .failure(let error):
                if httpResponse.statusCode == 401 {
                    throw AuthError.unauthorized
                }
                throw AuthError.error(error)
            }
            
        } catch {
            throw AuthError.error(error.localizedDescription)
        }
    }
}

extension NetworkManager {
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> CustomResult<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}

enum NetworkResponse:String {
    case success
    case authenticationError = "Please authenticate first"
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "No Data."
    case unableToDecode = "Decode failed."
}
