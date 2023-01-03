//
//  HomeView.swift
//  MovieDB_nosql
//
//

import SwiftUI
import Firebase


struct HomeView: View {
    
    @State var queries = []
    @State var show = false
    
    let params = [
        ResultData(title: nil, path: "/movie/all", query: URLQueryItem(name: "sortBy", value: "ratings.numOfVotes"), style: CardStyle.REGULAR, orientation: Orientation.HORIZONTAL),
        ResultData(title: nil, path: "/movie/all", query: URLQueryItem(name: "sortBy", value: "popularity"), style: CardStyle.REGULAR, orientation: Orientation.HORIZONTAL),
        ResultData(title: nil, path: "/movie/all", query: URLQueryItem(name: "sortBy", value: "revenue"), style: CardStyle.REGULAR, orientation: Orientation.HORIZONTAL)

    ]
    var body: some View {
        
        
            ScrollView {
                
                if show {
                    BookmarksView(style: CardStyle.EXPANDED, orientation: Orientation.HORIZONTAL)

                }
                else {
                    
                    ResultsView(data: params[0])
                }
                
                
                VStack(spacing: 5) {
                    Text("Most Popular")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    ResultsView(data: params[1])
                }

                VStack(spacing: 5) {
                    Text("Box Office Hits")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    ResultsView(data: params[2])

                }
                
            }
            .padding(.horizontal)
        
        .onAppear(perform: {
            Auth.auth().addStateDidChangeListener() { auth, user in
                if user != nil {
                    show = true
                }
            }
        })

        

    }
    
}
extension HomeView {
    
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
