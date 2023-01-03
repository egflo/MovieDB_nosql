//
//  AccountView.swift
//  MovieDB_nosql
//
//

import SwiftUI

struct UserView: View {
    @ObservedObject var viewModel = UserViewModel()
    @State var tag:Int? = nil

    var body: some View {
        
        VStack {
            List {
                Section(header: Text("User Info")) {
                    LabeledContent(
                        "User state",
                        value: viewModel.isSignedIn ? "User is signed in" : "User is signed out"
                    )
                    LabeledContent("User ID", value: viewModel.user?.uid ?? "")
                    LabeledContent("Display name", value: viewModel.user?.displayName ?? "")
                    LabeledContent("Email", value: viewModel.user?.email ?? "")
                }
                
                if viewModel.isSignedIn {
                    
                    Button {
                        viewModel.logout()
                    } label: {
                        Text(viewModel.isSignedIn ? "Logout" : "Log In")
                        
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(viewModel.isSignedIn ? .red : .blue)
                    .cornerRadius(8)
                    
                }
                else {
                    NavigationLink(destination: LoginView()) {
                        Button {
                            
                        } label: {
                            Text(viewModel.isSignedIn ? "Logout" : "Log In")
                            
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(viewModel.isSignedIn ? .red : .blue)
                        .cornerRadius(8)
                        
                    }
                    
                }
            }

        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Firebase Auth")
        
    }
}

//struct UserView_Previews: PreviewProvider {
//    static let viewModel = UserViewModel()

//    static var previews: some View {
//        UserView(viewModel: viewModel)
//    }
//}
