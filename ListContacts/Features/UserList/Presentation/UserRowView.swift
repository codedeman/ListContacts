//
//  UserRowView.swift
//  UserProfile
//
//  Created by Kevin on 8/2/24.
//

import Foundation
import SwiftUI


struct UserRowView: View {

    let user: User
    let width: CGFloat // Accept width as a parameter

    var body: some View {
        HStack(alignment: .top) {
            AsyncImage(url: URL(string: user.avatarUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
            } placeholder: {
                Image("defaultAvatar")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
            }.padding(.leading)

            VStack(alignment: .leading) {
                Text(user.login)
                    .font(.headline)
                Divider() // Add the divider here
                Text(user.htmlUrl)
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }.padding(.horizontal)
            Spacer()
        }
        .frame(width: width, height: 150) // Set the frame width
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .gray, radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
}

