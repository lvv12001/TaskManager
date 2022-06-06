//
//  AuthService.swift
//  TaskManager
//
//  Created by Viatcheslav Lebedev on 03.06.2022.
//

import Foundation
import FirebaseAuth

class AuthService {
    
    static let shared = AuthService()
    private let auth = Auth.auth()
    
    var currentUser: User? { auth.currentUser }
    
    private init() {}
    
    func signUp(email: String,
                password: String,
                completion: @escaping (Result<User, Error>) -> Void) {
        
        auth.createUser(withEmail: email, password: password) { result, error in
            if let result = result {
                completion (.success(result.user))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    func signIn (email: String, password: String, completion: @escaping (Result<User, Error>) -> ()) {
        
        auth.signIn(withEmail: email, password: password) { result, error in
            if let result = result {
                completion(.success(result.user))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    func signOut() {
        try! auth.signOut()
    }
    
}
