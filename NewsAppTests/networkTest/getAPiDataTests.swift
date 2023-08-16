//
//  getAPiDataTests.swift
//  NewsApp
//
//  Created by Eslam gamal on 01/08/2023.
//

import XCTest
import Alamofire
@testable import NewsApp

final class getAPiDataTests: XCTestCase {
    var networkManager : NetworkManagerProtocol!
    override func setUpWithError() throws {
        networkManager = NetworkManager.shared
    }
    override func tearDownWithError() throws {
        super.tearDown()
        networkManager = nil
    }
    //MARK: - test get api data
    func testGetApiData_Success() {
           // Given
           let expectation = expectation(description: "API data retrieval")
        let url = URLs.shared.dataURL(category: "general")
           // When
        networkManager.getApiData(url: url) { (result: Result<NewsResponse, Error>) in
               // Then
               switch result {
               case .success(let data):
                   XCTAssertNotNil(data)
                   expectation.fulfill()
               case .failure(let error):
                   XCTFail("Error: \(error.localizedDescription)")
               }
           }
           
           waitForExpectations(timeout: 5.0)
       }
    
    func testGetApiData_Failure_InvalidURL() {
           // Given
           let expectation = expectation(description: "API data retrieval")
           let invalidURL = "https://invalid-url.com"
           
           // When
        networkManager.getApiData(url: invalidURL) { (result: Result<NewsResponse, Error>) in
               // Then
               switch result {
               case .success:
                   XCTFail("Expected failure, but received success.")
               case .failure(let error):
                   XCTAssertNotNil(error)
                   expectation.fulfill()
               }
           }
           
           waitForExpectations(timeout: 5.0)
       }
}
