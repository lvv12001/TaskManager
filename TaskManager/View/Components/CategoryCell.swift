//
//  CategoryCell.swift
//  TaskManager
//
//  Created by Viatcheslav Lebedev on 31.05.2022.
//

import SwiftUI

struct CategoryCell: View {
    
    var imageName : String
    var categoryTitle: String
    var isSelected: Bool
    
    var body: some View {
        VStack {
            Image(systemName: imageName)
                .resizable()
                .frame(width:100,height: 90)
            Text (categoryTitle)
                .multilineTextAlignment(.center)
        }.frame(width: Helper.screen.width/3.0, height: Helper.screen.width/2.8)
            .padding()
            .background(!isSelected ? Color(.white) : Color("ligthBlue"))
            .cornerRadius(24)
            .shadow(radius: 4)
    }
}

struct CategoryCell_Previews: PreviewProvider {
    static var previews: some View {
        CategoryCell(imageName: "hare", categoryTitle: "Важное\nсрочное", isSelected: false)
    }
}
