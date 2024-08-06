//
//  UserDetailsView.swift
//  UserProfile
//
//  Created by Kevin on 8/2/24.
//

import Foundation
import SwiftUI

struct UserDetailsView: View {
    let user: UserInformation?

    var body: some View {
        VStack(spacing: 16) {
            if let user = user {
                HStack {
                    // Profile Picture
                    AsyncImage(url: URL(string: user.avatarUrl ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                    } placeholder: {
                        ProgressView()
                            .frame(width: 70, height: 70)
                    }
                    .padding()

                    // User Details
                    VStack(alignment: .leading, spacing: 8) {
                        Text(user.name ?? "")
                            .font(.title)
                            .fontWeight(.bold)

                        Text(user.location ?? "")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }

                    Spacer()
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 5, x: 0, y: 2)

                // Statistics
                HStack {
                    VStack {
                        Image(systemName: "person.2.fill")
                        Text("\(user.followers ?? 0)+\nFollowers")
                            .multilineTextAlignment(.center)
                    }
                    .padding()

                    VStack {
                        Image(systemName: "person.3.fill")
                        Text("\(user.following ?? 0)+\nFollowing")
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                }

                // Blog Section
                VStack(alignment: .leading, spacing: 8) {  // Added spacing to ensure proper gap
                    Text("Blog")
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .leading)  // Ensure alignment

                    if let blog = user.blog, !blog.isEmpty {
                        Text(blog)
                            .foregroundColor(.blue)
                            .onTapGesture {
                                if let url = URL(string: blog) {
                                    UIApplication.shared.open(url)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)  // Ensure alignment
                    } else {
                        Text("Blog information not available")
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)  // Ensure alignment
                    }
                }
                .padding(.leading, 0)  // Added padding for consistency
                .padding(.top)
            } else {
                Text("User information not available")
                    .font(.title)
                    .padding()
            }

            Spacer()
        }
        .padding()
        .navigationTitle("User Details")
        .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
    }
}


let userInformation = UserInformationBuilder()
    .setLogin("Kevin")
    .setAvatarUrl("https://i.pinimg.com/736x/4b/46/8b/4b468b23f6641bf29719562ec48c2ec7.jpg")
    .setName("Kevin")
    .setId(123)
    .setNodeId("node123")
    .build()

#Preview {
    UserDetailsView(user: userInformation)
}
