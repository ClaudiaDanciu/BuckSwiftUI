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
    @State private var sortAscending: [Bool] = []

    var body: some View {
        NavigationView {
            List {
                ForEach(categories.indices, id: \.self) { index in
                    let category = categories[index]
                    Section(header: HStack {
                        Text(category.person)
                            .font(.headline)
                            .foregroundColor(.primary)
                            .padding(.leading, 8)
                        Spacer()
                        sortIcon(for: index)
                            .padding(.trailing, 8)
                    }) {
                        ForEach(sortedTasks(for: index)) { item in
                            TaskRowView(title: item.title)
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Home")
            .searchable(text: $searchText, prompt: "Search") // Add the searchable modifier
        }
        .navigationViewStyle(StackNavigationViewStyle())
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
            
            // Initialize sortAscending array with default value
            sortAscending = Array(repeating: true, count: categories.count)
        }
    }
    
    private func sortedTasks(for index: Int) -> [ToDoItem] {
        let category = categories[index]
        return category.tasks
            .filter { task in
                searchText.isEmpty || task.title.localizedStandardContains(searchText)
            }
            .sorted { (task1, task2) -> Bool in
                let title1 = task1.title ?? ""
                let title2 = task2.title ?? ""
                return sortAscending[index] ? title1 < title2 : title1 > title2
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
    }
}

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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
