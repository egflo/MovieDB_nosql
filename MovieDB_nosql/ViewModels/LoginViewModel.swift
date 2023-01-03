//
//  LoginViewModel.swift
//  MovieDB_nosql
//
//

import Foundation
import FirebaseAuthCombineSwift
import FirebaseAuth
import Combine


class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    @Published var loggedIn = false
    @Published var message = ""
    
    private var cancellable: AnyCancellable?
    
    init() {
        self.cancellable = Publishers.CombineLatest($email, $password)
            .map{$0.isEmpty && $1.isEmpty}
            .sink {empty in
                if !empty {
                    self.message = ""
                }
            }
    }
    
    //Changes on UI happen on Main Thread so add annotation
    @MainActor
    func login() async {
        do {
            
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            let user = result.user
            print(user)
            self.loggedIn  = true
            
        }
        catch {
            print(error)
        }
    }
}
