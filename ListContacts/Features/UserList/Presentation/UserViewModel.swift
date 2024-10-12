
import Foundation
import Combine

struct IdentifiableError: Identifiable {
    var id = UUID()
    var message: String
}

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    func transform(input: Input, cancelBag: CancelBag) -> Output
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
            .flatMap {  _ in
                self.useCases.fetchUsers(pageNum: self.pageNum, limit: 20)
                    .map { users in
                        return users
                    }
                    .replaceError(with: []) // Handle error by returning an empty array
            }.eraseToAnyPublisher()

        let userInforPublisher = input.selectedTrigger
            .flatMap { username in
                self.useCases.fetchInforUser(userName: username).map { users in
                    return users
                }.replaceError(with: nil)
            }.eraseToAnyPublisher()

        // Load More Users Publisher
        let loadMoreUsersPublisher = input.loadMoreTrigger
            .flatMap { _ in
                self.pageNum += 1 // Increment the page number for loading more
                return self.useCases.fetchUsers(pageNum: self.pageNum, limit: 20)
                    .map { users in
                        return users
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
            .receive(on: RunLoop.main) // Ensure this happens on the main thread
            .assign(to: \.userInfor, on: output)
            .store(in: cancelBag)

        usersPublisher
            .receive(on: RunLoop.main) // Ensure this happens on the main thread
            .assign(to: \.users, on: output)
            .store(in: cancelBag)
        return output

    }


}
