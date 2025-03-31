//
//  File.swift
//  MyNetworking
//
//  Created by Manjinder Singh on 31/03/2025.
//

import Foundation
@testable import PokemonServices
import XCTest

final class RestAPITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }

    func testBaseURL_pokemons() {
        let api = RestAPI.pokemons
        let expectedURL = URL(string: "https://pokeapi.co/api/v2/")
        XCTAssertEqual(api.baseURL, expectedURL, "Base URL for pokemons is incorrect")
    }

    func testBaseURL_image() {
        let api = RestAPI.image("1")
        let expectedURL = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/")
        XCTAssertEqual(api.baseURL, expectedURL, "Base URL for images is incorrect")
    }

    func testPath_pokemons() {
        let api = RestAPI.pokemons
        let expectedPath = "pokemon"
        XCTAssertEqual(api.path, expectedPath, "Path for pokemons is incorrect")
    }

    func testPath_image() {
        let imageID = "25"
        let api = RestAPI.image(imageID)
        let expectedPath = "\(imageID).png"
        XCTAssertEqual(api.path, expectedPath, "Path for image is incorrect")
    }

    func testHTTPMethod_pokemons() {
        let api = RestAPI.pokemons
        XCTAssertEqual(api.httpMethod, .get, "HTTP method for pokemons should be GET")
    }

    func testHTTPMethod_image() {
        let api = RestAPI.image("25")
        XCTAssertEqual(api.httpMethod, .get, "HTTP method for image should be GET")
    }

    func testTask_pokemons() async {
        let api = RestAPI.pokemons
        let task = await api.task()

        switch task {
        case .requestParameters(let bodyParameters, let bodyEncoding, let urlParameters):
            XCTAssertNil(bodyParameters, "Body parameters should be nil for pokemons")
            XCTAssertEqual(bodyEncoding, .urlEncoding, "Body encoding should be URL encoding")
            XCTAssertEqual(urlParameters?["limit"] as! String, "150", "URL parameter 'limit' is incorrect")
            XCTAssertEqual(urlParameters?["offset"] as! String, "0", "URL parameter 'offset' is incorrect")
        default:
            XCTFail("Task for pokemons should be requestParameters")
        }
    }

    func testTask_image() async {
        let api = RestAPI.image("25")
        let task = await api.task()

        switch task {
        case .request:
            XCTAssertTrue(true, "Task for image should be a simple request")
        default:
            XCTFail("Task for image should be of type .request")
        }
    }

    func testHeaders() async {
        let api = RestAPI.pokemons
        let headers = await api.headers()
        XCTAssertNil(headers, "Headers should be nil for both pokemons and image requests")
    }
}
