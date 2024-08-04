//
//  UseCases.swift
//  UserProfile
//
//  Created by Kevin on 8/2/24.
//

import Foundation
import Combine

public protocol UseCases {
    func fetchUsers(pageNum: Int, limit: Int) -> AnyPublisher<[User], Error>
}

final class DBUseCases: UseCases {

    let netWork: NetWorkLayer
    let urlManager: URLManager

    init(
        netWork: NetWorkLayer = DBNetWorkLayer(),
        urlManager: URLManager = URLManager()
    ) {
        self.netWork = netWork
        self.urlManager = urlManager
    }

    func fetchUsers(
        pageNum: Int,
        limit: Int
    ) -> AnyPublisher<[User], any Error> {

        guard let url = urlManager.usersURL(
            pageNum: pageNum,
            perPage: limit
        ) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return netWork.request(
            url,
            for: [User].self,
            decoder: JSONDecoder()
        )
    }

}
