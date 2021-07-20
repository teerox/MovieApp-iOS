//
//  APIManagerTests.swift
//  CarbonAssementTests
//
//  Created by Anthony Odu on 19/07/2021.
//

import Foundation
import XCTest
@testable import CarbonAssement

class APIManagerTests: XCTestCase {
    
    // custom urlsession for mock network calls
        var apiManger: APIManager!
        var urlSession: URLSession!

        override func setUpWithError() throws {
            // Set url session for mock networking
            let configuration = URLSessionConfiguration.ephemeral
            configuration.protocolClasses = [MockURLProtocol.self]
            urlSession = URLSession(configuration: configuration)
            apiManger = APIManager(urlSession: urlSession)
        }
        
    
    
        func testGetMovies() throws {
            //  API. Injected with custom url session for mocking
            let data = RemoteDataSource(apimanger: apiManger)
            // Set expectation. Used to test async code.
            let expectation = XCTestExpectation(description: "response")
            // Make mock network request to get movies
            data.getAllMovies { result in
                XCTAssertEqual(result.count, 20,"We should have loaded exactly 20 movies.")
                expectation.fulfill()
            } onFail: { _ in} onLoading: { _ in}
            
            wait(for: [expectation], timeout: 1)
        }
    
   
}
