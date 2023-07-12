//
//  ContentView.swift
//  BucksSwiftUI
//
//  Created by Claudia Danciu on 07/07/2023.
//

import SwiftUI


struct RootView: View {
    @State var selectedTab: Tabs = .profileTab

    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        Group {
            if viewModel.userSession != nil {
                if selectedTab == .profileTab {
                    ProfileView()
                }
                VStack {
                    Spacer()
                    TabBarView(selectedTab: $selectedTab)
                }
            } else {
                LoginView()
            }
            
        }
    }
}



struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
