//
//  sampleappTests.swift
//  sampleappTests
//
//  Created by Ricarlo Silva on 30/10/21.
//

import XCTest
import CoreNetwork
@testable import sampleapp

class sampleappTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() async throws {
        
        guard let url = URL(string: "https://www.mockachino.com/736ea5cc-a723-43/users") else {
            return
        }
        let result = await NetworkClient.shared.getRequest(url: url, type: String.self)
        switch result {
        case .success(let user):
            XCTAssertEqual(user, "test")
            
        case .failure(let error):
            XCTAssertTrue(error is DecodingError)
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
