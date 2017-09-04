//
//  RecordTests.swift
//  Telescope
//
//  Created by Nick Jones on 04/09/2017.
//  Copyright © 2017 NickJones. All rights reserved.
//

import XCTest

class RecordTests: XCTestCase {
    
    private var mockedRecordsData: Data?
    
    override func setUp() {
        super.setUp()
        super.setUp()
        if let mockRecordsDataPath = Bundle.main.url(forResource: "MockedData", withExtension: "json") {
            do {
                let rawRecordsData = try Data(contentsOf: mockRecordsDataPath)
                
                mockedRecordsData = rawRecordsData
            } catch {
                print("Unable to load the mocked record json files; Make sure all mocked data files are present and in the correct file locations!")
                return
            }
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
