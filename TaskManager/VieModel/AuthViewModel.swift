//
//  AuthViewModel.swift
//  TaskManager
//
//  Created by Viatcheslav Lebedev on 02.06.2022.
//

import Foundation

class AuthViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirm: String = ""
    var mainScreenViewModel: MainScreenViewModel?
    
}
