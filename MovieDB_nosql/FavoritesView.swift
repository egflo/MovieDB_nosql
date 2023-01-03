//
//  FavoritesView.swift
//  MovieDB_nosql
//
//  Created by Emmanuel Flores on 12/19/22.
//

import SwiftUI
import Firebase

struct FavoritesView: View {
    @State private var items = [Bookmark]()
    @State private var page: Int  = 0
    @State private var last: Bool = false
    @State private var selected: Bookmark?

    @State private var isLoading: Bool = false
    let columns = [
        //GridItem(.adaptive(minimum: 100))
        GridItem(.adaptive(minimum: 120))
    ]
    
    @State var token: String?
    
    var body: some View {
        NavigationStack {

            BookmarksView(style: CardStyle.REGULAR, orientation: Orientation.VERTICAL)
                .padding(.horizontal)
               
        }
        .navigationTitle("Favorites")
    }
    
}




struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
