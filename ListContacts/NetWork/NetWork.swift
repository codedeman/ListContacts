//
//  NetWork.swift
//  ListContacts
//
//  Created by Kevin on 8/2/24.
//

import Foundation
import Combine

public protocol NetWorkLayer: AnyObject {

    func request<T: Decodable>(_ urlRequest: URLRequest, for type: T.Type, decoder: JSONDecoder) -> AnyPublisher<T, Error>

}

public extension NetWorkLayer {

    func request<T: Decodable>(
        _ urlRequest: URLRequest,
        for type: T.Type,
        decoder: JSONDecoder = JSONDecoder()
    ) -> AnyPublisher<T, Error> {
        URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { result -> T in
                let value = try decoder.decode(T.self, from: result.data)
                return value
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

}

final class DBNetWorkLayer: NetWorkLayer {
    init () { }

    func request<T>(
        _ urlRequest: URLRequest,
        for type: T.Type,
        decoder: JSONDecoder
    ) -> AnyPublisher<T, any Error> where T : Decodable {

        return URLSession
            .shared
            .dataTaskPublisher(for: urlRequest)
            .map { $0.data }
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }

}
