
import Foundation
import Combine

struct IdentifiableError: Identifiable {
    var id = UUID()
    var message: String
}

final class UserViewModel: ObservableObject {
    @Published var users: [User] = []
    private var cancellables = Set<AnyCancellable>()
    @Published var pageNum: Int = 1
    private var useCases: UseCases
    @Published var error: IdentifiableError?
    @Published var isFetching = false
    @Published var userInfor: UserInformation?

    init(useCases: UseCases) {
        self.useCases = useCases
        self.users = useCases.loadCachedUsers()
        fetchUsers(pageNum: pageNum)
    }

    func fetchUsers(pageNum: Int) {
        guard !isFetching else {
            print("Fetch already in progress")
            return
        } // Avoid making multiple requests at the same time
        isFetching = true
        print("Fetching users for page: \(pageNum)")

        useCases.fetchUsers(pageNum: pageNum, limit: 20)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isFetching = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.error = IdentifiableError(message: error.localizedDescription)
                    print("Error fetching users: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] newUsers in
                guard let self = self else { return }
                let currentUserIds = Set(self.users.map { $0.id }) // / Getting the IDs of current users
                let filteredNewUsers = newUsers.filter { !currentUserIds.contains($0.id) } // Filtering new users
                self.users.append(contentsOf: filteredNewUsers)
                print("Fetched \(filteredNewUsers.count) new users") // Appending new users to the users array
                self.useCases.cacheUsers(users) // Caching the updated users array
            })
            .store(in: &cancellables)
    }

    // Function to load more users if needed based on the current user's position
    func loadMoreUsersIfNeeded(currentUser user: User?) {
        guard let user = user else {
            fetchUsers(pageNum: pageNum) // Fetching users if currentUser is nil
            return
        }

        let thresholdIndex = users.index(users.endIndex, offsetBy: -5) // Setting the threshold index
        if let userIndex = users.firstIndex(where: { $0.id == user.id }), userIndex >= thresholdIndex {
            print("Current user index \(userIndex), threshold index \(thresholdIndex). Loading more users.")
            pageNum += 1 // Incrementing the page number
            fetchUsers(pageNum: pageNum)
        } else {
            print("Current user index \(users.firstIndex(where: { $0.id == user.id }) ?? -1), threshold index \(thresholdIndex). No need to load more users.", pageNum)
        }
    }

    // Function to fetch information for a specific user by username
    func fetchUserInformation(userName: String) {
        useCases.fetchInforUser(userName: userName)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = IdentifiableError(message: error.localizedDescription)
                    print("Error fetching user info: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] userInfor in
                self?.userInfor = userInfor
            }.store(in: &cancellables)
    }
}
