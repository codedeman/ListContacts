
//
//  LoginView.swift
//  ListContacts
//
//  Created by Kevin on 10/16/24.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct LoginViewView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
