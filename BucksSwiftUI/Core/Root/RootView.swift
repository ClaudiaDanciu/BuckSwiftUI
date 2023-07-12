//
//  ContentView.swift
//  BucksSwiftUI
//
//  Created by Claudia Danciu on 07/07/2023.
//

import SwiftUI

struct RootView: View {
    @State var selectedTab: Tabs = .homeTab

    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 0) { // Use a VStack and set spacing to 0
            if viewModel.userSession != nil {
                if selectedTab == .profileTab {
                    ProfileView()
                }
                else if selectedTab == .homeTab{
                    HomeView()
                }
            } else {
                LoginView()
            }
            
            TabBarView(selectedTab: $selectedTab)
                .padding(.bottom, 12) // Add bottom padding to the TabBarView
        }
        .edgesIgnoringSafeArea(.bottom) // Extend the content to the bottom edge
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environmentObject(AuthViewModel())
    }
}
