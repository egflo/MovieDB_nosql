//
//  BookmarksView.swift
//  MovieDB_nosql
//
//

import SwiftUI

struct BookmarksView: View {
    let style: CardStyle
    let orientation: Orientation
    
    @State private var items = [Bookmark]()
    @State private var page: Int  = 0
    @State private var last: Bool = false
    @State private var selected: Bookmark?
    
    @State private var isLoading: Bool = false
    
    let rows = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    let columns = [
        //GridItem(.adaptive(minimum: 100))
        GridItem(.adaptive(minimum: 180, maximum: 180))
    ]

    
    @State var token: String?
    
    var body: some View {
        VStack {
            
            if orientation == .HORIZONTAL {
                ScrollView(.horizontal , showsIndicators: false) {
                    LazyHGrid(rows: rows, spacing: 5) {
                        ForEach(items, id: \.id) {bookmark in
                            
                            CardView(movie: bookmark.movie, style: style)
                                .onTapGesture(perform: {
                                    self.selected = bookmark
                                })
                                .task {
                                    if bookmark == items.last && !last {
                                        self.page += 1
                                    }
                                }
                            
                        }
                        
                    }
                }
            }
            else {
                ScrollView(.vertical) {
                    LazyVGrid(columns:columns, spacing: 5) {
                        ForEach(items, id: \.id) {bookmark in
                            
                            CardView(movie: bookmark.movie, style: style)
                                .onTapGesture(perform: {
                                    self.selected = bookmark
                                })
                                .task {
                                    if bookmark == items.last && !last {
                                        self.page += 1
                                        if let token = token {
                                            loadQuery(token: token)
                                        }
                                    }
                                }
                            
                        }
                        
                    }
                }
                
            }
            
            
        }
        .sheet(item: $selected) {bookmark in
            
            NavigationView {
                MoviePopOverView(movie: bookmark.movie)
                
            }
            
        }
        
        .onAppear(perform: {
            loadFavorites()
        })
    }
}

extension BookmarksView {
    
    func loadFavorites() {
        
        NetworkManager.shared.token() { (result) in
            switch result {
            case .success(let res):
                DispatchQueue.main.async {
                    
                    print("*** TOKEN() SUCCESS: \(res)")
                    loadQuery(token: res)
                    
                }
            case .failure(let error):
                print("*** TOKEN() ERROR: \(error)")
                
            }
        }
    }
    
    func loadQuery(token: String) {
        
        let params = [URLQueryItem(name: "page", value: String(self.page)), URLQueryItem(name: "sortBy", value: "created")]
        let path = "/bookmark/"
        NetworkManager.shared.getRequest(of: Page<Bookmark>.self, path: path, items: params, token: token) { (result) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    
                    //self.last = response.last
                    self.last = response.content.isEmpty
                    self.page = response.pageable.pageNumber
                    self.items += response.content
                    self.isLoading = false
                    
                }
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }

    }
}
