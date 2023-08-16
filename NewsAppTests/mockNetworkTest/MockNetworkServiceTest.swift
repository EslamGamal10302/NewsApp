//
//  MockNetworkServiceTest.swift
//  NewsApp
//
//  Created by Eslam gamal on 01/08/2023.
//

import XCTest
@testable import NewsApp

final class MockNetworkServiceTest: XCTestCase {
    var networkService : NetworkManagerProtocol?
    
     func testGetApiDataShouldPass(){
         let myExpectation = expectation(description: "wait for my API response")
         networkService = MockNetworkService(shouldReturnError: false)
         networkService?.getApiData(url: URLs.shared.baseURL, completionHandler: { (result: Result<NewsResponse,Error>) in
             switch result {
             case .success(let result):
                 XCTAssertGreaterThan(result.articles?.count ?? 0, 0)
                 myExpectation.fulfill()
             case .failure(_):
                 XCTFail()
                 myExpectation.fulfill()
                 return
             }
         })
         waitForExpectations(timeout: 10,handler: nil)
     }
   
    func testGetApiDataShouldFail(){
        let myExpectation = expectation(description: "wait for my API response")
        networkService = MockNetworkService(shouldReturnError: true)
        networkService?.getApiData(url: URLs.shared.baseURL, completionHandler: { (result: Result<NewsResponse,Error>) in
            switch result {
            case .success(_):
                XCTFail()
                myExpectation.fulfill()
                return
            case .failure(let error):
                XCTAssertNotNil(error)
                myExpectation.fulfill()
            }
        })
        waitForExpectations(timeout: 10,handler: nil)
    }
}



