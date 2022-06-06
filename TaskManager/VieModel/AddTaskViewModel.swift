//
//  AddTaskViewModel.swift
//  TaskManager
//
//  Created by Viatcheslav Lebedev on 01.06.2022.
//

import Foundation

class AddTaskViewModel: ObservableObject {
    
    @Published var toDo = ToDo(title: "",
                               desription: "",
                               deadline: Date(),
                               category: Category.importantUrgant)
}
