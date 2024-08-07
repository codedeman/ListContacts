//
//  Storage.swift
//  ListContacts
//
//  Created by Kevin on 8/7/24.
//

import Foundation

protocol UserPersistence {
    func loadCachedItems<T: Codable>(forKey key: String) -> [T]
    func cacheItems<T: Codable>(_ items: [T], forKey key: String)
}

final class DBUserPersistence: UserPersistence {

    init () { }

    func loadCachedItems<T: Codable>(forKey key: String) -> [T] {
          guard let data = UserDefaults.standard.data(forKey: key),
                let cachedItems = try? JSONDecoder().decode([T].self, from: data) else {
              return []
          }
          return cachedItems
      }

      func cacheItems<T: Codable>(_ items: [T], forKey key: String) {
          guard let data = try? JSONEncoder().encode(items) else { return }
          UserDefaults.standard.set(data, forKey: key)
      }
}
