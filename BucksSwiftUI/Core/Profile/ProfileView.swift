//
//  ProfileView.swift
//  BucksSwiftUI
//
//  Created by Claudia Danciu on 10/07/2023.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        if let user = viewModel.currentUser {
            List {
                // User Profile Section
                Section {
                    HStack {
                        Text(user.initials)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 72, height: 72)
                            .background(Color(.systemGray))
                            .clipShape(Circle())
                        VStack (alignment: .leading, spacing: 4){
                            Text(user.fullName)
                                .fontWeight(.semibold)
                                .padding(.top, 4)
                                .font(.subheadline)
                            
                            Text(user.email)
                                .fontWeight(.semibold)
                                .accentColor(.gray)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                // General Section
                Section("General") {
                    HStack {
                        SettingsRowView(
                            imageName: "gear",
                            title: "Version",
                            tintColor: Color(.systemGray)
                        )
                        Spacer()
                        Text("1.0.0")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                
                // Account Section
                Section("Account") {
                    // Sign out button
                    Button {
                        viewModel.signOut()
                    } label: {
                        SettingsRowView(
                            imageName: "arrow.left.circle.fill",
                            title: "Sign Out",
                            tintColor: .red
                        )
                    }
                    
                    // Delete account button
                    Button {
                        print("Delete account...")
                    } label: {
                        SettingsRowView(
                            imageName: "xmark.circle.fill",
                            title: "Delete account",
                            tintColor: .red
                        )
                    }
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
