//
//  DataBaseService.swift
//  TaskManager
//
//  Created by Viatcheslav Lebedev on 03.06.2022.
//

import FirebaseFirestore
import Firebase

class DataBaseService {
    
    static let shared = DataBaseService()
    private let db = Firestore.firestore()
    
    private var usersReference: CollectionReference {
        return db.collection("users")
    }
    
    private init () {}
    
    // add task -------------
    func setTask(_ task: ToDo, completion: @escaping (Result<ToDo, Error>) -> ()) {
        
        var taskRepresentation: [String: Any] {
            var repres = [String: Any]()
            repres["id"] = task.id
            repres["title"] = task.title
            repres["description"] = task.description
            repres["status"] = task.status
            repres["deadline"] = Timestamp(date: task.deadline)
            repres["category"] = task.category
            return repres
        }
        
        usersReference.document(AuthService.shared.currentUser!.uid).collection("tasks").document(task.id).setData(taskRepresentation) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(task))
            }
        }
    }
    
    // get all tasks ------------
    func getTasks(by userID: String, completion: @escaping (Result<[ToDo], Error>) -> ()) {
        let tasksRef = usersReference.document(userID).collection("tasks")
        tasksRef.getDocuments { qSnap, error in
            
            var tasks = [ToDo]()
            
            if let qSnap = qSnap {
                for doc in qSnap.documents  {
                    if let task = ToDo(snap: doc) {
                        tasks.append(task)
                    }
                }
                completion(.success(tasks))
            } else if let error = error {
                completion(.failure(error))
            }
            
        }
    }
    

func deleteTask(_ task: ToDo) {
    usersReference.document(AuthService.shared.currentUser!.uid).collection("tasks").document(task.id).delete()
    }
    
}
