//  AuthViewModel.swift
//  BucksSwiftUI
//
//  Created by Claudia Danciu on 11/07/2023.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession : FirebaseAuth.User?
    @Published var currentUser: User?
    
    init() {
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
    
    func signIn(
        withEmail email: String,
        password: String
    ) async throws {
        do {
            let result = try await Auth.auth().signIn(
                withEmail: email,
                password: password
            )
            // sets the user session
            self.userSession = result.user
            // the user needs to be there so we can render the content
            // we need to signin the user and have the correct user info in order to render the content
            await fetchUser()
        } catch {
            print("Failed to login user with error \(error.localizedDescription)")
        }
    }
    
    func createUser(
        withEmail email: String,
        password: String,
        fullName: String
    ) async throws {
        do {
            let result = try await Auth.auth().createUser(
                withEmail: email,
                password: password
            )
            self.userSession = result.user
            let user = User(
                id: result.user.uid,
                fullName: fullName,
                email: email
            )
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            // fetch the date to be displayed properly
            await fetchUser()
        } catch {
            print("Debug: Failed to create user with error \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        do {
            // signs out user on backend
            try Auth.auth().signOut()
            // removes user session and return user to login screen
            self.userSession = nil
            // removes current user data model
            self.currentUser = nil
        } catch {
            print("Failed to sign out \(error.localizedDescription)")
        }
    }
    
    func deleteAccount() {
        
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
        
        print("Current user is \(String(describing: self.currentUser))")
    }
}
