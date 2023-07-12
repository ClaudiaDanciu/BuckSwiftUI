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
    
    @Binding var selectedTab: Tabs
    @State private var isAddButtonTapped = false
    @State private var showHomeView = false 
    
    var body: some View {
        HStack(alignment: .center) {
            Button {
                // Switch to chats home
                selectedTab = .homeTab
            } label: {
                GeometryReader { geo in
                    if selectedTab == .homeTab {
                        Rectangle()
                            .foregroundColor(.blue)
                            .frame(width: geo.size.width/2, height: 4)
                            .padding(.leading, geo.size.width/4)
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
            .tint(selectedTab == .homeTab ? .blue : .gray)
            
            Button {
                isAddButtonTapped = true
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
            .tint(Color(.systemBlue))
            
            Button {
                // Switch to chats profile
                selectedTab = .profileTab
            } label: {
                GeometryReader { geo in
                    if selectedTab == .profileTab {
                        Rectangle()
                            .foregroundColor(.blue)
                            .frame(width: geo.size.width/2, height: 4)
                            .padding(.leading, geo.size.width/4)
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
            .tint(selectedTab == .profileTab ? .blue : .gray)
        }
        .frame(height: 82)
        .sheet(isPresented: $isAddButtonTapped) {
            NavigationView {
                ToDoListView()
            }
        }        
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView(selectedTab: .constant(.profileTab))
    }
}
