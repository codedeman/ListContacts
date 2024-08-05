
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
        loadCachedUsers()
        setupBindings()
        fetchUsers(pageNum: pageNum)
    }

    func fetchUserInformation(userName: String) {
        print("user name \(userName)")

        useCases.fetchInforUser(userName: userName)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = IdentifiableError(message: error.localizedDescription)
                }
            } receiveValue: { [weak self] userInfor in
                self?.userInfor = userInfor
            }.store(in: &cancellables)
    }

    private func loadCachedUsers() {
        if let data = UserDefaults.standard.data(forKey: "cachedUsers") {
            if let cachedUsers = try? JSONDecoder().decode([User].self, from: data) {
                self.users = cachedUsers
            }
        }
    }

    private func cacheUsers() {
        if let data = try? JSONEncoder().encode(users) {
            UserDefaults.standard.set(data, forKey: "cachedUsers")
        }
    }

    func fetchUsers(pageNum: Int) {
        guard !isFetching else { return } // Avoid making multiple requests at the same time
        isFetching = true

        useCases.fetchUsers(pageNum: pageNum, limit: 20)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isFetching = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.error = IdentifiableError(message: error.localizedDescription)
                }
            }, receiveValue: { [weak self] newUsers in
                guard let self = self else { return }
                let currentUserIds = Set(self.users.map { $0.id })
                let filteredNewUsers = newUsers.filter { !currentUserIds.contains($0.id) }
                self.users.append(contentsOf: filteredNewUsers)
                self.cacheUsers()
            })
            .store(in: &cancellables)
    }

    func loadMoreUsersIfNeeded(currentUser user: User?) {
        guard let user = user else {
            fetchUsers(pageNum: pageNum)
            return
        }

        let thresholdIndex = users.index(users.endIndex, offsetBy: -5)
        if let userIndex = users.firstIndex(where: { $0.id == user.id }), userIndex >= thresholdIndex {
            print("Loading more users. Page number:", pageNum)
            pageNum += 1
            fetchUsers(pageNum: pageNum)
        }
    }



    private func setupBindings() {
        $pageNum
            .dropFirst()
            .sink { [weak self] newPageNum in
                self?.fetchUsers(pageNum: newPageNum)
            }
            .store(in: &cancellables)
    }
}
