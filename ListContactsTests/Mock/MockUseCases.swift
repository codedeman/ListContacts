//
//  MockUseCases.swift
//  ListContactsTests
//
//  Created by Kevin on 8/4/24.
//

import Foundation
import Combine

final class MockUseCases: UseCases {
    private let storage: UserPersistence
    init(storage: UserPersistence) {
        self.storage = storage
    }

    func cacheUsers(_ users: [User]) {
        storage.cacheItems(users, forKey: "mockCache")
    }
    
    func loadCachedUsers() -> [User] {
        return storage.loadCachedItems(forKey: "mockCache")
    }
    
    func fetchInforUser2(userName: String) -> AnyPublisher<Test, any Error> {
        let test = Test(login: "", id: 123, avatar_url: "Dan choi tui my")
        return Just(test)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func fetchInforUser(userName: String) -> AnyPublisher<UserInformation, any Error> {
        let userInformation = UserInformationBuilder()
            .setLogin("johndoe")
            .setId(123)
            .setNodeId("node123")
            .build()
        return Just(userInformation)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func fetchUsers(pageNum: Int, limit: Int) -> AnyPublisher<[User], any Error> {
        let users = (0..<limit).map { index in
                  ListContacts.User(
                      login: "user\(index + pageNum * limit)",
                      id: index + pageNum * limit,
                      avatarUrl: "https://example.com/avatar\(index).png",
                      htmlUrl: "https://github.com/user\(index + pageNum * limit)",
                      followersUrl: "https://api.github.com/users/user\(index + pageNum * limit)/followers",
                      followingUrl: "https://api.github.com/users/user\(index + pageNum * limit)/following",
                      reposUrl: "https://api.github.com/users/user\(index + pageNum * limit)/repos",
                      type: "User",
                      siteAdmin: false
                  )
              }

              return Just(users)
                  .setFailureType(to: Error.self)
                  .eraseToAnyPublisher()
    }
    

}
