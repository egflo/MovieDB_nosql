//
//  ResultsView.swift
//  MovieDB_nosql
//
//

import SwiftUI

struct ResultData {
    let title: String?
    let path: String
    let query: URLQueryItem
    let style: CardStyle
    let orientation: Orientation
}


struct ResultsView: View {
    let data: ResultData
 
    @State private var items = [Movie]()
    @State private var page: Int  = 0
    @State private var last: Bool = false
    @State private var isLoading: Bool = false
    
    var rows: [GridItem] = [GridItem(.adaptive(minimum: 150, maximum: 400))]

    let columns = [
        GridItem(.adaptive(minimum: 180))

    ]
    
    @State private var show = false
    @State private var selected: Movie?

    
    var body: some View {
        
        VStack {
            
            if let title = data.title {
                
                if items.count > 0 {
                    HeaderContainerView(title: title, content: {
                        
                        if data.orientation == .HORIZONTAL {
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHGrid(rows: rows, spacing: 5) {
                                    ForEach(items, id: \.id) {movie in
                                        
                                        CardView(movie: movie, style: data.style)
                                        
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
                            }
                        }
                        else {
                            ScrollView(.vertical) {
                                LazyVGrid(columns:columns, spacing: 5) {
                                    ForEach(items, id: \.id) {movie in
                                        
                                        CardView(movie: movie, style: data.style)
                                        //.frame(minWidth: 0, maxWidth: .infinity, minHeight: 120)
                                        //.frame(minWidth: 100, maxWidth: .infinity, minHeight: 200)
                                        
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
                            }
                            
                        }
                        
                    })
                }
                  
            }
            
            
            else {
                if data.orientation == .HORIZONTAL {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: rows, spacing: 5) {
                            ForEach(items, id: \.id) {movie in
                                
                                CardView(movie: movie, style: data.style)
                                
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
                    }
                }
                else {
                    ScrollView(.vertical) {
                        LazyVGrid(columns:columns, spacing: 5) {
                            ForEach(items, id: \.id) {movie in
                                
                                CardView(movie: movie, style: data.style)
                                //.frame(minWidth: 0, maxWidth: .infinity, minHeight: 120)
                                //.frame(minWidth: 100, maxWidth: .infinity, minHeight: 200)
                                
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
                    }
                    
                }
            }
            
        }
        
        .sheet(item: $selected) {movie in
            
            NavigationStack {
                MoviePopOverView(movie: movie)

            }
            
        }
        
        .onAppear(perform: {
            self.loadQuery()
        })
        
    }
}

extension ResultsView {
    
    func loadToken() {
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
    
    func loadQuery(token: String? = nil) {
        
        let params = [data.query, URLQueryItem(name: "page", value: String(self.page))]
        let path = data.path
        NetworkManager.shared.getRequest(of: Page<Movie>.self, path: path, items: params) { (result) in
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
