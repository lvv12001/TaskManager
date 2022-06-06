//
//  ToDoCell.swift
//  TaskManager
//
//  Created by Viatcheslav Lebedev on 31.05.2022.
//

import SwiftUI

struct ToDoCell: View {
    
    var todo: ToDo
    
    var taskColor: Color {
        switch todo.status {
        case "Новая":
            return Color.green
        case "В работе":
            return Color.orange
        case "Выполнена":
            return Color.gray
        default:
            return Color.black
        }
    }
    
    
    
    var body: some View {
        HStack{
            Circle()
                .frame(width: 20, height: 20)
                .foregroundColor(taskColor)
            
            Text(todo.title)
            Spacer()
            Text(Helper.dateToString(date: todo.deadline))
        }
        .padding()
        
        
    }
    
}

struct ToDoCell_Previews: PreviewProvider {
    static var previews: some View {
        ToDoCell(todo: ToDo(title: "New task", desription: "Description...", deadline: Date(), category:.importantUrgant))
    }
}
