//
//  HomeView.swift
//  BucksSwiftUI
//
//  Created by Claudia Danciu on 12/07/2023.
//

import SwiftUI

struct Category: Identifiable {
    let id = UUID()
    let person: String
    var tasks: [ToDoItem]
}


struct HomeView: View {
    @State private var categories: [Category] = []
    
    var body: some View {
        NavigationView {
            List {
                ForEach(categories) { category in
                    Section(header: Text(category.person)) {
                        ForEach(category.tasks) { item in
                            Text(item.title)
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle("Home")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .edgesIgnoringSafeArea(.bottom) // Extend the content to the bottom edge
        .onAppear {
            fetchTasks()
        }
    }
    
    private func fetchTasks() {
        FirestoreManager.shared.fetchTasks { [self] (tasks, error) in
            if let error = error {
                print("Failed to fetch tasks: \(error.localizedDescription)")
                return
            }
            
            guard let tasks = tasks else { return }
            
            // Group tasks by person
            let groupedTasks = Dictionary(grouping: tasks, by: { $0.person })
            
            // Create categories with tasks for each person
            categories = groupedTasks.map { person, tasks in
                Category(person: person, tasks: tasks)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
