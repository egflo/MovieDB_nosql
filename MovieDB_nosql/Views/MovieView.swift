//
//  MovieCard.swift
//  MovieDB_nosql
//
//

import SwiftUI
import WrappingHStack
import CachedAsyncImage
import Alamofire
import Firebase
import SkeletonUI
import UIKit


extension Double {
    
    func formatString() -> String {
        
        return String(format: "%.0f", self)
    }
    
}

//  HStack {
 //     Text("Cast & Crew").font(.subheadline).bold()
      
//   }
//   .padding()
  
//})
//.frame(maxWidth: .infinity)
// .background(Color(.systemGray5))
//.foregroundColor(Color.blue)

struct ReviewSection: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    let movie: Movie

    var body: some View {
        if horizontalSizeClass == .compact {
            Reviews(movie: movie) // view laid out for smaller screens, like an iPhone

        } else {
            Reviews(movie: movie) // view laid out for wide screens, like an iPad
        }
    }
}


struct CastSection: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    let movie: Movie

    var body: some View {
        if horizontalSizeClass == .compact {
            CastsCompact(movie: movie) // view laid out for smaller screens, like an iPhone

        } else {
            Casts(movie: movie) // view laid out for wide screens, like an iPad
        }
    }
}


struct HeaderContainerView<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5, content: {
            
            Text(title)
                .font(.subheadline)
                .bold()
                .frame(maxWidth:.infinity, alignment: .leading)

            Divider()
                .frame(minHeight: 2)
                .overlay(Color(.systemGray4))
            
            self.content
            
        })
    }
}



struct InfoSection: View {
    @State var movie: Movie
    
    let columns = [
        GridItem(.adaptive(minimum: 150))

    ]
    
    var body: some View {
        
        HeaderContainerView(title: "Additional Info") {
            
            LazyVGrid(columns: columns, spacing: 20){
                
                if let unwrapped = movie.language {
                    
                    VStack (alignment: .leading) {
                        Text("Language(s)")
                            .bold()
                            .foregroundColor(Color.gray)
                            .font(.system(size: 15))
                        
                        Text(unwrapped)
                            .font(.system(size: 15))
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: 150, alignment: .leading)
                    .padding(.bottom, 10)
                

                    //ivider()
                }
                
                if let unwrapped = movie.writer {
                    
                    VStack (alignment: .leading) {
                        Text("Writer(s)")
                            .bold()
                            .foregroundColor(Color.gray)
                            .font(.system(size: 15))
                        
                        Text(unwrapped)
                            .font(.system(size: 15))
                        
                        Spacer()

                    }
                    .frame(maxWidth: .infinity, maxHeight: 150, alignment: .leading)
                    .padding(.bottom, 10)
                   // Divider()

                }
                
                if let unwrapped = movie.awards {
                    VStack (alignment: .leading) {
                        Text("Awards(s)")
                            .bold()
                            .foregroundColor(Color.gray)
                            .font(.system(size: 15))
                        
                        Text(unwrapped)
                            .font(.system(size: 15))
                        
                        Spacer()

                    }
                    .frame(maxWidth: .infinity, maxHeight: 150, alignment: .leading)
                    .padding(.bottom, 10)
                }
                
                if let unwrapped = movie.boxOffice {
                    VStack (alignment: .leading) {
                        Text("Box Office")
                            .bold()
                            .foregroundColor(Color.gray)
                            .font(.system(size: 15))
                        
                        Text(unwrapped)
                            .font(.system(size: 15))
                        
                        Spacer()

                    }
                    .frame(maxWidth: .infinity, maxHeight: 150, alignment: .leading)
                    .padding(.bottom, 10)

                }
                
                if let unwrapped = movie.production {
                    VStack (alignment: .leading) {
                        Text("Production")
                            .bold()
                            .foregroundColor(Color.gray)
                            .font(.system(size: 15))
                        
                        Text(unwrapped)
                            .font(.system(size: 15))
                        
                        Spacer()

                    }
                    .frame(maxWidth: .infinity, maxHeight: 150, alignment: .leading)
                    .padding(.bottom, 10)


                }
                
                if let unwrapped = movie.country {
                    VStack (alignment: .leading) {
                        Text("Country")
                            .bold()
                            .foregroundColor(Color.gray)
                            .font(.system(size: 15))
                        
                        Text(unwrapped)
                            .font(.system(size: 15))
                        
                        Spacer()


                    }
                    .frame(maxWidth: .infinity, maxHeight: 150, alignment: .leading)
                    .padding(.bottom, 10)

                }
                
            }
        }
     
    }
}


