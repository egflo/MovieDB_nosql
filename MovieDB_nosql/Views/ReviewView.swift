//
//  ReviewView.swift
//  MovieDB_nosql
//
//

import SwiftUI
import Firebase
import Alamofire

import UIKit



struct ReviewCard: View {
    @EnvironmentObject var alert: Alert

    let review: Review
    
    @State var like: Bool = false
    @State var dislike: Bool = false

    
    var body: some View {
        
            ZStack{
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color(.systemGray5))

                VStack {
                    Text(review.title)
                        .font(.headline).bold()
                        .frame(maxWidth: .infinity, alignment: .leading)

                    HStack {
                        
                        Text("By \(review.user.firstname)")
                            .font(.subheadline).bold()
                            .foregroundColor(Color.gray)
                            .padding(.bottom, 5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        
                        Image(systemName: "star.fill")
                            .resizable()
                            .foregroundColor(review.sentiment == "postive" ? .green : .red)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15, height: 15)

                        
                        Group{Text(String(review.rating)).font(.system(size: 14)).bold() + Text("/10").font(.system(size: 10)).bold().foregroundColor(.gray)}
                    }

                    Text(review.text)
                        .font(.subheadline).bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    Divider()


                    HStack(spacing: 15) {
                        
                        Spacer()
                        
                        Button {
                            print("Not for me")
                            create(id: review.id, status: Status.dislike)
                            if like {
                                like = false
                            }
                        } label: {
                            VStack(spacing: 5) {
                                Image(systemName:"hand.thumbsdown")
                                    .font(.system(size: 18))
                                    .foregroundColor(dislike ? .red: .white)

                                
                            }
                            
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Button {
                            print("I like this")
                            create(id: review.id, status: Status.like)
                            if dislike {
                                dislike = false
                            }
                            
                        } label: {
                            VStack(spacing: 5) {
                                Image(systemName:"hand.thumbsup")
                                    .font(.system(size: 18))
                                    .foregroundColor(like ? .green: .white)

                                
                            }

                        }
                        .buttonStyle(PlainButtonStyle())

                    }
                    .padding(2)

                }
                .padding(10)
                
                
            }
            .padding(5)
            //.cornerRadius(8)
            //.border(Color(.systemGray5))

    }
    
}

extension ReviewCard {
    
    func create(id: String, status: Status) {
        guard let user = Auth.auth().currentUser else {
            alert.toast = Toast(type: .error, headline: "Error", subtitle: "Unable to retrieve user information")
            return
        }

        let timeStamp = UInt64(Date().timeIntervalSince1970 * 1000)
        let parameters: Parameters = [
            "objectId": id,
            "userId": user.uid,
            "status": status.rawValue,
            "created": timeStamp
        ]
        
        let path = "/review/rate"
        NetworkManager.shared.postRequest(of: Response<Sentiment>.self, path: path, parameters: parameters){ (result) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    
                    if status == .like {
                        like.toggle()
                    }
                    if status == .dislike {
                        dislike.toggle()
                    }
                    
                    print(response)
                    alert.toast = Toast(type: response.success ? .success : .error, headline: "Info", subtitle:response.message)
                    
                }
            case .failure(let error):
                alert.toast = Toast(type: .error, headline: "Error", subtitle: error.localizedDescription)
                
            }
        }

    }
}


struct Reviews: View {
    let movie: Movie
    
    @State private var items = [Review]()
    @State private var page: Int  = 0
    @State private var last: Bool = false
    @State private var isLoading: Bool = false
    let rows = [
        GridItem(.adaptive(minimum: 300))
    ]

    
    @State private var show = false
    @State private var selected: Review?
    
