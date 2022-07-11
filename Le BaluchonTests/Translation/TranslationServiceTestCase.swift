//
//  TranslationServiceUnitTests.swift
//  Le BaluchonTests
//
//  Created by damien on 25/06/2022.
//

import XCTest
@testable import Le_Baluchon

class TranslationServiceTestCase: XCTestCase {

    private let fromText: String = "Je suis en train de regarder la télévision"
    private let toText: String = "I'm watching TV"
    
    func test_GivenCorrectTranslationAndOkHttpResponse_WhenRetreiveData_ThenResultIsCorrect() {
        // Given Correct Translation And OkHttp Response
        let service = TranslationService(session: FakeURLSession(data: FakeTranslationResponse.correctTranslation, response: FakeHttpResponse.OkHttpResponse, error: nil))
        
        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        service.retrieveData(from: "") { translation, error in
            // Then Result Is Correct
            XCTAssertNil(error)
            XCTAssertNotNil(translation)
            XCTAssertEqual(translation, self.toText)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_GivenNotNilTranslationAndNilResponse_WhenRetreiveData_ThenResultIsCorrect() {
        // Given Correct Translation And OkHttp Response
        let service = TranslationService(session: FakeURLSession(data: FakeTranslationResponse.correctTranslation, response: nil, error: nil))
        
        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        service.retrieveData(from: "") { translation, error in
            // Then Result Is Correct
            XCTAssertNil(translation)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.rawValue, FakeHttpResponse.NotImplementedResponse.statusCode)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}
