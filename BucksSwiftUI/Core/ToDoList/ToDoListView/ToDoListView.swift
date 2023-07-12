//
//  ToDoList.swift
//  BucksSwiftUI
//
//  Created by Claudia Danciu on 12/07/2023.
//

import SwiftUI

struct ToDoItem: Identifiable, Codable {
    var id: String?
    var title: String
    var person: String
}

struct ToDoListView: View {
    @State private var items: [ToDoItem] = []
    @State private var newItemTitle = ""
    @State private var selectedPerson = ""
    
    private let people = ["Person 1", "Person 2", "Person 3"]
    
    @Environment(\.presentationMode) private var presentationMode
    
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
        .onAppear {
            fetchTasks()
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
        
        Task {
            do {
                try await FirestoreManager.shared.addTask(newTask)
                await fetchTasks()
                newItemTitle = ""
                selectedPerson = ""
            } catch {
                print("Failed to add task: \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchTasks() {
        FirestoreManager.shared.fetchTasks { [self] (tasks, error) in
            if let error = error {
                print("Failed to fetch tasks: \(error.localizedDescription)")
                return
            }
            
            guard let tasks = tasks else { return }
            
            DispatchQueue.main.async {
                self.items = tasks
            }
        }
    }
}

