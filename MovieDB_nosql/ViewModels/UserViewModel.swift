//
//  UserViewModel.swift
//  MovieDB_nosql
//
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseAuthCombineSwift
import Combine

class UserViewModel: ObservableObject {
  @Published var user: User?

  @Published var isSignedIn = false

  private var cancellables = Set<AnyCancellable>()

  init() {
    Auth.auth().authStateDidChangePublisher()
      .map { $0 }
      .assign(to: &$user)

    $user
      .map { $0 != nil }
      .assign(to: &$isSignedIn)
  }
    
    func logout() {
        try? Auth.auth().signOut()
        user = nil
        self.isSignedIn.toggle()
    }
}
