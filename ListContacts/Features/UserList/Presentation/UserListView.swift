
import Combine
import SwiftUI

struct UserListView: View {
    @StateObject private var viewModel: UserViewModel
    @State private var selectedUser: User?
    @State private var isNavigating: Bool = false
    @State private var users: [User] = [] // Keep it @State for an array
    @StateObject var cancelBag: CancelBag
    @StateObject var output: UserViewModel.Output

    @StateObject private var triggers = Triggers()

    init(viewModel: UserViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        let triggers = Triggers()
        let input = UserViewModel.Input(
            loadTrigger: triggers.load.eraseToAnyPublisher(),
            selectedTrigger: triggers.selectedTrigger.eraseToAnyPublisher(), loadMoreTrigger: triggers.loadMoreTrigger.eraseToAnyPublisher()
        )
        let cancelBag = CancelBag()

        // Store the transformed output in a temporary variable

        // Now assign to the output state object
        self._triggers = StateObject(wrappedValue: triggers)
        self._cancelBag = StateObject(wrappedValue: cancelBag)
        let transformedOutput = viewModel.transform(input: input, cancelBag: cancelBag)
        self._output = StateObject(wrappedValue: transformedOutput)
        triggers.load.send(())
    }

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                List {
                    ForEach(output.users, id: \.id) { user in
                        VStack(spacing: 0) {
                            UserRowView(
                                user: user,
                                width: geometry.size.width - 32
                            )
                            .contentShape(Rectangle()) // Makes the whole row tappable
                            .onTapGesture {
                                triggers.selectedTrigger.send(user.login)
                            }
                            .padding(.vertical, 8) // Add vertical padding for spacing between items
                            .listRowInsets(EdgeInsets())
                            .onAppear {
                                // Check if this is the last user, and if so, trigger loading more
                                if user == output.users.last {
                                    triggers.loadMoreTrigger.send(()) // Trigger load more
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
                }.onAppear(perform: {
                    triggers.load.send(())
                })
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
                        destination: UserDetailsView(user: output.userInfor),
                        isActive: $isNavigating // Use state to trigger navigation
                    ) {
                        EmptyView()
                    }
                )
                .onChange(of: output.userInfor) { newValue in
                    isNavigating = newValue != nil
                }
            }
        }
    }

    final class Triggers: ObservableObject {
        var load = PassthroughSubject<Void, Never>()
        var selectedTrigger = PassthroughSubject<String, Never>()
        var loadMoreTrigger = PassthroughSubject<Void, Never>()
    }
}
