//
//  MockUseCases.swift
//  ListContactsTests
//
//  Created by Kevin on 8/4/24.
//

import Foundation
import Combine

final class MockUseCases: UseCases {

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
