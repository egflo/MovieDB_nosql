//
//  FavoritesView.swift
//  MovieDB_nosql
//
//

import SwiftUI
import Firebase

struct FavoritesView: View {

    @ObservedObject var viewModel = UserViewModel()

    
    var body: some View {
        NavigationStack {
            
            if viewModel.isSignedIn {
                BookmarksView(style: CardStyle.REGULAR, orientation: Orientation.VERTICAL)
                    .padding(.horizontal)
            }

            else {
                VStack {
                    Text("Sign-in to view your list")
                        .font(.headline)
                        
                    NavigationLink(destination: LoginView()) {
                        Button {
                            
                        } label: {
                            Text("Log In")
                            
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background( .blue)
                        .cornerRadius(8)
                        
                    }
                }
                
                .padding(.horizontal)

            }

               
        }
        .navigationTitle("Favorites")
    }
    
}




struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
