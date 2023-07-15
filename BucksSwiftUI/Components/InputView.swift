//
//  InputView.swift
//  BucksSwiftUI
//
//  Created by Claudia Danciu on 07/07/2023.
//

import SwiftUI

struct InputView: View {
    @Binding var text: String // Binding to the text entered in the input field
    let title: String // The title of the input field
    let placeholder: String // The placeholder text for the input field
    var isSecureField = false // Flag to determine if the input field should be secure (password)
 
    // This is a reusable input component used for text fields
    var body: some View {
        VStack(alignment: .leading, spacing: 12) { // Vertical stack to hold the input components
            Text(title) // Display the title of the input field
                .foregroundColor(Color(.darkGray)) // Set the text color to dark gray
                .fontWeight(.semibold) // Set the font weight to semibold
                .font(.footnote) // Set the font size to footnote
            
            if isSecureField {
                SecureField(
                    placeholder,
                    text: $text
                )
                .font(.system(size: 14)) // Set the font size to 14 for secure input field
            }
            else {
                TextField(
                    placeholder,
                    text: $text
                )
                .font(.system(size: 14)) // Set the font size to 14 for regular input field
            }
            Divider() // Add a divider line below the input field
        }
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView(
            text: .constant(""), // Initialize the binding to an empty string
            title: "Email Address", // Set the title of the input field
            placeholder: "user@example.co.uk" // Set the placeholder text for the input field
        )
    }
}
