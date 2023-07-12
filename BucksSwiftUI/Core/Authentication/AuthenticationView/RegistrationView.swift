//
//  RegistrationView.swift
//  BucksSwiftUI
//
//  Created by Claudia Danciu on 07/07/2023.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var fullName = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack {
            
            // image
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 120)
                .padding(.vertical, 32)
            
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
                    text: $fullName,
                    title: "Full Name",
                    placeholder: "Jordan Doe"
                )
                .autocapitalization(.none)
                // the secured filed is already default to false
                
                InputView(
                    text: $password,
                    title: "Password",
                    placeholder: "Enter password",
                    isSecureField: true
                )
                
                ZStack(alignment: .trailing) {
                    InputView(
                        text: $confirmPassword,
                        title: "Confirm Password",
                        placeholder: "Confirm password",
                        isSecureField: true
                    )
                    if !password.isEmpty && !confirmPassword.isEmpty {
                        if password == confirmPassword {
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemGreen))
                        } else {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemRed))
                        }
                    }
                }
                // the secured filed is already default to false
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            Button {
                Task {
                    try await viewModel.createUser(
                        withEmail: email,
                        password: password,
                        fullName: fullName
                    )
                }
            } label: {
                HStack {
                    Text("SIGN UP")
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
            
            Button {
                dismiss()
            } label: {
                HStack(spacing: 3) {
                    Text("Already have an account?")
                    Text("Sign in")
                        .bold()

                }
                .font(.system(size: 14))
            }
        }
    }
}

// MARK: - AuthenticationFormProtocol

extension RegistrationView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
        && confirmPassword == password
        && !fullName.isEmpty
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
