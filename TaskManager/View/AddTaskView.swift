//
//  AddTaskView.swift
//  TaskManager
//
//  Created by Viatcheslav Lebedev on 01.06.2022.
//

import SwiftUI

struct AddTaskView: View {
    
    @StateObject var viewModel = AddTaskViewModel()
    @State private var isImportant = true
    @State private var isUrgent = true
    @State private var isShowAlert = false
    @State private var alertMsg = ""
    @Environment (\.dismiss) var dismiss
    @EnvironmentObject var mainScreenViewModel: MainScreenViewModel
    
    var category_str: String {
        switch isUrgent {
        case true:
            switch isImportant {
            case true:  return Category.importantUrgant.rawValue
            case false: return Category.urgent.rawValue
            }
        case false:
            switch isImportant {
            case true:  return Category.important.rawValue
            case false: return Category.noNo.rawValue
            }
        }
    }
    
    var body: some View {
        
        VStack {
            Text("Добавить задачу")
                .font(.title)
                .bold()
                .padding(.bottom,24)
            TextField("Название задачи",text: $viewModel.toDo.title)
                .font(.title3)
            DatePicker("Deadline", selection: $viewModel.toDo.deadline, in: Date()...)
            VStack{
                Toggle(isOn: $isImportant) { Text("Важная") }
                Toggle(isOn: $isUrgent) { Text("Срочная") }
                
            }
            TextField("Описание задачи",text: $viewModel.toDo.description)
            
            Button {
                //print("Сохранение задачи")
                viewModel.toDo.category = category_str
                
                DataBaseService.shared.setTask(viewModel.toDo) { result in
                    switch result {
                    case .success(let task):
                        print("Задача \(task.title) сохранена")
                        mainScreenViewModel.getToDos()
                        self.dismiss()
                    case .failure(let error):
                        alertMsg = error.localizedDescription
                        isShowAlert.toggle()
                    }
                }
                
                
                
            } label: {
                Text("Сохранить")
            }
            .padding()
            .padding(.horizontal, 28)
            .foregroundColor(.white)
            .background(.blue)
            .cornerRadius(12)
            .padding(.top, 24)
            
            
        }
        .padding()
        .alert(alertMsg, isPresented: $isShowAlert) { Text ("OK") }
    }
}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView()
    }
}
