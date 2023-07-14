//
//  User.swift
//  BucksSwiftUI
//
//  Created by Claudia Danciu on 10/07/2023.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String // Unique identifier for the user
    let fullName: String // Full name of the user
    let email: String // Email address of the user
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter() // Create an instance of PersonNameComponentsFormatter
        if let components = formatter.personNameComponents(from: fullName) {
            formatter.style = .abbreviated // Set the formatter style to abbreviated
            return formatter.string(from: components) // Get the initials using the formatter
        }
        return "" // Return an empty string if the formatter fails
    }
}

extension User {
    static var MOCK_USER = User( // Define a static property MOCK_USER as a mock user for testing purposes
        id: NSUUID().uuidString, // Generate a unique ID for the mock user
        fullName: "Claudia Danciu", // Set the full name of the mock user
        email: "contact@claudiadanciu.com" // Set the email address of the mock user
    )
}
