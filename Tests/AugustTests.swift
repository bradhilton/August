//
//  AugustTests.swift
//  AugustTests
//
//  Created by Bradley Hilton on 5/17/16.
//  Copyright © 2016 Brad Hilton. All rights reserved.
//

import XCTest
import August

struct User : Convertible {
    var id: Int?
    var name: String
}

class AugustTests: XCTestCase {
    
    func testRequestBuilder() {
        let startExpectation = self.expectationWithDescription("Start")
        let successExpectation = self.expectationWithDescription("Success")
        let responseExpecation = self.expectationWithDescription("Response")
        let completionExpectation = self.expectationWithDescription("Completion")
        var (_sent, _received) = (-1.0, -1.0)
        POST<User>("http://jsonplaceholder.typicode.com/")
            .headers(["Content-Type":"application/json"])
            .path("/users")
            .body(User(id: nil, name: "Brad Hilton"))
            .start { task in
                startExpectation.fulfill()
            }.progress { task in
                XCTAssert((_sent, _received) != (task.sent, task.received))
                (_sent, _received) = (task.sent, task.received)
            }.success { response in
                XCTAssert(response.body.id != nil)
                XCTAssert(response.body.name == "Brad Hilton")
                successExpectation.fulfill()
            }.failure { (error, request) in
                XCTFail("Error: \(error)")
            }.response(201) { response in
                responseExpecation.fulfill()
            }.completion { (response, errors, request) in
                completionExpectation.fulfill()
                XCTAssert((_sent, _received) == (1.0, 1.0))
            }.logging(true).begin()
        waitForExpectationsWithTimeout(100, handler: nil)
    }
    
}

