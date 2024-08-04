//
//  UserViewModel.swift
//  UserProfile
//
//  Created by Kevin on 8/2/24.
//

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

    struct Dependencies {
        let useCases: UseCases
    }

    init(useCases: UseCases) {
        self.useCases = useCases
        loadCachedUsers()
        setupBindings()
        fetchUsers(pageNum: pageNum)
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
        useCases.fetchUsers(pageNum: pageNum, limit: 20)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = IdentifiableError(message: error.localizedDescription)
                }
            }, receiveValue: { [weak self] newUsers in
                self?.users.append(contentsOf: newUsers)
                self?.cacheUsers()

            })
            .store(in: &cancellables)

    }

    func loadMoreUsersIfNeeded(currentUser user: User?) {
        guard let user = user else {
            fetchUsers(pageNum: pageNum)
            return
        }

        let thresholdIndex = users.index(users.endIndex, offsetBy: -5)
        if users.firstIndex(where: { $0.id == user.id }) == thresholdIndex {
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
