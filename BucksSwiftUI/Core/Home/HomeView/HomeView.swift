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
    @State private var categories: [Category] = [] // Array to store categories of tasks
    @State private var searchText = "" // Text entered in the search bar
    @State private var sortAscending: [Bool] = [] // Array to track sort order for each category
    
    var filteredCategories: [Category] {
        if searchText.isEmpty {
            return categories
        } else {
            return categories.map { category in
                let filteredTasks = category.tasks.filter { task in
                    task.title.localizedStandardContains(searchText)
                }
                return Category(person: category.person, tasks: filteredTasks)
            }
        }
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(filteredCategories.indices, id: \.self) { categoryIndex in
                    let category = filteredCategories[categoryIndex]
                    Section(header: HStack {
                        Text(category.person)
                            .font(.headline)
                            .foregroundColor(.primary)
                            .padding(.leading, 8)
                        Spacer()
                        sortIcon(for: categoryIndex)
                            .padding(.trailing, 8)
                    }) {
                        ForEach(category.tasks.indices, id: \.self) { taskIndex in
                            TaskRowView(title: category.tasks[taskIndex].title)
                        }
                        .onDelete { indexSet in
                            deleteTasks(at: indexSet, in: categoryIndex)
                            sortTasks()
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Home")
            .searchable(text: $searchText, prompt: "Search") // Enable search functionality
            .toolbar {
                EditButton() // Add the EditButton to enable editing mode
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            fetchTasks() // Fetch tasks when the view appears
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
            
            // Initialize sortAscending array with default value
            sortAscending = Array(repeating: true, count: categories.count)
        }
    }
    
    private func sortedTasks(for index: Int) -> [ToDoItem] {
        let category = filteredCategories[index]
        let ascending = sortAscending[index]
        return category.tasks.sorted { task1, task2 in
            let title1 = task1.title ?? ""
            let title2 = task2.title ?? ""
            if ascending {
                return title1 < title2
            } else {
                return title1 > title2
            }
        }
    }


    private func sortIcon(for index: Int) -> some View {
        Image(systemName: sortIconName(for: index))
            .imageScale(.small)
            .foregroundColor(.primary)
            .onTapGesture {
                toggleSort(for: index)
            }
    }
    
    private func sortIconName(for index: Int) -> String {
        return sortAscending[index] ? "arrow.up" : "arrow.down"
    }
    
    private func toggleSort(for index: Int) {
        sortAscending[index].toggle()
        sortTasks()
    }

    private func sortTasks() {
        for index in categories.indices {
            categories[index].tasks = sortedTasks(for: index)
        }
    }

    
    private func deleteTasks(at indexSet: IndexSet, in categoryIndex: Int) {
        let category = filteredCategories[categoryIndex]
        let sortedIndexSet = indexSet.sorted()
        
        for index in sortedIndexSet {
            let task = category.tasks[index]
            
            categories[categoryIndex].tasks.removeAll(where: { $0.id == task.id })
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
