//
//  NetWork.swift
//  ListContacts
//
//  Created by Kevin on 8/2/24.
//

import Foundation
import Combine

protocol NetWorkLayer: AnyObject {
    func request<T: Decodable>(_ urlRequest: URLRequest, for type: T.Type, decoder: JSONDecoder) -> AnyPublisher<T, Error>
    func request<T: Decodable>(_ urlRequest: URLRequest, for type: T.Type, decoder: JSONDecoder) async throws -> T


}

 extension NetWorkLayer {

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
    func request<T>(_ urlRequest: URLRequest, for type: T.Type, decoder: JSONDecoder) async throws -> T where T : Decodable {
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        let decodedObject = try decoder.decode(T.self, from: data)
        return decodedObject
    }
    
    init () { }

    func request<T>(
        _ urlRequest: URLRequest,
        for type: T.Type,
        decoder: JSONDecoder
    ) -> AnyPublisher<T, any Error> where T : Decodable {

        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map { $0.data }
            .tryMap { data in

                self.logPrettyPrintedJSON(data: data)

                do {

                    return try decoder.decode(T.self, from: data)
                } catch {
                    throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Failed to decode data"))
                }
            }
            .eraseToAnyPublisher()

    }

    private func logPrettyPrintedJSON(data: Data) {
         if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
            let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
            let jsonString = String(data: jsonData, encoding: .utf8) {
             print("Response Data (Pretty-Printed JSON):\n\(jsonString)")
         } else {
             print("Response Data: \(data.count) bytes")
         }
     }

}
