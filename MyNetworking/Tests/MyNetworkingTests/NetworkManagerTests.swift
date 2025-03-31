import XCTest
@testable import MyNetworking

extension XCTestCase {
    public func XCTAssertThrowsAsync<T>(
        expression: @autoclosure () async throws -> T,
        message: @autoclosure () -> String = "",
        file: StaticString = #filePath,
        line: UInt = #line
    ) async {
        do {
            _ = try await expression()
            XCTFail("Expected throw, but none was thrown.", file: file, line: line)
        } catch {}
    }
    
    public func XCTAssertThrowsErrorAsync<T> (
        expression: @autoclosure () async throws -> T,
        message: @autoclosure () -> String = "",
        file: StaticString = #filePath,
        line: UInt = #line,
        completion: (Error) -> Void = { _ in}
    ) async {
        do {
            _ = try await expression()
            XCTFail("Expected throw, but none was thrown.", file: file, line: line)
        } catch {
            completion(error)
        }
    }
}

class NetworkManagerTests: XCTestCase {
    
    var networkManager: NetworkManager<MockEndPoint>!
    var mockSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        networkManager = NetworkManager(mockSession)
    }
    
    override func tearDown() {
        networkManager = nil
        mockSession = nil
        super.tearDown()
    }
    
    func testRequestWithSuccess() async throws {
        // Given
        let jsonData = """
        {
            "count": 1,
            "next": null,
            "previous": null,
            "results": [
                {
                    "name": "bulbasaur",
                    "url": "https://pokeapi.co/api/v2/pokemon/1/"
                }
            ]
        }
        """.data(using: .utf8)
        
        mockSession.data = jsonData
        mockSession.response = HTTPURLResponse(url: URL(string: "https://pokeapi.co/api/v2/pokemon")!,
                                               statusCode: 200,
                                               httpVersion: nil,
                                               headerFields: nil)
        let endPoint = MockEndPoint.init()
        
        // When
        let data = try await networkManager.requestWith(endPoint)
        
        // Then
        
        XCTAssertNotNil(data)
    }
    
    func testRequestWithFailure() async throws {
        // Given
        mockSession.error = NSError(domain: "NetworkError", code: 500, userInfo: nil)
        
        let endPoint = MockEndPoint.init()
        // When
        await XCTAssertThrowsErrorAsync(expression:  try await networkManager.requestWith(endPoint),
                                  message: "Expected to throw an error") { error in
            // Then
            XCTAssertEqual(error as! AuthError, AuthError.error("The operation couldn’t be completed. (NetworkError error 500.)"))
        }
    }
    
    func testRequestWithParameters() async throws {
        let mockEndPoint = MockEndPoint(path: "/test-path",
                                        httpMethod: .post,
                                        bodyParameters: ["key": "value"],
                                        additionalHeaders: ["Authorization": "Bearer token"])
        
        // Create the mock session and router
        let mockSession = MockURLSession()
        let router = Router<MockEndPoint>(currentSession: mockSession)
        
        // Simulate mock response data
        mockSession.data = Data("{\"key\": \"value\"}".utf8)
        mockSession.response = URLResponse()
        
        // Make the request
        let result = try await router.request(mockEndPoint)
        
        // Assert that the data is returned correctly
        XCTAssertEqual(String(data: result.0, encoding: .utf8), "{\"key\": \"value\"}")
        
    }
    
    func testRequestThrowsError() async throws {
        let mockEndPoint = MockEndPoint(path: "/test-path", httpMethod: .get)
        
        // Create the mock session and router
        let mockSession = MockURLSession()
        let router = Router<MockEndPoint>(currentSession: mockSession)
        
        // Simulate a network error
        let expectedError = NSError(domain: "NetworkError", code: 500, userInfo: nil)
        mockSession.error = expectedError
        
        do {
            _ = try await router.request(mockEndPoint)
            XCTFail("Expected error but got success")
        } catch let error as NSError {
            XCTAssertEqual(error, expectedError)
        }
    }
}