    var body: some View {
        
        VStack {
            
            if items.count > 0 {
                
                HeaderContainerView(title: "Reviews", content: {
                    ScrollView(.horizontal) {
                        LazyHGrid(rows:rows, spacing: 5) {
                            
                            ForEach(items, id: \.id) {review in
                                
                                NavigationLink {
                                    ReviewView(review: review)
                                        .navigationBarBackButtonHidden(true)
                                    
                                } label: {
                                    
                                    if UIDevice.isPhone {
                                        ReviewCard(review: review)
                                        .frame(minWidth: 0, maxWidth: 250)
                                        .frame(height: 200)
                                        .task {
                                            if review == items.last && !last {
                                                self.page += 1
                                                loadQuery()
                                            }
                                        }
                                        
                                    }
                                    else {
                                        ReviewCard(review: review)
                                        .frame(minWidth: 250, maxWidth: 300)
                                        .frame(height: 300)
                                        .task {
                                            if review == items.last && !last {
                                                self.page += 1
                                                loadQuery()
                                            }
                                        }
                                    
                                    }
        
                                    //.onTapGesture(perform: {
                                    //    self.selected = review
                                    // })

                                    
                                }
                                .buttonStyle(PlainButtonStyle())
                                .navigationBarBackButtonHidden(true)
                            }
                        }
                    }

                })
                
            }
            
        }
        
        .onAppear(perform: {
            self.loadQuery()
        })
    //.sheet(item: $selected) {review in
         //       ReviewView(review: review)
        //}
        

    }
    
}

extension Reviews {
    func loadQuery() {
  
        let params = [URLQueryItem(name: "sortBy", value: "popularity"), URLQueryItem(name: "page", value: String(self.page))]
        let path = "/review/movie/\(movie.movieId)"
        NetworkManager.shared.getRequest(of: Page<Review>.self, path: path, items: params) { (result) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.items += response.content
                    self.page = response.number
                    self.last = response.last
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

    }
}




struct ReviewsCompact: View {
    let movie: Movie
    
    @State private var items = [Review]()
    @State private var page: Int  = 0
    @State private var last: Bool = false
    @State private var isLoading: Bool = false
    let rows = [
        GridItem(.adaptive(minimum: 100))
    ]

    
    @State private var show = false
    @State private var selected: Review?
    
    var body: some View {
        VStack {
            
            
            ScrollView(.horizontal) {
                LazyHGrid(rows:rows, spacing: 5) {
                    
                    ForEach(items, id: \.id) {review in
                        
                        NavigationLink {
                            ReviewView(review: review)
                                .navigationBarBackButtonHidden(true)
                            
                        } label: {
                            ReviewCard(review: review)
                                .frame(minWidth: 0, maxWidth: 250)
                                .frame(height: 200)


                                .onTapGesture(perform: {
                                    self.selected = review
                                })
                                .task {
                                    if review == items.last && !last {
                                        self.page += 1
                                        loadQuery()
                                    }
                                }
                            
                        }

                    }
                    .buttonStyle(PlainButtonStyle())
                    
                }
            }
        }

        
        .onAppear(perform: {
            self.loadQuery()
        })

    }
    
}

extension ReviewsCompact {
    func loadQuery() {
  
        let params = [URLQueryItem(name: "sortBy", value: "popularity"), URLQueryItem(name: "page", value: String(self.page))]
        let path = "/review/movie/\(movie.movieId)"
        NetworkManager.shared.getRequest(of: Page<Review>.self, path: path, items: params) { (result) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.items += response.content
                    self.page = response.number
                    self.last = response.last
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

    }
}


struct ReviewView : View {
    @Environment(\.dismiss) var dismiss

    let review : Review
    
    var body: some View {
        
        Button {
            dismiss()
        } label: {
            Image(systemName:"xmark")
                .font(.system(size: 22))
                .foregroundColor(.white)
                .background(
                    Circle()
                        .fill(Color(.systemGray4))
                        .opacity(0.8)
                        .padding(4)

                )
            
        }
        .frame(maxWidth: .infinity, alignment: .topTrailing)
        .padding(.trailing,10)
        .padding(.top,10)
        
        
        VStack {
            
            Text(review.title)
                .font(.headline).bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                
                Text("By \(review.user.firstname)")
                    .font(.subheadline).bold()
                    .foregroundColor(Color.gray)
                    .padding(.bottom, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                
                Image(systemName: "star.fill")
                    .resizable()
                    .foregroundColor(review.sentiment == "postive" ? .green : .red)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 15, height: 15)

                
                Group{Text(String(review.rating)).font(.system(size: 14)).bold() + Text("/10").font(.system(size: 10)).bold().foregroundColor(.gray)}
            }
            
            Text(review.text)
                .font(.subheadline).bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()

        }.padding()

    }

}
