//
//  MainScreenViewModel.swift
//  TaskManager
//
//  Created by Viatcheslav Lebedev on 01.06.2022.
//

import Foundation
import FirebaseAuth

class MainScreenViewModel: ObservableObject {
    
    @Published var user: User
    @Published var todos: [ToDo] = []
    
    var isStart: Bool
    
    init(user: User, isStart: Bool) {
        self.user = user
        self.isStart = isStart
    }
 
    func getToDos() {
        //guard (let curentUser= AuthService.shared.currentUser) else { return } // ???
        print ("get ToDos...")
        DataBaseService.shared.getTasks(by: AuthService.shared.currentUser!.uid) { result in
            switch result {
                
            case .success(let tasks):
                self.todos = tasks
                //for todo in self.todos {
                //    print(todo.title)
                //}
                print ("getToDo - success")
            case .failure(let error):
 //               alertMsg = error.localizedDescription
  //              isShowAlert.toggle()
                print ("getToDo - error")
                print (error.localizedDescription)
            }
        }
    }

    func filterToDos(filter: String) {
        var filteredToDos: [ToDo] = []
        
        for todo in todos {
            if todo.category == filter {
                filteredToDos.append(todo)
            }
        todos = filteredToDos
        }
        print ("Tasks filter: \(filter)")
    }

}