struct DropDown: View {
    @State var expand = false

    var body: some View {
        VStack {

            VStack(alignment: .leading, content: {

                
                HStack {
                    Text("More Details").font(.subheadline).bold()
                    
                    Image(systemName: expand ? "chevron.up" : "chevron.down")
                        .font(.system(size: 20))
                }
                .padding()
                
         
                
            })
            .frame(maxWidth: .infinity)
            .background(Color(.systemGray5))
            .foregroundColor(Color.blue)
            .onTapGesture {
                self.expand.toggle()
            }
            
            if expand {
  
                    
            }
        }
        .frame(maxWidth: .infinity)
        .animation(.spring())
    }
}


struct RatingContainerView<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        HStack(spacing:5) {

            self.content

        }
        .padding(.horizontal,8)
        .padding(.vertical, 2)
        .background(RoundedRectangle(cornerRadius: 8).fill(Color(.systemGray5).opacity(5)))
    }
}


struct RatingRow: View {
    let movie: Movie
    
    var body: some View {
        
        
        HStack(alignment: .center, spacing: 5) {
            
            if let ratings = movie.ratings {

                if ratings.imdb > 0 {
                    
                    RatingContainerView {
                        Image("IMDB")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 25)
                        
                        Group{Text(String(ratings.imdb)).font(.system(size: 14)).bold() + Text("/10").font(.system(size: 10)).bold().foregroundColor(.gray)}

                    }
                }
                
                if ratings.metacritic > 0 {
                    
                    RatingContainerView {
                        Image("Meta")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                        
                        Text("\(ratings.metacritic.formatString())").font(.system(size: 14)).bold()

                    }

                }
                
                if let status = ratings.rottenTomatoesStatus {
                    
                    RatingContainerView {
                                                                                        
                        Image(status)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                        
                        Text("\(ratings.rottenTomatoes.formatString())%").font(.system(size: 14)).bold()

                    }
                    
                    
                }
                
                if let status = ratings.rottenTomatoesAudienceStatus {
                    
                    RatingContainerView {
                        
                        Image(status)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                        
                        Text("\(ratings.rottenTomatoesAudience.formatString())%").font(.system(size: 14)).bold()
                        
                    }
     
     
                }

            }
        }
        
    }
}


struct Casts: View {
    let movie: Movie
    
    var body: some View {
        if let cast = movie.cast {
            
            HeaderContainerView(title: "Cast & Crew", content: {
                ScrollView(.horizontal) {
                    HStack(spacing: 10) {
                        
                        ForEach(cast, id: \.id) { cast in
                            NavigationLink {
                                CastView(cast: cast)
                                    .navigationBarBackButtonHidden(true)

                            } label: {
                                         
                                VStack(spacing: 10) {

                                        VStack {
                                            RoundedRectangle(cornerRadius: 0)
                                                  .aspectRatio(1.0 , contentMode: .fill)
                                                  .foregroundColor(.gray.opacity(0.3))
                                                  .overlay {
                                                      
                                                      if let photo = cast.photo {
                                                          AsyncImage(url: URL(string: photo)) { image in
                                                                image
                                                                  .resizable()
                                                                  .aspectRatio(contentMode: .fill)

                                                            } placeholder: {
                                                                ProgressView()
                                                            }
                                                   
                                                      }
                                                      
                                                      else {
                                                          Image(systemName: "person")
                                                              .font(.system(size: 55))
                                                              //.cornerRadius(8)
                                                          
                                                      }
                                                      
                                                      
                                                  }
                                       
                                        }
                                        .frame(width: 125, height: 125)
                                        .clipped()
                                        .cornerRadius(8)

                                        
                                        VStack(alignment: .leading) {
                                            Text(cast.name)
                                                .font(.subheadline).bold()
                                                .foregroundColor(Color.blue)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .lineLimit(1)
                                            
                                            HStack(spacing: 5){
                                                if cast.characters.count > 0 {
                                                    ForEach(cast.characters, id: \.self) { character in
                                                        Text(character)
                                                            .font(.subheadline)
                                                            .foregroundColor(.gray)
                                                            .frame(maxWidth: .infinity, alignment: .leading)
                                                            .lineLimit(1)

                                                    }
                                                }
                                                else {
                                                    Text(cast.category?.description ?? "")
                                                        .font(.subheadline)
                                                        .foregroundColor(.gray)
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                        .lineLimit(1)

                                                }

                                            }

                                        }

                                }.frame(width: 125)
                            
                                    
                            }.buttonStyle(PlainButtonStyle())
                        }
                    }

                }
                
            })
 
        }
    }
}


