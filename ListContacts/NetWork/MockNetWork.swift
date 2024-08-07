//
//  MockNetWork.swift
//  ListContacts
//
//  Created by Kevin on 8/6/24.
//

import Foundation
import Combine

final class MockNetWorkLayer: NetWorkLayer {

    private var mockFileName: String

    init(mockFileName: String) {
        self.mockFileName = mockFileName
    }

    func request<T>(_ urlRequest: URLRequest, for type: T.Type, decoder: JSONDecoder) -> AnyPublisher<T, any Error> where T: Decodable {
        guard let url = Bundle.main.url(
            forResource: mockFileName,
            withExtension: "json"
        ) else {
            return Fail(error: URLError(.fileDoesNotExist))
                .eraseToAnyPublisher()
        }

        do {
            let data = try Data(contentsOf: url)
            return Just(data)
                .decode(type: T.self, decoder: decoder)
                .mapError { $0 as Error }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
}
