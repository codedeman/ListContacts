//
//  DBNetWorkLayerTests.swift
//  ListContactsTests
//
//  Created by Kevin on 8/4/24.
//

import XCTest
import Combine
@testable import ListContacts

struct TestModel: Decodable {
    let id: Int
    let name: String
}

final class DBNetWorkLayerTests: XCTestCase {
    private var cancellables: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        try super.setUpWithError()

        // Register the mock URL protocol
        URLProtocol.registerClass(MockURLProtocol.self)
    }

    override func tearDownWithError() throws {
        // Unregister the mock URL protocol
        URLProtocol.unregisterClass(MockURLProtocol.self)

        try super.tearDownWithError()
    }

    func testRequest_success() throws {
            // Given
            let networkLayer = DBNetWorkLayer()
            let url = URL(string: "https://api.example.com/test")!
            let urlRequest = URLRequest(url: url)
            let responseJSON = """
            {
                "id": 1,
                "name": "Test"
            }
            """
            let responseData = responseJSON.data(using: .utf8)!

            MockURLProtocol.requestHandler = { request in
                XCTAssertEqual(request.url, url)
                let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
                return (response, responseData)
            }

            let expectation = self.expectation(description: "Network request")

            // When
            networkLayer.request(urlRequest, for: TestModel.self, decoder: JSONDecoder())
                .sink(receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        XCTFail("Request failed with error: \(error)")
                    }
                }, receiveValue: { value in
                    XCTAssertEqual(value.id, 1)
                    XCTAssertEqual(value.name, "Test")
                    expectation.fulfill()
                })
                .store(in: &cancellables)

            // Then
            waitForExpectations(timeout: 1, handler: nil)
        }

    func testRequest_failure() throws {
            // Given
            let networkLayer = DBNetWorkLayer()
            let url = URL(string: "https://api.example.com/test")!
            let urlRequest = URLRequest(url: url)

            MockURLProtocol.requestHandler = { request in
                XCTAssertEqual(request.url, url)
                let response = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)!
                return (response, Data())
            }

            let expectation = self.expectation(description: "Network request")

            // When
            networkLayer.request(urlRequest, for: TestModel.self, decoder: JSONDecoder())
                .sink(receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        XCTAssertNotNil(error)
                        expectation.fulfill()
                    }
                }, receiveValue: { value in
                    XCTFail("Request succeeded unexpectedly with value: \(value)")
                })
                .store(in: &cancellables)

            // Then
            waitForExpectations(timeout: 1, handler: nil)
        }



}