struct CastsCompact: View {
    let movie: Movie
    
    var body: some View {
        if let cast = movie.cast {

            HeaderContainerView(title: "Cast & Crew", content: {
                
                ScrollView(.vertical) {
                    VStack(spacing:0) {
                        ForEach(cast, id: \.id) { cast in
                            NavigationLink {
                                CastView(cast: cast)
                                    .navigationBarBackButtonHidden(true)

                            } label: {
                                
                                VStack(spacing: 0) {
                                    Divider()
                                    HStack {
                                        
                                        VStack {
                                            RoundedRectangle(cornerRadius: 0)
                                                  .aspectRatio(1.0 , contentMode: .fill)
                                                  .foregroundColor(.gray.opacity(0.3))
                                                  .overlay {
                                                      
                                                      if let photo = cast.photo {
                                                          AsyncImage(url: URL(string: photo)) { image in
                                                                image
                                                                  .resizable()
                                                                  .aspectRatio(contentMode: .fill)

                                                            } placeholder: {
                                                                ProgressView()
                                                            }
                                                   
                                                      }
                                                      
                                                      else {
                                                          Image(systemName: "person")
                                                          
                                                      }
                                                    
                                                      
                                                  }
                                       
                                        }
                                        .clipped()
                                        .cornerRadius(8)
                                        .padding(5)
                                        .frame(width: 80)

                                        
                                        
                                        VStack(alignment: .leading) {
                                            Text(cast.name)
                                                .font(.headline).bold()
                                            
                                            HStack(spacing: 5){
                                                if cast.characters.count > 0 {
                                                    ForEach(cast.characters, id: \.self) { character in
                                                        Text(character)
                                                            .font(.subheadline).bold().foregroundColor(.gray)
                                                    }
                                                }
                                                else {
                                                    Text(cast.category?.description ?? "")
                                                        .font(.subheadline).bold().foregroundColor(.gray)
                                                }

                                            }

                                        }
                                        .padding(.leading,5)

                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            //.resizable()
                                            //.scaledToFit()
                                            .padding(.vertical)
                                            .foregroundColor(.gray)
                                            
                                        
                                    }
                                    Divider()
                                }
                                .frame(height: 80)

                                    
                            }.buttonStyle(PlainButtonStyle())
                        }
                    }

                }
            })


        }

    }
}


