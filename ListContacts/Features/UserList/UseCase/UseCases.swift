//
//  UseCases.swift
//  UserProfile
//
//  Created by Kevin on 8/2/24.
//

import Foundation
import Combine

protocol UseCases {
    func fetchUsers(pageNum: Int, limit: Int) -> AnyPublisher<[User], Error>
    func fetchInforUser(userName: String) -> AnyPublisher<UserInformation, Error>
    func cacheUsers(_ users: [User])
    func loadCachedUsers() -> [User]

}

final class DBUseCases: UseCases {

    
    
    private let netWork: NetWorkLayer
    private let urlManager: URLManager
    private let storages: UserPersistence
    init(
        netWork: NetWorkLayer = DBNetWorkLayer(),
        urlManager: URLManager = URLManager(),
        storages: DBUserPersistence = DBUserPersistence()
    ) {
        self.storages = storages
        self.netWork = netWork
        self.urlManager = urlManager
    }

    func fetchUsers(
        pageNum: Int,
        limit: Int
    ) -> AnyPublisher<[User], any Error> {

        guard let url = try? urlManager.usersURL(
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

    func fetchInforUser(userName: String) -> AnyPublisher<UserInformation, any Error> {
   
        guard let url = try? urlManager.userInformationURL(userName: userName) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        return netWork.request(
            url,
            for: UserInformation.self,
            decoder: JSONDecoder()
        )
    }

    func cacheUsers(_ users: [User]) {
        storages.cacheItems(users, forKey: "cachedUsers")
    }

    func loadCachedUsers() -> [User] {
        return storages.loadCachedItems(forKey: "cachedUsers")
    }


}
