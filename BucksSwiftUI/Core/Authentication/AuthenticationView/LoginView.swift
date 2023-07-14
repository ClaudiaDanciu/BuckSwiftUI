//
//  LoginView.swift
//  BucksSwiftUI
//
//  Created by Claudia Danciu on 07/07/2023.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                // image
                
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 240)
                    .padding(.vertical, 12)
                
                // form fields with reused components
                
                VStack(spacing: 24) {
                    InputView(
                        text: $email,
                        title: "Email Address",
                        placeholder: "user@example.co.uk"
                    )
                    .autocapitalization(.none)
                    // the secured filed is already default to false
                    
                    InputView(
                        text: $password,
                        title: "Password",
                        placeholder: "Enter your password",
                        isSecureField: true
                    )
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                // sign in button
                
                Button {
                    Task {
                        try await viewModel.signIn(
                            withEmail: email,
                            password: password
                        )
                    }
                } label: {
                    HStack {
                        Text("SIGN IN")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(
                        width: UIScreen.main.bounds.width - 24,
                        height: 44
                    )
                }
                .background(Color(.systemBlue))
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                .cornerRadius(10)
                .padding(.top, 24)
                
                Spacer()
                
                // signup button
                
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack(spacing: 3) {
                        Text("If you don't have an account")
                        Text("Sign up")
                            .bold()
                    }
                    .font(.system(size: 14))
                    .padding(.bottom, 24)
                }
            }
        }
    }
}

// MARK: - AuthenticationFormProtocol

extension LoginView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
            && email.contains("@")
            && !password.isEmpty
            && password.count > 5
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
