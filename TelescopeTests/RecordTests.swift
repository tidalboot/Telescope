
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

    func testMockedRecordsDataHasLoaded() {
        XCTAssertNotNil(mockedRecordsData, "Mock records data was not loaded correctly")
    }
    
    func testParseRecordsFromRawDataReturnsAnArrayOfRecords() {
        let records = TelescopeRecord.parseRecords(fromRawData: mockedRecordsData)
        XCTAssert(records.isEmpty!, "Unable to parse an array of records from the mocked  data")
    }
    
    func testDateTakenIsReturnedInTheCorrectFormat() {
        let records = TelescopeRecord.parseRecords(fromRawData: mockedRecordsData)
        
        if (records.isEmpty) {
            XCTFail("No records were found")
        }
        
        XCTAssertEqual(
            records.first.DateTaken,
            "3rd September 2017",
            "Record date taken is not being parsed to the correct format"
        )
    }
    
    func testImageDimensionsAreInTheCorrectFormatWhenAvailable() {
        let records = TelescopeRecord.parseRecords(fromRawData: mockedRecordsData)
        
        if (records.isEmpty) {
            XCTFail("No records were found")
        }
        
        XCTAssertEqual(
            records.first.Dimensions,
            "Dimensions: 240x180",
            "Dimensions property is not being extracted when available"
        )
    }
    
    func testDefaultImageDimensionsValueIsCorrectWhenDimensionsAreUnavailable() {
        let records = TelescopeRecord.parseRecords(fromRawData: mockedRecordsData)
        
        if (records.isEmpty) {
            XCTFail("No records were found")
        }
        
        XCTAssertEqual(
            records[1].Dimensions,
            "Dimensions: N/A",
            "Dimensions property is not being set to the correct default value when dimensions are not available"
        )
    }
    
    func testAuthorIsRetrievedWhenAvailable() {
        let records = TelescopeRecord.parseRecords(fromRawData: mockedRecordsData)
        
        if (records.isEmpty) {
            XCTFail("No records were found")
        }
    
        XCTAssertEqual(
            records.first.Author,
            "TyrionFordring",
            "Author property is not being extracted when available"
        )
    }

    
    func testDefaultAuthorValueIsCorrectWhenAuthorIsUnavailable() {
        let records = TelescopeRecord.parseRecords(fromRawData: mockedRecordsData)
        
        if (records.isEmpty) {
            XCTFail("No records were found")
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
        }
        
        XCTAssertEqual(
            records.first.Images.Original,
            "https://farm5.staticflickr.com/4353/36184066574_e352dc6bd7.jpg",
            "Original sized image URL is not being inferred from the default provided medium image URL")
    }
}




