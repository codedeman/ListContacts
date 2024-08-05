//
//  UserListView.swift
//  UserProfile
//
//  Created by Kevin on 8/2/24.
//


import SwiftUI

struct UserListView: View {
    @StateObject private var viewModel: UserViewModel
    @State private var selectedUser: User?

    init(
        viewModel: UserViewModel = UserViewModel(
            useCases: DBUseCases()
        )
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                List(viewModel.users) { user in
                    VStack(spacing: 0) {
                        UserRowView(
                            user: user,
                            width: geometry.size.width - 32
                        )
                        .contentShape(Rectangle()) // Makes the whole row tappable
                        .onTapGesture {
                            selectedUser = user
                        }
                        .padding(.vertical, 8) // Add vertical padding for spacing between items
                        .listRowInsets(EdgeInsets())
                    }.listRowInsets(EdgeInsets())
                }
                .listStyle(PlainListStyle()) // Optional: to remove default list styling
                .navigationTitle("Github Users")
                .alert(item: $viewModel.error) { error in
                    Alert(
                        title: Text("Error"),
                        message: Text(error.message),
                        dismissButton: .default(Text("OK"))
                    )
                }
                .background(
                    NavigationLink(
                        destination: selectedUser.map { UserDetailsView(user: $0) },
                        isActive: Binding(
                            get: { selectedUser != nil },
                            set: { isActive in
                                if !isActive { selectedUser = nil }
                            }
                        )
                    ) {
                        EmptyView()
                    }
                )
            }
        }
    }
}




#Preview {
    UserListView()
}
