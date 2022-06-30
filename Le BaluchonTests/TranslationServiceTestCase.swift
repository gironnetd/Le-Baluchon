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
        let service = TranslationService(session: FakeURLSession(data: FakeTranslationResponse.correctTranslation, response: FakeTranslationHttpResponse.OkHttpResponse, error: nil))
        
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
            XCTAssertEqual(error?.rawValue, FakeTranslationHttpResponse.NotImplementedResponse.statusCode)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_GivenNilTranslationAndFailedHttpResponse_WhenRetreiveData_ThenFailedHttpErrorIsThrown() {
        // Given Nil Translation And Failed HttpResponse
        let service = TranslationService(session: FakeURLSession(data: nil, response: FakeTranslationHttpResponse.failedHttpResponse, error: nil))
        
        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        service.retrieveData(from: "") { translation, error in
            // Then Failed Http Error Is Thrown
            XCTAssertNil(translation)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.rawValue, FakeTranslationHttpResponse.failedHttpResponse.statusCode)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_GivenNilTranslationAndNotFoundResponse_WhenRetreiveData_ThenNotFoundErrorIsThrown() {
        // Given Nil Translation And NotFound Response
        let service = TranslationService(session: FakeURLSession(data: nil, response: FakeTranslationHttpResponse.NotFoundResponse, error: nil))
        
        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        service.retrieveData(from: "") { translation, error in
            // Then NotFound Error Is Thrown
            XCTAssertNil(translation)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.rawValue, FakeTranslationHttpResponse.NotFoundResponse.statusCode)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
        
    func test_GivenNilTranslationAndUnauthorizedResponse_WhenRetreiveData_ThenUnauthorizedErrorIsThrown() {
        // Given Nil Translation And Unauthorized Response
        let service = TranslationService(session: FakeURLSession(data: nil, response: FakeTranslationHttpResponse.UnauthorizedResponse, error: nil))
        
        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        service.retrieveData(from: "") { translation, error in
            // Then Unauthorized Error Is Thrown
            XCTAssertNil(translation)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.rawValue, FakeTranslationHttpResponse.UnauthorizedResponse.statusCode)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_GivenNilTranslationAndForbiddenResponse_WhenRetreiveData_ThenForbiddenErrorIsThrown() {
        // Given Nil Translation And Forbidden Response
        let service = TranslationService(session: FakeURLSession(data: nil, response: FakeTranslationHttpResponse.ForbiddenResponse, error: nil))
        
        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        service.retrieveData(from: "") { translation, error in
            // Then Forbidden Error Is Thrown
            XCTAssertNil(translation)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.rawValue, FakeTranslationHttpResponse.ForbiddenResponse.statusCode)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_GivenNilTranslationAndBadRequestResponse_WhenRetreiveData_ThenBadRequestErrorIsThrown() {
        // Given Nil Translation And BadRequest Response
        let service = TranslationService(session: FakeURLSession(data: nil, response: FakeTranslationHttpResponse.BadRequestResponse, error: nil))
        
        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        service.retrieveData(from: "") { translation, error in
            // Then BadRequest Error Is Thrown
            XCTAssertNil(translation)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.rawValue, FakeTranslationHttpResponse.BadRequestResponse.statusCode)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }

    func test_GivenNilTranslationAndTooManyRequestsResponse_WhenRetreiveData_ThenTooManyRequestsErrorIsThrown() {
        // Given Nil Translation And TooManyRequests Response
        let service = TranslationService(session: FakeURLSession(data: nil, response: FakeTranslationHttpResponse.TooManyRequestsResponse, error: nil))
        
        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        service.retrieveData(from: "") { translation, error in
            // Then TooManyRequests Error Is Thrown
            XCTAssertNil(translation)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.rawValue, FakeTranslationHttpResponse.TooManyRequestsResponse.statusCode)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
        
    func test_GivenNilTranslationAndInternalServerErrorResponse_WhenRetreiveData_ThenInternalServerErrorIsThrown() {
        // Given Nil Translation And InternalServerError Response
        let service = TranslationService(session: FakeURLSession(data: nil, response: FakeTranslationHttpResponse.InternalServerErrorResponse, error: nil))
        
        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        service.retrieveData(from: "") { translation, error in
            // Then InternalServer Error Is Thrown
            XCTAssertNil(translation)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.rawValue, FakeTranslationHttpResponse.InternalServerErrorResponse.statusCode)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
        
    func test_GivenNilTranslationAndBadGatewayResponse_WhenRetreiveData_ThenBadGatewayErrorIsThrown() {
        // Given Nil Translation And BadGateway Response
        let service = TranslationService(session: FakeURLSession(data: nil, response: FakeTranslationHttpResponse.BadGatewayResponse, error: nil))
        
        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        service.retrieveData(from: "") { translation, error in
            // Then BadGateway Error Is Thrown
            XCTAssertNil(translation)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.rawValue, FakeTranslationHttpResponse.BadGatewayResponse.statusCode)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
        
    func test_GivenNilTranslationAndServiceUnavailableResponse_WhenRetreiveData_ThenServiceUnavailableErrorIsThrown() {
        // Given Nil Translation And ServiceUnavailable Response
        let service = TranslationService(session: FakeURLSession(data: nil, response: FakeTranslationHttpResponse.ServiceUnavailableResponse, error: nil))
        
        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        service.retrieveData(from: "") { translation, error in
            // Then ServiceUnavailable Error Is Thrown
            XCTAssertNil(translation)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.rawValue, FakeTranslationHttpResponse.ServiceUnavailableResponse.statusCode)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_GivenNilTranslationAndGatewayTimedOutResponse_WhenRetreiveData_ThenGatewayTimedOutErrorIsThrown() {
        // Given Nil Translation And GatewayTimedOut Response
        let service = TranslationService(session: FakeURLSession(data: nil, response: FakeTranslationHttpResponse.GatewayTimedOutResponse, error: nil))
        
        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        service.retrieveData(from: "") { translation, error in
            // Then GatewayTimedOut Error Is Thrown
            XCTAssertNil(translation)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.rawValue, FakeTranslationHttpResponse.GatewayTimedOutResponse.statusCode)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
        
    func test_GivenNilTranslationAndNotImplementedResponse_WhenRetreiveData_ThenNotImplementedErrorIsThrown() {
        // Given Nil Translation And NotImplemented Response
        let service = TranslationService(session: FakeURLSession(data: nil, response: FakeTranslationHttpResponse.NotImplementedResponse, error: nil))
        
        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        service.retrieveData(from: "") { translation, error in
            // Then NotImplemented Error Is Thrown
            XCTAssertNil(translation)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.rawValue, FakeTranslationHttpResponse.NotImplementedResponse.statusCode)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}
