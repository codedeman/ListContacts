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
    private var mockPersistence: MockUserPersistence!

    var loadTrigger: PassthroughSubject<Void, Never>!
    var selectedTrigger: PassthroughSubject<String, Never>!
    var loadMoreTrigger: PassthroughSubject<Void, Never>!
    var cancelBag: CancelBag!


    override func setUpWithError() throws {
        try super.setUpWithError()
        mockPersistence = MockUserPersistence()
        useCases = MockUseCases(storage: mockPersistence)
        sut = UserViewModel(useCases: useCases)
        cancelBag = CancelBag()

        loadTrigger = PassthroughSubject<Void, Never>()
        selectedTrigger = PassthroughSubject<String, Never>()
        loadMoreTrigger = PassthroughSubject<Void, Never>()
    }

    override func tearDown() {
        cancelBag = nil
        sut = nil
        loadTrigger = nil
        selectedTrigger = nil
        loadMoreTrigger = nil
        super.tearDown()
    }
    func testFetchUsers() {
        // Given
        let expectation = self.expectation(description: "Fetch users")

        let input = UserViewModel.Input(
            loadTrigger: loadTrigger.eraseToAnyPublisher(),
            selectedTrigger: selectedTrigger.eraseToAnyPublisher(),
            loadMoreTrigger: loadMoreTrigger.eraseToAnyPublisher()
        )

        let output = sut.transform(
            input: input,
            cancelBag: cancelBag
        )

        loadTrigger.send(())

        // Assert
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(output.users.count, 20, "The users should be loaded successfully")
            XCTAssertEqual(output.users.first?.login, "user20", "The users should be loaded successfully")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)

    }

    func testLoadMoreUsersIfNeeded() {
        // Create an expectation
        let expectation = XCTestExpectation(description: "Load more users")

        let input = UserViewModel.Input(
            loadTrigger: loadTrigger.eraseToAnyPublisher(),
            selectedTrigger: selectedTrigger.eraseToAnyPublisher(),
            loadMoreTrigger: loadMoreTrigger.eraseToAnyPublisher()
        )

        let output = sut.transform(input: input, cancelBag: cancelBag)
        // Act: Load initial users
        loadTrigger.send(())
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Load more users
            //                   self.mockUseCases.fetchUsersResult = .success(moreUsers)
            self.loadMoreTrigger.send(())
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertEqual(output.users.count, 40 , "All users should be loaded successfully")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)

       }

}
