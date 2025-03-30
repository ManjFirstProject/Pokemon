import XCTest
@testable import MyNetworking

class NetworkManagerTests: XCTestCase {
    
    var networkManager: NetworkManager!
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
        
        // When
        let result = try await networkManager.requestWith(.pokemons)
        
        // Then
        switch result {
        case .success(let data):
            XCTAssertNotNil(data)
            let response = try? JSONDecoder().decode(PokemonResponse.self, from: data)
            XCTAssertNotNil(response)
            XCTAssertEqual(response?.count, 1)
            XCTAssertEqual(response?.results.first?.name, "bulbasaur")
        case .failure:
            XCTFail("Expected success but got failure")
        }
    }
    
    func testRequestWithFailure() async throws {
        // Given
        mockSession.error = NSError(domain: "NetworkError", code: 500, userInfo: nil)
        
        // When
        let result = try await networkManager.requestWith(.pokemons)
        
        // Then
        switch result {
        case .success:
            XCTFail("Expected failure but got success")
        case .failure(let error):
            XCTAssertEqual(error, .error(error: "The operation couldn’t be completed. (NetworkError error 500.)"))
        }
    }
}
