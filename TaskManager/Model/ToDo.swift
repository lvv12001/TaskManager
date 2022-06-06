//
//  ToDo.swift
//  TaskManager
//
//  Created by Viatcheslav Lebedev on 31.05.2022.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore

enum Category: String {
    case importantUrgant = "Важное срочное"
    case important = "Важное не срочное"
    case urgent = "Не важное срочное"
    case noNo = "Не важное не срочное"
}

enum ToDoStatus: String {
    case new = "Новая"
    case inWork = "В работе"
    case completed = "Выполнена"
}

class ToDo: Identifiable {
    
    var id: String = UUID().uuidString
    var title: String = ""
    var description: String = ""
    var deadline: Date = Date()
    var category: String = Category.importantUrgant.rawValue
    var status: String = ToDoStatus.new.rawValue

    
    convenience init(title: String, desription: String, deadline: Date, category: Category) {
        self.init()
        self.title = title
        self.description = desription
        self.deadline = deadline
        self.category = category.rawValue
    }
    
    init () {}
    
    init? (snap: QueryDocumentSnapshot) {
        let data = snap.data()
        guard let id = data["id"] as? String else {return nil}
        guard let title = data["title"] as? String else {return nil}
        guard let description = data["description"] as? String else {return nil}
        guard let status = data["status"] as? String else {return nil}
        guard let category = data["category"] as? String else {return nil}
        guard let deadline = data["deadline"] as? Timestamp else {return nil}
       
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.status = status
        self.deadline = deadline.dateValue()
        
    }
    
}