struct MoviePopOverView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var alert = Alert()
    
    //let id: String
    @State var movie: Movie?
    
    let columns = [
        GridItem(.flexible()),
    ]
    
    var  body: some View {
        
        ScrollView {
            
            if let movie = movie {
                
                VStack(spacing: 0){
                    
                    Group {
                  
                        ZStack {
                            
                                if let background = movie.background {
                                    
                                    CachedAsyncImage(url: URL(string: background)) { image in
                                          image
                                              .resizable()
                                              .aspectRatio(contentMode: .fill)
                                              //.blur(radius: 4)
                                              
                                    } placeholder: {
                                        VStack {
                                            Image("Placeholder")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)

                                        }

                                      }
                         
                                    
                                }
                                else {
                                    Image("Placeholder")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)

                                        
                                    
                                }
                                
                            
                                RoundedRectangle(cornerRadius: 8)
                                      .aspectRatio(1.0 , contentMode: .fit)
                                      .foregroundColor(.gray.opacity(0.3))
                                      .overlay {
                                          if let poster = movie.poster {
                                              AsyncImage(url: URL(string: poster)) { image in
                                                  image
                                                      .resizable()
                                                      .scaledToFill()
                                                      .aspectRatio(1, contentMode: .fit)
                                                      .clipped()


                                                  
                                              } placeholder: {
                                                  ProgressView()

                                              }
                                              
                                          }
                                          
                                          
                                          else {
                                              Image(systemName: "film")
                                                  .font(.system(size: 25.0))
                                                  //.aspectRatio(1, contentMode: .fill)
                                                  .foregroundColor(.blue)

                                              
                                          }
                                      }
                                      .frame(minWidth: 150, maxWidth: UIDevice.isPad ? 250: 150, minHeight: 200, maxHeight: UIDevice.isPad ? 350 : 200)
                                      .cornerRadius(8)
                            
                                
                                Button {
                                    dismiss()
                                } label: {
                                    Image(systemName:"xmark")
                                        .font(.system(size: 22))
                                        .foregroundColor(.white)
                                        .padding(4)
                                        .background(
                                            Circle()
                                                .fill(Color(.systemGray4))
                                                .opacity(0.8)

                                        )
                                    
                                }
                                .frame(maxWidth: .infinity, alignment: .topTrailing)
                                .padding(.trailing,10)
                                .padding(.top,10)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)

                            }
                
                        
                    }
                  
                    VStack(alignment: .center, spacing: 10){
                        
                        Text(movie.title).font(.system(size: 28))
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .center)


                        Text(formatSubheadline(movie: movie))
                            .font(.system(size: 15))
                            .frame(maxWidth: .infinity, alignment: .center)

                        
                        HStack(alignment: .center, spacing: 10) {
                            
                            ForEach(movie.genres, id: \.self) { genre in
                                
                                CapsuleView(text: genre)
                                
                            }
                            
                        }.frame(maxWidth: .infinity, alignment: .center)
                        
                        
                        ActionView(movie: movie)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        if let overview = movie.plot {
                            Text(overview)
                                .font(.system(size: 15))
                        }
                        
                        
                        RatingRow(movie: movie)
                        
                        if let keywords = movie.keywords {
                            
                            //TagView(items: keywords)
                            
                            WrappingHStack(keywords, id: \.self) { item in
                                CapsuleView(text: item.name)
                                    .padding(4)
                                
                            }

                        }
                             

                        Group {
                            CastSection(movie: movie)

                            ReviewSection(movie: movie)

                            
                            ResultsView(data: ResultData(title: "Related", path: "/movie/suggest/\(movie.movieId)", query: URLQueryItem(name: "sortBy", value: "popularity"), style: CardStyle.REGULAR, orientation: Orientation.HORIZONTAL))
                            
                            
                            InfoSection(movie: movie)
                            
                        }


                    }

                    .padding()

                }
                .onAppear(perform: {
                    
                    NetworkManager.shared.token() { (result) in
                        switch result {
                        case .success(let res):
                            DispatchQueue.main.async {
                                
                                print("*** TOKEN() SUCCESS: \(res)")
                                load(id: movie.movieId, token: res)
                                
                            }
                        case .failure(let error):
                            print("*** TOKEN() ERROR: \(error)")
                            
                        }
                    }
                })
            }
            
            else {
                ProgressView()
            }

        }
        .environmentObject(alert)
        .toastView(toast: $alert.toast)

        
    }
}

extension MoviePopOverView {
    
    func formatSubheadline(movie: Movie) -> String {
                
        var subheadline = "\(String(movie.year ?? 0000)) "

        if let rated = movie.rated {
            
            subheadline += "\u{2022} \(rated) "
        }
        
        if let runtime = movie.runtime {
            
            subheadline += "\u{2022} \(runtime) min"
        }
        
        return subheadline
        
    }
    
    func load(id: String, token: String? = nil) {
        let path = "/movie/\(id)"
        NetworkManager.shared.getRequest(of: Movie.self, path: path, items: [], token: token) { (result) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    
                    self.movie = response
                    
                }
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    
}


