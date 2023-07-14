//
//  TaskRowView.swift
//  BucksSwiftUI
//
//  Created by Claudia Danciu on 14/07/2023.
//

import SwiftUI

struct TaskRowView: View {
    var title: String
    @State private var isSelected = false // Added state for radio button selection
    
    var body: some View {
        HStack {
            RadioButton(isSelected: $isSelected) // Added radio button
            Text(title)
                .font(.subheadline)
                .foregroundColor(isSelected ? .gray : .primary) // Cross the text if isSelected is true
                .padding(.leading, 8)
                .strikethrough(isSelected, color: .gray) // Add strikethrough if isSelected is true
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
    }
}

struct RadioButton: View {
    @Binding var isSelected: Bool

    var body: some View {
        Button(action: {
            isSelected.toggle()
        }) {
            Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                .foregroundColor(.blue)
                .imageScale(.large)
        }
    }
}

struct TaskRowView_Previews: PreviewProvider {
    static var previews: some View {
        TaskRowView(title: "here")
    }
}
