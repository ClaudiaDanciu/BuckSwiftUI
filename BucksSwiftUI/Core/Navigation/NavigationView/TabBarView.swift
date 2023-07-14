//
//  CustoTabBarView.swift
//  BucksSwiftUI
//
//  Created by Claudia Danciu on 12/07/2023.
//

import SwiftUI

enum Tabs: Int {
    case homeTab = 0
    case profileTab = 1
}

struct TabBarView: View {
    
    @Binding var selectedTab: Tabs // Bind the selected tab
    @State private var isAddButtonTapped = false // Track if the add button is tapped
    @State private var showHomeView = false // Track if the home view should be shown
    
    var body: some View {
        HStack(alignment: .center) {
            Button {
                selectedTab = .homeTab // Switch to home tab
            } label: {
                GeometryReader { geo in
                    if selectedTab == .homeTab {
                        Rectangle()
                            .foregroundColor(.blue)
                            .frame(width: geo.size.width/2, height: 4)
                            .padding(.leading, geo.size.width/4) // Highlight the selected tab
                    }
                    VStack (alignment: .center, spacing: 4) {
                        
                        Image(systemName: "house")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                        Text("Home")
                            .font(.system(size: 16))
                    }
                    .frame(width: geo.size.width, height: geo.size.height)
                }
            }
            .tint(selectedTab == .homeTab ? .blue : .gray) // Set the button tint color based on the selected tab
            
            Button {
                isAddButtonTapped = true // Set the flag to show the add button sheet
            } label: {
                VStack (alignment: .center, spacing: 4) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                    Text("Add")
                        .font(.system(size: 16))
                }
            }
            .tint(Color(.systemBlue)) // Set the button tint color
            
            Button {
                selectedTab = .profileTab // Switch to profile tab
            } label: {
                GeometryReader { geo in
                    if selectedTab == .profileTab {
                        Rectangle()
                            .foregroundColor(.blue)
                            .frame(width: geo.size.width/2, height: 4)
                            .padding(.leading, geo.size.width/4) // Highlight the selected tab
                    }
                    VStack (alignment: .center, spacing: 4) {
                        Image(systemName: "person")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                        Text("Profile")
                            .font(.system(size: 16))
                    }
                    .frame(width: geo.size.width, height: geo.size.height)
                }
            }
            .tint(selectedTab == .profileTab ? .blue : .gray) // Set the button tint color based on the selected tab
        }
        .frame(height: 82)
        .sheet(isPresented: $isAddButtonTapped) {
            NavigationView {
                ToDoListView() // Present the ToDoListView in a sheet when add button is tapped
            }
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView(selectedTab: .constant(.profileTab)) // Preview with a selected tab
    }
}
