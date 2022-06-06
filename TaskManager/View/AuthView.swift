//
//  AuthView.swift
//  TaskManager
//
//  Created by Viatcheslav Lebedev on 02.06.2022.
//

import SwiftUI

struct AuthView: View {
    
    @StateObject var viewModel: AuthViewModel
    @State private var isThisViewClosed = false
    @State private var isAuth = true
    @State private var isShowAlert = false
    @State private var alertMsg = ""
    
    
    
    var body: some View {
        VStack(spacing:10){
            
            Text(isAuth ? "Авторизация" : "Регистрация")
                .padding()
                .padding(.horizontal, 30)
                .font(.title2.bold())
                .background(Color("whiteAlpha"))
                .cornerRadius(20)
            
            VStack {
                
                TextField("E-mail ...", text: $viewModel.email)
                    .padding()
                    .background(Color("whiteAlpha"))
                    .cornerRadius(12)
                    .padding(8)
                    .padding(.horizontal, 30)
                
                SecureField("Password ...", text: $viewModel.password)
                    .padding()
                    .background(Color("whiteAlpha"))
                    .cornerRadius(12)
                    .padding(8)
                    .padding(.horizontal, 30)
                
                if !isAuth {
                    SecureField("Confirm password ...", text: $viewModel.confirm)
                        .padding()
                        .background(Color("whiteAlpha"))
                        .cornerRadius(12)
                        .padding(8)
                        .padding(.horizontal, 30)
                }
                
                Button {
                    if isAuth {
                        // Sign in
                        AuthService.shared.signIn(email: viewModel.email,
                                                  password: viewModel.password) { result in
                            switch result {
                            case .success(let user):
                                viewModel.mainScreenViewModel = MainScreenViewModel(user: user, isStart: false)
                                viewModel.email = ""
                                viewModel.password = ""
                                viewModel.confirm = ""
                                isThisViewClosed.toggle()
                            case .failure(let error):
                                alertMsg = error.localizedDescription
                                isShowAlert.toggle()
                            }
                            
                        }
                        
                    } else {
                        // Go to sign up
                        guard viewModel.password == viewModel.confirm else {
                            alertMsg = "Пароли не совпадают"
                            isShowAlert.toggle()
                            return
                        }
                        
                        AuthService.shared.signUp(email: viewModel.email,
                                                  password: viewModel.password) { result in
                            switch result {
                            case .success(let user):
                                print ("Регистрация успешна - \(user.email)")//???
                                isAuth.toggle()
                                viewModel.email = ""
                                viewModel.password = ""
                                viewModel.confirm = ""
                            case .failure(let error):
                                alertMsg = error.localizedDescription
                                isShowAlert.toggle()
                            }
                        }
                    }
                    
                } label: {
                    Text (isAuth ? "Войти" : "Создать аккаунт")
                        .font(.title2)
                        .bold()
                }
                .frame(maxWidth:.infinity)
                .padding()
                .background(Color("whiteAlpha"))
                .cornerRadius(30)
                .padding(8)
                .padding(.horizontal, 30)
                
                Button {
                    isAuth.toggle()
                } label: {
                    Text (isAuth ? "Зарегистрироватся" : "Уже есть аккаунт")
                        .foregroundColor(Color("darkBlue"))
                        .padding()
                        .font(.title3)
                }
            }
            .padding()
            .background(Color("whiteAlpha"))
            .cornerRadius(24)
            .padding(isAuth ? 30 : 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .background(Image("bg_img").blur(radius: isAuth ? 0 : 8))
        .animation(Animation.easeOut(duration: 0.7),value: isAuth)
        .fullScreenCover(isPresented: $isThisViewClosed) {
            if let viewModel = self.viewModel.mainScreenViewModel {
                MainScreenView(viewModel: viewModel)
            }
        }
        .alert(alertMsg, isPresented: $isShowAlert) { Text("OK") }
        
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView(viewModel: AuthViewModel())
    }
}
