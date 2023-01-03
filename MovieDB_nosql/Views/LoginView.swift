//
//  LoginView.swift
//  MovieDB_nosql
//
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel = LoginViewModel()
    
    var body: some View {
        VStack{
            Text("Sign In")
                .font(.largeTitle)
            
            Group {
                TextField("Email", text: $viewModel.email)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                
                SecureField("Password", text: $viewModel.password)
                
                    .onSubmit {
                        Task {
                            //Task calling this from async context
                            await viewModel.login()
                        }
                    }
            }
            .padding()
            .background(Color(UIColor.systemFill))
            .cornerRadius(8.0)
            .padding(.bottom, 8)
            
            Button {
                Task {
                    await viewModel.login()
                }
                
            } label: {
                Text("Login")
                    .frame(maxWidth:.infinity)
                    .foregroundColor(Color(uiColor: .systemGray6))
            }
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(.blue)
            .cornerRadius(8)
        }
        .padding()

    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
