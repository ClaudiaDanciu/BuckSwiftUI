//
//  ToDoList.swift
//  BucksSwiftUI
//
//  Created by Claudia Danciu on 12/07/2023.
//

import SwiftUI

struct ToDoItem: Identifiable {
    let id = UUID()
    var title: String
    var person: String
}

struct ToDoListView: View {
    @State private var items: [ToDoItem] = []
    @State private var newItemTitle = ""
    @State private var selectedPerson = ""
    @Environment(\.presentationMode) private var presentationMode
    
    private let people = ["Person 1", "Person 2", "Person 3"]
    
    var body: some View {
        VStack {
            List {
                ForEach(items) { item in
                    HStack {
                        Text(item.title) // Display the item title
                        Spacer()
                        Text(item.person) // Display the assigned person
                    }
                }
                .onDelete(perform: deleteTask)
            }
            
            VStack {
                TextField("Task", text: $newItemTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Picker("Person", selection: $selectedPerson) {
                    ForEach(people, id: \.self) { person in
                        Text(person)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                Button(action: addTask) {
                    Text("Add Task")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding()
            }
        }
        .navigationBarTitle("To-Do List")
        .navigationBarItems(trailing: closeButton)
    }
    
    private var closeButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "xmark")
                .imageScale(.large)
                .padding()
        }
    }
    
    private func addTask() {
        guard !newItemTitle.isEmpty, !selectedPerson.isEmpty else { return }
        let newTask = ToDoItem(title: newItemTitle, person: selectedPerson)
        items.append(newTask)
        newItemTitle = ""
        selectedPerson = ""
    }
    
    private func deleteTask(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
}

struct ToDoListView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListView()
    }
}
