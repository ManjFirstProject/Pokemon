
import Foundation

enum CustomResult<String>{
    case success
    case failure(String)
}

public enum AuthError: Error, Equatable {
    case network
    case unknown
    case coding
    case error(error: String)
}

public protocol NetworkProtocol {
    
    func requestWith(_ route: RestAPI) async throws -> Result<Data, AuthError>
}

public class NetworkManager: NetworkProtocol {
    
    static let environment : NetworkEnvironment = .staging
    
    var router: Router<RestAPI>
    
    public init(_ session: URLSessionProtocol) {
        router = Router<RestAPI>(currentSession: session)
    }
    
   public func requestWith(_ route: RestAPI) async throws -> Result<Data, AuthError> {
        
        do {
            let (data, response) = try await router.request(route)
            
            guard let response = response as? HTTPURLResponse else {
                return .failure(.network)
            }
            
            let result = self.handleNetworkResponse(response)
            switch result {
            case .success:
                return .success(data)
            case .failure(let error):
                if response.statusCode == 401  { // unauthorised, refresh token handle accordingly
                    return .failure(.error(error: error))
                }
                return .failure(.error(error: error))
            }
            
        } catch (let error) {
            return .failure(.error(error: error.localizedDescription))
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
