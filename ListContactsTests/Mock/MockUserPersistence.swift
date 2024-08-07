//
//  MockUserPersistence.swift
//  ListContactsTests
//
//  Created by Kevin on 8/7/24.
//

import Foundation

class MockUserPersistence: UserPersistence {
    private var storage: [String: Data] = [:]
    init() {
    }


    func loadCachedItems<T: Codable>(forKey key: String) -> [T] {
        guard let data = storage[key],
              let cachedItems = try? JSONDecoder().decode([T].self, from: data) else {
            return []
        }
        return cachedItems
    }

    func cacheItems<T: Codable>(_ items: [T], forKey key: String) {
        guard let data = try? JSONEncoder().encode(items) else { return }
        storage[key] = data
    }
}
