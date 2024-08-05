//
//  URLManager.swift
//  UserProfile
//
//  Created by Kevin on 8/2/24.
//

import Foundation

class URLManager {
    private let baseURL: String

    init(baseURL: String = "https://api.github.com") {
        self.baseURL = baseURL
    }

    func usersURL(
        pageNum: Int,
        perPage: Int = 20
    ) -> URLRequest? {

        let urlString = "\(baseURL)/users?per_page=\(perPage)&since=\(pageNum)"
        guard let url = URL(string: urlString) else { return nil }
        return URLRequest(url: url)

    }

    func userInformationURL(userName: String) throws -> URLRequest? {
        let urlString = "\(baseURL)/users/\(userName)"
        guard let url = URL(string: urlString) else { return nil }
        return URLRequest(url: url)
    }

    func urlRequest(for url: URL) -> URLRequest {
        return URLRequest(url: url)
    }
}
