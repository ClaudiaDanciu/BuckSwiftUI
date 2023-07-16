//
//  RootView.swift
//  BucksSwiftUI
//
//  Created by Claudia Danciu on 10/07/2023.
//

import SwiftUI

struct RootView: View {
    @State var selectedTab: Tabs = .homeTab

    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 0) { // Use a VStack and set spacing to 0
            if viewModel.userSession != nil {
                if selectedTab == .profileTab {
                    ProfileView() // Show the ProfileView if the profile tab is selected
                }
                else if selectedTab == .homeTab {
                    HomeView() // Show the HomeView if the home tab is selected
                }
                TabBarView(selectedTab: $selectedTab)
                    .padding(.bottom, 12) // Add bottom padding to the TabBarView
            } else {
                LoginView() // Show the LoginView if the user session is not available
            }
            
            
        }
        .edgesIgnoringSafeArea(.bottom) // Extend the content to the bottom edge, ignoring safe area
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environmentObject(AuthViewModel()) // Inject the AuthViewModel as an environment object
    }
}
