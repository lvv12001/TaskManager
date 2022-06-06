//
//  ContentView.swift
//  TaskManager
//
//  Created by Viatcheslav Lebedev on 31.05.2022.
//

import SwiftUI
import FirebaseAuth

struct MainScreenView: View {
    
    @StateObject var viewModel: MainScreenViewModel
    @State private var showAddTaskView = false
    @State private var showAuthView = false
    @State private var isShowAlert = false
    @State private var alertMsg = ""
    @State private var selectedUgrentImportant = false
    @State private var selectedImportant = false
    @State private var selectedUgrent = false
    @State private var selectedNoNo = false
    @State private var selectedStr = ""
    @State private var isSelected = false
    
    @Environment (\.dismiss) var dismis
    
    var body: some View {
        VStack{
            HStack {
                Button {
                    AuthService.shared.signOut()
                    if viewModel.isStart {
                        showAuthView.toggle()
                    } else {
                        dismis()
                    }
                    
                } label: {
                    Image(systemName: "arrowshape.turn.up.backward")
                        .resizable()
                        .frame(width: 30, height: 20)
                }
                Spacer()
                Button {
                    print("Add task")
                    showAddTaskView.toggle()
                } label: {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                
                
            }.padding()
            // buttons
            VStack(spacing:24) {
                HStack(spacing:24) {
                    CategoryCell(imageName: "hare", categoryTitle: "Важное\nсрочное", isSelected: selectedUgrentImportant)
                        .onTapGesture {
                            if !isSelected {
                                selectedStr = "Важное срочное"
                                selectedUgrentImportant = true
                                isSelected = true
                            } else if selectedUgrentImportant {
                                selectedStr = ""
                                selectedUgrentImportant = false
                                isSelected = false
                            }
                        }
                    CategoryCell(imageName: "tortoise", categoryTitle: "Важное не\nсрочное", isSelected: selectedUgrent)
                        .onTapGesture {
                            if !isSelected {
                                selectedStr = "Важное не срочное"
                                selectedUgrent = true
                                isSelected = true
                            } else if selectedUgrent {
                                selectedStr = ""
                                selectedUgrent = false
                                isSelected = false
                            }
                        }
                }
                HStack(spacing:24) {
                    CategoryCell(imageName: "logo.xbox", categoryTitle: "Не важное\nсрочное", isSelected: selectedImportant)
                        .onTapGesture {
                            if !isSelected {
                                selectedStr = "Не важное срочное"
                                selectedImportant = true
                                isSelected  = true
                            } else if selectedImportant {
                                selectedStr = ""
                                selectedImportant = false
                                isSelected = false
                            }
                        }
                    CategoryCell(imageName: "shippingbox", categoryTitle: "Не важное\nне срочное", isSelected: selectedNoNo)
                        .onTapGesture {
                            if !isSelected {
                                selectedStr = "Не важное не срочное"
                                selectedNoNo = true
                                isSelected = true
                            } else if selectedNoNo {
                                selectedStr = ""
                                selectedNoNo = false
                                isSelected = false
                            }
                        }
                }
            }.frame(maxHeight: .infinity)
            
            
            if isSelected {
                HStack {
                    Text ("Показаны задачи категории - \(selectedStr)").font(.footnote)
                    Spacer()
                    Button {
                        selectedUgrentImportant = false
                        selectedUgrent = false
                        selectedImportant = false
                        selectedNoNo = false
                        isSelected = false
                        selectedStr = ""
                    } label: {
                        Text("Сбросить")
                    }
                    
                }
                .padding()
                .shadow(radius: 4)
                .animation(Animation.easeOut(duration: 0.7),value: isSelected) // Slava ???
            }
            
            // tasks cells ...
            List{
                ForEach (viewModel.todos) { todo in
                    if (todo.category == selectedStr) || !isSelected {
                    //..... cell ......
                    ToDoCell(todo: todo)
                        .onTapGesture {
                            print("Обработка нажатия")
                        }
                    // delete
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button("Delete") {
                                print("Delete")
                                DataBaseService.shared.deleteTask(todo)//??? Slava
                                viewModel.getToDos()
                            }
                            .tint(.red)
                        }
                    
                    
                    // change status
                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                            
                            Button("New") {
                                print("New")
                                todo.status = ToDoStatus.new.rawValue
                                // save task...
                                DataBaseService.shared.setTask(todo) { result in
                                    switch result {
                                    case .success(let task):
                                        print("Задача \(task.title) сохранена")
                                        viewModel.getToDos()
                                    case .failure(let error):
                                        alertMsg = error.localizedDescription
                                        isShowAlert.toggle()
                                    }
                                }
                            }
                            .tint(.green)
                            
                            Button("In work") {
                                print("In work")
                                todo.status = ToDoStatus.inWork.rawValue
                                // save task...
                                DataBaseService.shared.setTask(todo) { result in
                                    switch result {
                                    case .success(let task):
                                        print("Задача \(task.title) сохранена")
                                        viewModel.getToDos()
                                    case .failure(let error):
                                        alertMsg = error.localizedDescription
                                        isShowAlert.toggle()
                                    }
                                }
                            }
                            .tint(.orange)
                            
                            Button("Completed") {
                                print("Completed")
                                todo.status = ToDoStatus.completed.rawValue
                                // save task...
                                DataBaseService.shared.setTask(todo) { result in
                                    switch result {
                                    case .success(let task):
                                        print("Задача \(task.title) сохранена")
                                        viewModel.getToDos()
                                    case .failure(let error):
                                        alertMsg = error.localizedDescription
                                        isShowAlert.toggle()
                                    }
                                }
                            }
                            .tint(.gray)
                        }
                    }
                }
            }
            .listStyle(.plain)
            .padding(8)
            
        }
        .padding()
        .sheet(isPresented: $showAddTaskView) {
            AddTaskView()
                .environmentObject(viewModel)
        }
        .fullScreenCover(isPresented: $showAuthView) {
            AuthView(viewModel: AuthViewModel())
        }
        .onAppear {
            viewModel.getToDos()
        }
        .alert(alertMsg, isPresented: $isShowAlert) {
            Text("OK")
        }
    }
}



//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainScreenView(viewModel: MainScreenViewModel(user: User(), isStart: true))
//    }
//}


