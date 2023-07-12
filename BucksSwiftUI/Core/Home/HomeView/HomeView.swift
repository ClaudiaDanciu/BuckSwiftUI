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
    @State private var searchText = ""
    @State private var sortAscending = true

    var body: some View {
        NavigationView {
            List {
                ForEach(categories) { category in
                    Section(header: HStack {
                        Text(category.person)
                        Spacer()
                        sortIcon(for: category)
                    }) {
                        ForEach(category.tasks.filter {
                            searchText.isEmpty || $0.title.localizedStandardContains(searchText)
                        }
                        .sorted {
                            sortAscending ? $0.title < $1.title : $0.title > $1.title
                        }) { item in
                            Text(item.title)
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle("Home")
            .searchable(text: $searchText, prompt: "Search") // Add the searchable modifier
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
    
    private func sortIcon(for category: Category) -> some View {
        Image(systemName: sortIconName(for: category))
            .imageScale(.small)
            .onTapGesture {
                toggleSort(for: category)
            }
    }
    
    private func sortIconName(for category: Category) -> String {
        return sortAscending ? "arrow.up" : "arrow.down"
    }
    
    private func toggleSort(for category: Category) {
        if let index = categories.firstIndex(where: { $0.id == category.id }) {
            categories[index].tasks.reverse()
            sortAscending.toggle()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
