
import SwiftUI
struct UserListView: View {
    @StateObject private var viewModel: UserViewModel
    @State private var selectedUser: User?
    @State private var isNavigating: Bool = false

    init(viewModel: UserViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                List {
                    ForEach(viewModel.users) { user in
                        VStack(spacing: 0) {
                            UserRowView(
                                user: user,
                                width: geometry.size.width - 32
                            )
                            .contentShape(Rectangle()) // Makes the whole row tappable
                            .onTapGesture {
                                viewModel.fetchUserInformation(userName: user.login)
                            }
                            .padding(.vertical, 8) // Add vertical padding for spacing between items
                            .listRowInsets(EdgeInsets())
                            .onAppear {
                                if user == viewModel.users.last && !viewModel.isFetching {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        viewModel.loadMoreUsersIfNeeded(currentUser: user)
                                    }
                                }
                            }
                        }
                        .listRowInsets(EdgeInsets()) // Remove default list row insets
                    }

                    if viewModel.isFetching {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                        .padding(.vertical, 16) // add some vertical padding
                    }
                }
                .listStyle(PlainListStyle()) // to remove default list styling
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
                        destination: UserDetailsView(user: viewModel.userInfor),
                        isActive: $isNavigating // Use state to trigger navigation
                    ) {
                        EmptyView()
                    }
                )
                .onChange(of: viewModel.userInfor) { newValue in
                    isNavigating = newValue != nil
                }
            }
        }
    }
}
