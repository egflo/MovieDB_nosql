//
//  ActionView.swift
//  MovieDB_nosql
//
//

import SwiftUI
import Alamofire
import Firebase


struct ModalColorView: UIViewRepresentable {
    
    let color: UIColor
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = color
        }
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}

struct ModalColorViewModifier: ViewModifier {
    
    let color: UIColor
    
    func body(content: Content) -> some View {
        content
            .background(ModalColorView(color: color))
    }
}

extension View {
    /// Set transparent or custom color for a modal background (.screen, .fullScreenCover)
    func modalColor(_ color: UIColor = .clear) -> some View {
        self.modifier(ModalColorViewModifier(color: color))
    }
}

struct BookmarkAction: View {
    @EnvironmentObject var alert: Alert
    @ObservedObject var viewModel = UserViewModel()

    let movie: Movie
    
    @State var bookmark: Bookmark?
    @State var open: Bool = false
    
    var body: some View {
        
        VStack {
            
            if !viewModel.isSignedIn {
                
                Button {
                    print("Add Bookmark")
                    open.toggle()
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
            
            else {
                
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
        .popover(isPresented: $open) {
            
            Text("Login to add to favorites")
                .font(.subheadline)
        }
        
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
    @EnvironmentObject var alert: Alert

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
        //attachmentAnchor: .point(.bottom), arrowEdge: .bottom
        .popover(isPresented: $open) {
            
            VStack {
                HStack(alignment: .center, spacing: 15) {
                    Button {
                        print("Not for me")
                        create(id: movie.id, status: Status.dislike)
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
                        create(id: movie.id, status: Status.like)
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
                        create(id: movie.id, status: Status.love)
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
                .frame(height: 50)
                    .padding(.vertical)

            }
            .presentationDetents([.height(200), .fraction(0.8), .large])
            .cornerRadius(8)

        }

    }
            
}

extension RateAction {
    
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
        
        
        let path = "/movie/rate"
        NetworkManager.shared.postRequest(of: Response<Sentiment>.self, path: path, parameters: parameters){ (result) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    
                    print(response)
                    alert.toast = Toast(type: response.success ? .success : .error, headline: "Info", subtitle:response.message)
                    
                }
            case .failure(let error):
                alert.toast = Toast(type: .error, headline: "Error", subtitle: error.localizedDescription)
                
            }
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
