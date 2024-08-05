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



}
