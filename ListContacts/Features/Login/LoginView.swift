
//
//  LoginView.swift
//  ListContacts
//
//  Created by Kevin on 10/12/24.
//

import SwiftUI

struct LoginViewView: View {
    @StateObject private var viewModel: LoginViewModel
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }

    init(viewModel: LoginViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginViewView(viewModel: .init())
    }
}


