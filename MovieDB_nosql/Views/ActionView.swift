//
//  ActionView.swift
//  MovieDB_nosql
//
//

import SwiftUI
import Alamofire

struct BookmarkAction: View {
    @EnvironmentObject var alert: Alert

    let movie: Movie
    
    @State var bookmark: Bookmark?
    
    var body: some View {
        
            VStack {
                if let bookmark = bookmark {

                    
                    Button {
                        print("Remove Bookmark")
                        delete(id: bookmark.id)
                    } label: {
                        VStack(spacing: 5) {
                            
                            VStack {
                                Image(systemName:"minus")
                                    .font(.system(size: 22))
                                    .foregroundColor(.white)
                                    .background(
                                        Rectangle()
                                            .fill(Color(.systemGray4))
                                            .opacity(0.8)
                                            .padding(4)

                                    )
                            }
                            .frame(width: 50, height: 50)
                                                        
                            Text("My List")
                                .font(.subheadline)
                            
                        }

                    }
                    
                }
                else {
                    Button {
                        print("Add Bookmark")
                        create(id: movie.id)
                    } label: {
                        VStack(spacing: 5) {
                            VStack {
                                Image(systemName:"plus")
                                    .font(.system(size: 22))
                                    .foregroundColor(.white)
                                    .background(
                                        Rectangle()
                                            .fill(Color(.systemGray4))
                                            .opacity(0.8)
                                            .padding(4)

                                    )
                            }
                            .frame(width: 50, height: 50)
                            
                            Text("My List")
                                .font(.subheadline)
                            
                        }

                    }
                }
            }
            .onAppear(perform: {
                NetworkManager.shared.token() { (result) in
                    switch result {
                    case .success(let res):
                        DispatchQueue.main.async {
                            
                            get(id: movie.id, token: res)
                            
                        }
                    case .failure(let error):
                        alert.toast = Toast(type: .error, headline: "Error", subtitle: error.localizedDescription)

                    }
                }
            })
        

    }
}

extension BookmarkAction {
    func get(id: String, token: String) {
        let path = "/bookmark/movie/\(id)"
        NetworkManager.shared.getRequest(of: Response<Bookmark>.self, path: path, items: [], token: token) { (result) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    bookmark = response.data
                    
                }
            case .failure(let error):
                
                alert.toast = Toast(type: .error, headline: "Error", subtitle: error.localizedDescription)
                print(error.localizedDescription)
                
            }
        }

    }

    
    func create(id: String) {
        
        let parameters: Parameters = [
            "movieId": id,
            "created": String(Date().timeIntervalSince1970)
        ]
        
        let path = "/bookmark/"
        NetworkManager.shared.postRequest(of: Response<Bookmark>.self, path: path, parameters: parameters){ (result) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    
                    print(response)
                    
                    alert.toast = Toast(type: response.success ? .success : .error, headline: "Info", subtitle:response.message)

                    bookmark = response.data
                    
                }
            case .failure(let error):
                alert.toast = Toast(type: .error, headline: "Error", subtitle: error.localizedDescription)
                
            }
        }

    }
    
    func delete(id: String) {
        
        let path = "/bookmark/\(id)"
        NetworkManager.shared.deleteRequest(of: Response<Bookmark>.self, path: path){ (result) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    
                    print(response)
                    
                    alert.toast = Toast(type: response.success ? .success : .error, headline: "Info", subtitle:response.message)

                    bookmark = nil
                    
                }
            case .failure(let error):
                alert.toast = Toast(type: .error, headline: "Error", subtitle: error.localizedDescription)
                
            }
        }

    }
}

struct RateAction: View {
    let movie: Movie
    @State var open:Bool = false

    var body: some View {
        VStack {
            Button {
                print("Rate")
                withAnimation { self.open = !self.open }

            } label: {
                VStack(spacing: 5) {
                    VStack {
                        Image(systemName:"hand.thumbsup")
                            .font(.system(size: 22))
                            .foregroundColor(.white)

                    }
                    .frame(width: 50, height: 50)
            

                    Text("Rate")
                        .font(.subheadline)
                    
                }
                
            }
                    
            
        }
        .popover(isPresented: $open) {
                HStack(alignment: .center, spacing: 15) {
                    Button {
                        print("Not for me")
                        self.open.toggle()

                    } label: {
                        VStack(spacing: 5) {
                            Image(systemName:"hand.thumbsdown")
                                .font(.system(size: 22))
                                .foregroundColor(.white)

                            Spacer()

                            
                            Text("Dislike")
                            
                        }
                        
                    }
                    
                    Button {
                        print("I like this")
                        self.open.toggle()

                    } label: {
                        VStack(spacing: 5) {
                            Image(systemName:"hand.thumbsup")
                                .font(.system(size: 22))
                                .foregroundColor(.white)

                            Spacer()

                            Text("Like")
                            
                        }
                        
                    }
                    
                    Button {
                        print("Love")
                        self.open.toggle()

                    } label: {
                        VStack(spacing: 5) {
                            Image(systemName:"heart")
                                .font(.system(size: 22))
                                .foregroundColor(.white)
      
                            Spacer()

                            Text("Love")
                        }
                        
                    }
                    
                }
                .buttonStyle(PlainButtonStyle())
                .padding(10)
                //.background(Color(UIColor.systemGray4))
                .cornerRadius(8)
                .frame(width: 220)
                //.shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 0)
                //.offset(x: 0, y: -75) // Move the view above the button
                //.zIndex(2)
            }

        }
            
    
}

struct ShareAction: View {
    let movie: Movie
    private let url = URL(string: "https://www.apple.com")!
    
    var body: some View {
        
            VStack {
                Button {
                } label: {
                    ShareLink(item: url) {
                        VStack(spacing: 5) {
                            
                            VStack {
                                Image(systemName:"paperplane")
                                    .font(.system(size: 22))
                                    .foregroundColor(.white)

                            }
                            .frame(width: 50, height: 50)
                            
                            
                            
                            Text("Share")
                                .font(.subheadline)
                            
                            
                        }
                    }
                    
                }
                
            }
        

    }
}

struct ActionView: View {
    let movie: Movie
    
    var body: some View {
        HStack(spacing: 20) {

            BookmarkAction(movie: movie)
            
            RateAction(movie: movie)
            
            ShareAction(movie: movie)

            
        }
        .zIndex(1)
    }
}

//struct ActionView_Previews: PreviewProvider {
  //  static var previews: some View {
    //    ActionView()
   // }
//}
