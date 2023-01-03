//
//  SearchView.swift
//  MovieDB_nosql
//
//  Created by Emmanuel Flores on 12/19/22.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var items = [Movie]()
    @State private var page: Int  = 0
    @State private var last: Bool = false
    @State private var show = false
    @State private var selected: Movie?
    
    @State private var isLoading: Bool = false
    let columns = [
        GridItem(.adaptive(minimum: 180))
    ]
    
    var body: some View {
            ScrollView(.vertical) {
                LazyVGrid(columns:columns, spacing: 5) {
                    ForEach(items, id: \.self) { movie in

                        CardView(movie: movie, style: CardStyle.REGULAR)
   
                        .onTapGesture(perform: {
                            self.selected = movie
                        })
                        .task {
                            if movie == items.last && !last {
                                self.page += 1
                                self.loadQuery()
                            }
                        }
                        
     
                    }
                }
                .navigationTitle("Search")
            }
            .padding(.horizontal)
            
            .sheet(item: $selected) {movie in
                
                NavigationStack {
                    MoviePopOverView(movie: movie)

                }
                
            }
        
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        //.onSubmit(of: .search, loadQuery(reset: true))
        .onSubmit(of: .search) {
            self.loadQuery(reset: true)
        }

    }

}

extension SearchView {
    
    func loadQuery(reset: Bool = false) {
        self.page = reset ? 0 : self.page

        let params = [URLQueryItem(name: "page", value: String(self.page))]
        let path = "/movie/search/\(self.searchText)"
        NetworkManager.shared.getRequest(of: Page<Movie>.self, path: path, items: params) { (result) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    
                    self.last = response.content.isEmpty
                    self.page = response.pageable.pageNumber
                    
                    if reset {
                        self.items = response.content
                    }
                    else {
                        self.items += response.content
                    }
                    self.isLoading = false
                  

                }
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }

    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
