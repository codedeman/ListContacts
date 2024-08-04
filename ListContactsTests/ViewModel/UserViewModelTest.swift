//
//  UserViewModelTest.swift
//  ListContactsTests
//
//  Created by Kevin on 8/4/24.
//

import XCTest
import Combine
@testable import ListContacts

final class UserViewModelTest: XCTestCase {

    //MARK: property
    private var cancellables: Set<AnyCancellable> = []
    private var sut: UserViewModel!
    private var useCases: MockUseCases!

    override func setUpWithError() throws {
        try super.setUpWithError()
        UserDefaults.standard.removeObject(forKey: "cachedUsers")
        useCases = MockUseCases()
        sut = UserViewModel(useCases: useCases)
        cancellables = []
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
        useCases = nil
    }

    func testFetchUsers() {
            // Given
            let expectation = self.expectation(description: "Fetch users")

            // When
            sut.fetchUsers(pageNum: 0)

            // Then
        var subscription: AnyCancellable? = nil

        subscription =  sut.$users
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { users in
                XCTAssertEqual(users.count, 20)
                XCTAssertEqual(users.first?.login, "user20")
                expectation.fulfill()
                subscription?.cancel()
            }

            waitForExpectations(timeout: 5, handler: nil)
        }

    func testLoadMoreUsersIfNeeded() {
           // Create an expectation
           let expectation = XCTestExpectation(description: "Load more users")

           // Add initial users to the view model
        let initialUsers = (0..<15).map {
            User(
                login: "user\($0)",
                id: $0,
                avatarUrl: "",
                htmlUrl: "",
                followersUrl: "",
                followingUrl: "",
                reposUrl: "",
                type: "User",
                siteAdmin: false
            )
        }
           sut.users = initialUsers

           // Set up the mock use case to return new users
        let newUsers = (15..<35).map {
            User(
                login: "user\($0)",
                id: $0,
                avatarUrl: "",
                htmlUrl: "",
                followersUrl: "",
                followingUrl: "",
                reposUrl: "",
                type: "User",
                siteAdmin: false
            )
        }


           // Bind to the users property
           sut.$users
               .dropFirst() // Skip the initial state
               .sink { users in
                   if users.count == 35 {
                       XCTAssertEqual(users[20].login, "user20")
                       XCTAssertEqual(users.last?.login, "user34")
                       expectation.fulfill()
                   }
               }
               .store(in: &cancellables)
            sut.users.append(contentsOf: newUsers)

           // Call the method with a user that should trigger loading more users
            sut.loadMoreUsersIfNeeded(currentUser: initialUsers[10])

           // Wait for the expectation
            wait(for: [expectation], timeout: 5.0)
       }


}
