//
//  ListContactsApp.swift
//  ListContacts
//
//  Created by Kevin on 8/2/24.
//

import SwiftUI

@main
struct ListContactsApp: App {
    var body: some Scene {
        WindowGroup {
            UserListView(
                viewModel: .init(
                    useCases: DBUseCases(netWork: DBNetWorkLayer())
                )
            )
        }
    }
}
