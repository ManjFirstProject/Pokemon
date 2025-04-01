import Foundation
public extension API {
    enum Error: Swift.Error {
        case decode
        case server
        case client
        case noConnection
        case unauthorised
    }
}

extension Error {
    func isNetworkConnectionError() -> Bool {
        let error = self as NSError
        let networkErrors = [NSURLErrorNotConnectedToInternet,
                             NSURLErrorNetworkConnectionLost,
                             NSURLErrorInternationalRoamingOff,
                             NSURLErrorCallIsActive,
                             NSURLErrorDataNotAllowed,
                             NSURLErrorTimedOut]

        if error.domain == NSURLErrorDomain && networkErrors.contains(error.code) {
            return true
        }
        return false
    }
}
