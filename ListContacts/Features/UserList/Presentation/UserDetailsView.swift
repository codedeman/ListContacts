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
        VStack {
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
                    Text(user?.login ?? "")
                        .font(.title)

                    Text("Country information not available")
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
                    Text("\(user?.followers ?? 0)Followers")
                        .multilineTextAlignment(.center)
                }
                .padding()

                VStack {
                    Image(systemName: "person.3.fill")
                    Text("\(user?.following ?? 0)Following")
                        .multilineTextAlignment(.center)
                }
                .padding()
            }
            .padding(.top)

            Text("Blog")
                .font(.title2)
                .padding(.top)

            Text("Blog information not available")
                .foregroundColor(.blue)

            Spacer()
        }
        .padding()
        .navigationTitle("User Details")
    }
}
