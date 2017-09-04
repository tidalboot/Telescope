
//  Created by Nick Jones on 04/09/2017.
//  Copyright © 2017 NickJones. All rights reserved.
//

import XCTest

class RecordTests: XCTestCase {
    
    private var mockedRecordsData: Data?
    
    override func setUp() {
        super.setUp()
        if let mockRecordsDataPath = Bundle.main.url(forResource: "MockedRecords", withExtension: "json") {
            do {
                let rawRecordsData = try Data(contentsOf: mockRecordsDataPath)
                
                mockedRecordsData = rawRecordsData
            } catch {
                print("Unable to load the mocked record json files; Make sure all mocked data files are present and in the correct file locations!")
                return
            }
        }
    }

    func testMockedRecordsDataHasLoaded() {
        XCTAssertNotNil(mockedRecordsData, "Mock records data was not loaded correctly")
    }
    
    func testParseRecordsFromRawDataReturnsTheCorrectNumberOfRecords() {
        let records = TelescopeRecord.parseRecords(fromRawData: mockedRecordsData)
        XCTAssert(records.count == 2, "Unable to parse the correct number of records from the mocked data")
    }
    
    func testTitleIsReturnedInTheCorrectFormat() {
        let records = TelescopeRecord.parseRecords(fromRawData: mockedRecordsData)
        
        if (records.isEmpty) {
            XCTFail("No records were found")
            return
        }
        
        //We're safe to force unwrap the first object here because we've already checked that the array is not empty
        XCTAssertEqual(
            records.first!.Title,
            "Great",
            "Record title is not being parsed to the correct format"
        )
    }
    
    func testDefaultTitleValueIsCorrectWhenTitleIsUnavailable() {
        let records = TelescopeRecord.parseRecords(fromRawData: mockedRecordsData)
        
        if (records.count < 2) {
            XCTFail("Incorrect number of records are being parsed from the mocked data")
            return
        }
        
        //Again we're safe to force unwrap the first object here because we've already checked that the array contains two objects
        XCTAssertEqual(
            records[1].DateTaken,
            "N/A",
            "Record title property is not being set to the correct default value when title is not available"
        )
    }
    
    func testDateTakenIsReturnedInTheCorrectFormat() {
        let records = TelescopeRecord.parseRecords(fromRawData: mockedRecordsData)
        
        if (records.isEmpty) {
            XCTFail("No records were found")
            return
        }
        
        //We're safe to force unwrap the first object here because we've already checked that the array is not empty
        XCTAssertEqual(
            records.first!.DateTaken,
            "Sep 03, 2017",
            "Record date taken is not being parsed to the correct format"
        )
    }
    
    func testDefaultDateTakenValueIsCorrectWhenDateTakenIsUnavailable() {
        let records = TelescopeRecord.parseRecords(fromRawData: mockedRecordsData)
        
        if (records.count < 2) {
            XCTFail("Incorrect number of records are being parsed from the mocked data")
            return
        }
        
        //Again we're safe to force unwrap the first object here because we've already checked that the array contains two objects
        XCTAssertEqual(
            records[1].DateTaken,
            "N/A",
            "Date taken property is not being set to the correct default value when date taken is not available"
        )
    }
    
    func testImageDimensionsAreInTheCorrectFormatWhenAvailable() {
        let records = TelescopeRecord.parseRecords(fromRawData: mockedRecordsData)
        
        if (records.isEmpty) {
            XCTFail("No records were found")
            return
        }
        
        //We're safe to force unwrap the first object here because we've already checked that the array is not empty
        XCTAssertEqual(
            records.first!.ImageDimensions,
            "240x180",
            "Dimensions property is not being extracted when available"
        )
    }
    
    func testDefaultImageDimensionsValueIsCorrectWhenDimensionsAreUnavailable() {
        let records = TelescopeRecord.parseRecords(fromRawData: mockedRecordsData)
        
        if (records.isEmpty) {
            XCTFail("No records were found")
            return
        }
        
        //Again we're safe to force unwrap the first object here because we've already checked that the array contains two objects
        if (records.count < 2) {
            XCTFail("Incorrect number of records are being parsed from the mocked data")
            return
        }
        
        XCTAssertEqual(
            records[1].ImageDimensions,
            "N/A",
            "Dimensions property is not being set to the correct default value when dimensions are not available"
        )
    }
    
    func testAuthorIsRetrievedWhenAvailable() {
        let records = TelescopeRecord.parseRecords(fromRawData: mockedRecordsData)
        
        if (records.isEmpty) {
            XCTFail("No records were found")
            return
        }
        
        //We're safe to force unwrap the first object here because we've already checked that the array is not empty
        XCTAssertEqual(
            records.first!.Author,
            "Tyrion Fordring",
            "Author property is not being extracted when available"
        )
    }
    
    
    func testDefaultAuthorValueIsCorrectWhenAuthorIsUnavailable() {
        let records = TelescopeRecord.parseRecords(fromRawData: mockedRecordsData)
        
        if (records.isEmpty) {
            XCTFail("No records were found")
            return
        }
        
        //Again we're safe to force unwrap the first object here because we've already checked that the array contains two objects
        if (records.count < 2) {
            XCTFail("Incorrect number of records are being parsed from the mocked data")
            return
        }
        
        XCTAssertEqual(
            records[1].Author,
            "N/A",
            "Author property is not being set to the correct default value when the author is not available"
        )
    }
    
    func testOriginalSizedImageURLIsCorrectlyInferredFromMediumImageURL() {
        let records = TelescopeRecord.parseRecords(fromRawData: mockedRecordsData)
        
        if (records.isEmpty) {
            XCTFail("No records were found")
            return
        }
        
        let testURL = "https://farm5.staticflickr.com/4353/36184066574_e352dc6bd7.jpg"
        //We're safe to force unwrap the first object here because we've already checked that the array is not empty
        XCTAssertEqual(
            records.first?.Images.Original,
            testURL,
            "Original sized image URL is not being inferred from the default provided medium image URL")
    }
}




