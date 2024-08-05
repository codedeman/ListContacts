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
        VStack() {
            HStack {
                AsyncImage(url: URL(string: user?.avatarUrl ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                }
                .padding()

                VStack(alignment: .leading) {
                    Text(user?.name ?? "")
                        .font(.title)
                    Divider()
                    Text(user?.location ?? "")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Spacer()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: .gray, radius: 5, x: 0, y: 2)
                HStack {
                    VStack {
                        Image(systemName: "person.2.fill")
                        Text("\(user?.followers ?? 0)+ \n Followers")
                            .multilineTextAlignment(.center)
                    }
                    .padding()

                    VStack {
                        Image(systemName: "person.3.fill")
                        Text("\(user?.following ?? 0)+\n Following")
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                }
                .padding(.top)
            // Blog Section
            VStack(alignment: .leading) {
                Text("Blog")
                    .font(.title2)
                    .padding(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading) // Ensure alignment

                if let blog = user?.blog, !blog.isEmpty {
                    Text(blog)
                        .foregroundColor(.blue)
                        .onTapGesture {
                            if let url = URL(string: blog) {
                                UIApplication.shared.open(url)
                            }
                        }
                } else {
                    Text("Blog information not available")
                        .foregroundColor(.gray)
                }
            }
            .padding(.top)


            Spacer()
        }
        .padding()
        .navigationTitle("User Details")
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
