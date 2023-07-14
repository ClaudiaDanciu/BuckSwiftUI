//
//  FirebaseManager.swift
//  BucksSwiftUI
//
//  Created by Claudia Danciu on 12/07/2023.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class FirestoreManager {
    static let shared = FirestoreManager() // Singleton instance of FirestoreManager
    
    private let db = Firestore.firestore() // Firestore instance
    private let collectionName = "todos" // Collection name for tasks
    
    // Add a task to Firestore
    func addTask(_ task: ToDoItem) async throws {
        do {
            var addedTask = task
            addedTask.id = UUID().uuidString // Generate a unique ID for the task
            _ = try await db.collection(collectionName).addDocument(from: addedTask) // Add the task document to the collection
        } catch {
            throw error
        }
    }
    
    // Delete a task from Firestore
    func deleteTask(_ task: ToDoItem) async throws {
        do {
            guard let documentID = task.id else { return }
            let documentRef = db.collection(collectionName).document(documentID) // Reference to the task document
            try await documentRef.delete() // Delete the task document
        } catch {
            throw error
        }
    }
    
    // Fetch tasks for the current user from Firestore
    func fetchTasks(completion: @escaping ([ToDoItem]?, Error?) -> Void) {
        if let currentUser = Auth.auth().currentUser { // Check if a user is logged in
            let userId = currentUser.uid // Get the user ID
            
            // Fetch tasks for the user based on the user ID
            db.collection(collectionName)
                .whereField("userId", isEqualTo: userId)
                .addSnapshotListener { (snapshot, error) in
                    if let error = error {
                        completion(nil, error) // Return the error if there is any
                        return
                    }
                    
                    guard let snapshot = snapshot else {
                        completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Snapshot is nil"])) // Return an error if the snapshot is nil
                        return
                    }
                    
                    var tasks: [ToDoItem] = []
                    
                    for document in snapshot.documents {
                        if let task = try? document.data(as: ToDoItem.self) { // Convert the document data to ToDoItem object
                            tasks.append(task) // Add the task to the array
                        }
                    }
                    
                    completion(tasks, nil) // Return the tasks array
                }
        } else {
            completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])) // Return an error if the user is not logged in
        }
    }
}
