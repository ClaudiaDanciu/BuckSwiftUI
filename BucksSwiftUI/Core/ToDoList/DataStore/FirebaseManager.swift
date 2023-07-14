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
    static let shared = FirestoreManager()
    private let db = Firestore.firestore()
    private let collectionName = "todos"
    
    func addTask(_ task: ToDoItem) async throws {
        do {
            var addedTask = task
            addedTask.id = UUID().uuidString
            _ = try await db.collection(collectionName).addDocument(from: addedTask)
        } catch {
            throw error
        }
    }
    
    func deleteTask(_ task: ToDoItem) async throws {
        do {
            guard let documentID = task.id else { return }
            let documentRef = db.collection(collectionName).document(documentID)
            try await documentRef.delete()
        } catch {
            throw error
        }
    }
    
    func fetchTasks(completion: @escaping ([ToDoItem]?, Error?) -> Void) {
        if let currentUser = Auth.auth().currentUser {
            let userId = currentUser.uid

            db.collection(collectionName)
                .whereField("userId", isEqualTo: userId)
                .addSnapshotListener { (snapshot, error) in
                    if let error = error {
                        completion(nil, error)
                        return
                    }
                    
                    guard let snapshot = snapshot else {
                        completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Snapshot is nil"]))
                        return
                    }
                    
                    var tasks: [ToDoItem] = []
                    
                    for document in snapshot.documents {
                        if let task = try? document.data(as: ToDoItem.self) {
                            tasks.append(task)
                        }
                    }
                    
                    completion(tasks, nil)
                }
        } else {
            completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not logged in"]))
        }
    }
}
