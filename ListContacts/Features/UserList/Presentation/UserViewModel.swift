
import Combine
import Foundation

struct IdentifiableError: Identifiable {
    var id = UUID()
    var message: String
}

final class UserViewModel: ObservableObject, ViewModelType {
    @Published var users: [User] = []
    @Published var pageNum: Int = 1
    private var useCases: UseCases
    @Published var error: IdentifiableError?
    @Published var isFetching = false

    init(useCases: UseCases) {
        self.useCases = useCases
        self.users = useCases.loadCachedUsers()
    }

    struct Input {
        let loadTrigger: AnyPublisher<Void, Never>
        let selectedTrigger: AnyPublisher<String, Never>
        let loadMoreTrigger: AnyPublisher<Void, Never> // Add load more trigger
    }

    final class Output: ObservableObject {
        @Published var users: [User] = []
        @Published var userInfor: UserInformation?
    }

    func transform(input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        let usersPublisher = input.loadTrigger
            .flatMap { [weak self] _ -> AnyPublisher<[User], Never> in
                guard let self = self else {
                    return Just([]).eraseToAnyPublisher() // Return an empty array if self is nil
                }

                return self.useCases.fetchUsers(pageNum: self.pageNum, limit: 20)
                    .map { users -> [User] in // Ensure it maps to [User]
                        users
                    }
                    .replaceError(with: [])
                    .eraseToAnyPublisher() // Simplify the type to AnyPublisher<[User], Never>
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()

        let userInforPublisher = input.selectedTrigger
            .flatMap { [weak self] username -> AnyPublisher<UserInformation?, Never> in
                guard let self = self else {
                    return Just(nil).eraseToAnyPublisher() // Return nil for optional UserInformation if self is nil
                }

                return self.useCases.fetchInforUser(userName: username)
                    .map { userInfo -> UserInformation? in
                        userInfo // Map non-optional UserInformation to an optional
                    }
                    .replaceError(with: nil) // In case of error, return nil
                    .eraseToAnyPublisher()
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()

        // Load More Users Publisher
        let loadMoreUsersPublisher = input.loadMoreTrigger
            .flatMap { _ in
                self.pageNum += 1 // Increment the page number for loading more
                return self.useCases.fetchUsers(pageNum: self.pageNum, limit: 20)
                    .map { users in
                        users
                    }
                    .replaceError(with: [])
            }
            .eraseToAnyPublisher()

        loadMoreUsersPublisher
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Load more completed successfully.")
                case .failure(let error):
                    print("Error loading more users: \(error)") // Handle error appropriately
                }
            }, receiveValue: { users in
                // Append all new users at once
                output.users.append(contentsOf: users)
            })
            .store(in: cancelBag) // Store subscription

        userInforPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.userInfor, on: output)
            .store(in: cancelBag)

        usersPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.users, on: output)
            .store(in: cancelBag)

        return output
    }
}
