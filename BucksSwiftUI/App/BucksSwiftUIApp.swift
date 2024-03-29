//
//  BucksSwiftUIApp.swift
//  BucksSwiftUI
//
//  Created by Claudia Danciu on 07/07/2023.
//

import SwiftUI
import Firebase

@main
struct BucksSwiftUIApp: App {
    @StateObject var viewModel = AuthViewModel()
    
    init() {
        FirebaseApp.configure() // Initialize Firebase
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(viewModel) // Inject the authentication view model
        }
    }
}
