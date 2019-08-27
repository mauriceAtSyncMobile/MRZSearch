//
//  IdSearchTests.swift
//  IdSearchTests
//
//  Created by Maurice Carrier on 8/26/19.
//  Copyright © 2019 Maurice Carrier. All rights reserved.
//

import XCTest
@testable import IdSearch

class IdSearchTests: XCTestCase {
    
    let networkManager = NetworkManager.sharedInstance
    let testMRZOne = (mrz: "P<USAROGGER<<MICHAEL<<<<<<<<<<<<<<<<<<<<<<<<YA11164461USA8502201M2001023<<<<<<<<<<<<<<00", expectedFirstName: "MICHAEL", expectedLastName: "ROGGER")
    let testMRZTwo = (mrz: "P<USARICHARDS<STEVENS<JR<<GEORGE<MICHAEL<<<<123456A<<5USA8502201F2001012<<<<<<<<<<<<<<08", expectedFirstName: "GEORGE MICHAEL", expectedLastName: "RICHARDS STEVENS JR")
    let testInvalidMRZ = "abcedefghijklmnopqrstuvwxyz"
    let testEmptyString = ""
    
    override func setUp() {}
    
    override func tearDown() {}
    
    func testEmptyStringParsingError() {
        XCTAssertThrowsError(try testEmptyString.parseName()) { error in
            XCTAssertEqual(error as? MRZParsingError, MRZParsingError.noInputProvided)
        }
    }
    
    func testInvalidStringParsingError() {
        XCTAssertThrowsError(try testInvalidMRZ.parseName()) { error in
            XCTAssertEqual(error as? MRZParsingError, MRZParsingError.invalidInput)
        }
    }
    
    func testValidStringParsing() {
        if let validResponseOne = try? testMRZOne.mrz.parseName() {
            XCTAssertEqual(validResponseOne.first, testMRZOne.expectedFirstName)
            XCTAssertEqual(validResponseOne.last, testMRZOne.expectedLastName)
        }
        
        if let validResponseTwo = try? testMRZTwo.mrz.parseName() {
            XCTAssertEqual(validResponseTwo.first, testMRZTwo.expectedFirstName)
            XCTAssertEqual(validResponseTwo.last, testMRZTwo.expectedLastName)
        }
    }
    
    
    func testSuccesfulSearchQuery() {
        let expectation1 = expectation(description: "Successfully fetched users.")
        guard let validUser = try? testMRZOne.mrz.parseName() else {
            XCTFail()
            return
        }
        
        networkManager.fetchUsers(withName: validUser) { (result) in
            switch result {
            case .success(let users):
                if users.count > 0 {
                    expectation1.fulfill()
                }
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        waitForExpectations(timeout: 1000) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTime thre: \(error.localizedDescription)")
            }
        }
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
