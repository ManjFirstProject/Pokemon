//
//  File.swift
//  MyNetworking
//
//  Created by Manjinder Singh on 31/03/2025.
//

import Foundation
@testable import MyNetworking
import XCTest

class RestAPITests: XCTestCase {

    var mockSession: MockURLSession!
    var router: Router<RestAPI>!

    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        router = Router<RestAPI>(currentSession: mockSession)
    }

    override func tearDown() {
        mockSession = nil
        router = nil
        super.tearDown()
    }

    func testRequestForPokemons() async throws {
        // Given: Setup the mock response data
        let mockData = Data("{\"results\": [{\"name\": \"Pikachu\"}]}".utf8)
        let mockResponse = HTTPURLResponse(url: URL(string: "https://pokeapi.co/api/v2/pokemon")!,
                                           statusCode: 200, httpVersion: nil, headerFields: nil)
        mockSession.data = mockData
        mockSession.response = mockResponse

        let endPoint = RestAPI.pokemons
        
        // When: Make the request
        let result = try await router.request(endPoint)

        // Then: Verify that the result matches the mock response
        XCTAssertEqual(String(data: result.0, encoding: .utf8), "{\"results\": [{\"name\": \"Pikachu\"}]}")
        XCTAssertEqual(result.1 as? HTTPURLResponse, mockResponse)
    }

    func testRequestForImage() async throws {
        // Given: Setup the mock response data for image
        let mockData = Data() 
        let mockResponse = HTTPURLResponse(url: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png")!,
                                           statusCode: 200, httpVersion: nil, headerFields: nil)
  
        mockSession.response = mockResponse

        let endPoint = RestAPI.image("1")
        
        // When: Make the request
        let result = try await router.request(endPoint)
        
        // Then: Verify that the result matches the mock response
        XCTAssertEqual(result.0, mockData)
        XCTAssertEqual(result.1 as? HTTPURLResponse, mockResponse)
    }

    func testRequestForInvalidResponse() async throws {
        // Given: Setup the mock response with an error
        mockSession.error = NSError(domain: "NetworkError", code: 500, userInfo: nil)

        let endPoint = RestAPI.pokemons
        
        // When: Make the request
        do {
            _ = try await router.request(endPoint)
            XCTFail("Expected error to be thrown")
        } catch let error as NSError {
            // Then: Verify the error is the one we mocked
            XCTAssertEqual(error.domain, "NetworkError")
            XCTAssertEqual(error.code, 500)
        }
    }
}
