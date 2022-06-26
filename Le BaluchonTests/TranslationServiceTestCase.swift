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
        let service = TranslationService(session: FakeURLSession(data: FakeTranslationResponse.correctTranslation, response: FakeNetworkResponse.OkHttpResponse, error: nil))
        
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
            XCTAssertEqual(error?.rawValue, FakeNetworkResponse.NotImplementedResponse.statusCode)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_GivenNilTranslationAndFailedHttpResponse_WhenRetreiveData_ThenFailedHttpErrorIsThrown() {
        // Given Nil Translation And Failed HttpResponse
        let service = TranslationService(session: FakeURLSession(data: nil, response: FakeNetworkResponse.failedHttpResponse, error: nil))
        
        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        service.retrieveData(from: "") { translation, error in
            // Then Failed Http Error Is Thrown
            XCTAssertNil(translation)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.rawValue, FakeNetworkResponse.failedHttpResponse.statusCode)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_GivenNilTranslationAndNotFoundResponse_WhenRetreiveData_ThenNotFoundErrorIsThrown() {
        // Given Nil Translation And NotFound Response
        let service = TranslationService(session: FakeURLSession(data: nil, response: FakeNetworkResponse.NotFoundResponse, error: nil))
        
        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        service.retrieveData(from: "") { translation, error in
            // Then NotFound Error Is Thrown
            XCTAssertNil(translation)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.rawValue, FakeNetworkResponse.NotFoundResponse.statusCode)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
        
    func test_GivenNilTranslationAndUnauthorizedResponse_WhenRetreiveData_ThenUnauthorizedErrorIsThrown() {
        // Given Nil Translation And Unauthorized Response
        let service = TranslationService(session: FakeURLSession(data: nil, response: FakeNetworkResponse.UnauthorizedResponse, error: nil))
        
        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        service.retrieveData(from: "") { translation, error in
            // Then Unauthorized Error Is Thrown
            XCTAssertNil(translation)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.rawValue, FakeNetworkResponse.UnauthorizedResponse.statusCode)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_GivenNilTranslationAndForbiddenResponse_WhenRetreiveData_ThenForbiddenErrorIsThrown() {
        // Given Nil Translation And Forbidden Response
        let service = TranslationService(session: FakeURLSession(data: nil, response: FakeNetworkResponse.ForbiddenResponse, error: nil))
        
        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        service.retrieveData(from: "") { translation, error in
            // Then Forbidden Error Is Thrown
            XCTAssertNil(translation)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.rawValue, FakeNetworkResponse.ForbiddenResponse.statusCode)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_GivenNilTranslationAndBadRequestResponse_WhenRetreiveData_ThenBadRequestErrorIsThrown() {
        // Given Nil Translation And BadRequest Response
        let service = TranslationService(session: FakeURLSession(data: nil, response: FakeNetworkResponse.BadRequestResponse, error: nil))
        
        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        service.retrieveData(from: "") { translation, error in
            // Then BadRequest Error Is Thrown
            XCTAssertNil(translation)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.rawValue, FakeNetworkResponse.BadRequestResponse.statusCode)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }

    func test_GivenNilTranslationAndTooManyRequestsResponse_WhenRetreiveData_ThenTooManyRequestsErrorIsThrown() {
        // Given Nil Translation And TooManyRequests Response
        let service = TranslationService(session: FakeURLSession(data: nil, response: FakeNetworkResponse.TooManyRequestsResponse, error: nil))
        
        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        service.retrieveData(from: "") { translation, error in
            // Then TooManyRequests Error Is Thrown
            XCTAssertNil(translation)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.rawValue, FakeNetworkResponse.TooManyRequestsResponse.statusCode)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
        
    func test_GivenNilTranslationAndInternalServerErrorResponse_WhenRetreiveData_ThenInternalServerErrorIsThrown() {
        // Given Nil Translation And InternalServerError Response
        let service = TranslationService(session: FakeURLSession(data: nil, response: FakeNetworkResponse.InternalServerErrorResponse, error: nil))
        
        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        service.retrieveData(from: "") { translation, error in
            // Then InternalServer Error Is Thrown
            XCTAssertNil(translation)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.rawValue, FakeNetworkResponse.InternalServerErrorResponse.statusCode)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
        
    func test_GivenNilTranslationAndBadGatewayResponse_WhenRetreiveData_ThenBadGatewayErrorIsThrown() {
        // Given Nil Translation And BadGateway Response
        let service = TranslationService(session: FakeURLSession(data: nil, response: FakeNetworkResponse.BadGatewayResponse, error: nil))
        
        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        service.retrieveData(from: "") { translation, error in
            // Then BadGateway Error Is Thrown
            XCTAssertNil(translation)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.rawValue, FakeNetworkResponse.BadGatewayResponse.statusCode)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
        
    func test_GivenNilTranslationAndServiceUnavailableResponse_WhenRetreiveData_ThenServiceUnavailableErrorIsThrown() {
        // Given Nil Translation And ServiceUnavailable Response
        let service = TranslationService(session: FakeURLSession(data: nil, response: FakeNetworkResponse.ServiceUnavailableResponse, error: nil))
        
        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        service.retrieveData(from: "") { translation, error in
            // Then ServiceUnavailable Error Is Thrown
            XCTAssertNil(translation)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.rawValue, FakeNetworkResponse.ServiceUnavailableResponse.statusCode)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_GivenNilTranslationAndGatewayTimedOutResponse_WhenRetreiveData_ThenGatewayTimedOutErrorIsThrown() {
        // Given Nil Translation And GatewayTimedOut Response
        let service = TranslationService(session: FakeURLSession(data: nil, response: FakeNetworkResponse.GatewayTimedOutResponse, error: nil))
        
        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        service.retrieveData(from: "") { translation, error in
            // Then GatewayTimedOut Error Is Thrown
            XCTAssertNil(translation)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.rawValue, FakeNetworkResponse.GatewayTimedOutResponse.statusCode)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
        
    func test_GivenNilTranslationAndNotImplementedResponse_WhenRetreiveData_ThenNotImplementedErrorIsThrown() {
        // Given Nil Translation And NotImplemented Response
        let service = TranslationService(session: FakeURLSession(data: nil, response: FakeNetworkResponse.NotImplementedResponse, error: nil))
        
        // When Retreive Data
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        service.retrieveData(from: "") { translation, error in
            // Then NotImplemented Error Is Thrown
            XCTAssertNil(translation)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.rawValue, FakeNetworkResponse.NotImplementedResponse.statusCode)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}
