//
//  CardView.swift
//  MovieDB_nosql
//
//

import SwiftUI


enum CardStyle {
    case EXPANDED
    case REGULAR
}

enum Orientation {
    case VERTICAL
    case HORIZONTAL
}

struct CardView: View {
    @State var movie: Movie
    let style: CardStyle
    
    var body: some View {
        
        
        if style == .EXPANDED {
            VStack{
                ZStack (alignment: .bottomLeading){
                    if let background = movie.background {
                        AsyncImage(url: URL(string: background)) { image in
                              image
                                  .resizable()
                                  .aspectRatio(contentMode: .fill)
                                  
                          } placeholder: {
                              Image("Placeholder")
                                  .resizable()
                                  .aspectRatio(contentMode: .fill)
                          }

        
                        VStack(alignment: .leading) {
                            Text(movie.title).font(.system(size: 20)).bold().foregroundColor(.white).shadow(radius: 5)
                                .padding(.trailing, 4)
                                .lineLimit(1)
                                .minimumScaleFactor(0.1)

                            Text(formatSubheadline())
                                .font(.subheadline).bold()
                                .foregroundColor(.white)
                                .shadow(radius: 5)

                        }
                        .padding(.bottom,20)
                        .padding(.leading,20)
                        .padding(.trailing,20)
                        
                    }
                    else {
                        Image("Placeholder")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                        
                    }

                }
                    
            }

            .frame(minWidth: 0, maxWidth: 380)
            .frame(height: 220)
            .cornerRadius(8)
            .padding(.top,5)
            .padding(.bottom,5)
        }
        
        else {
            
            VStack(spacing: 5){
                
                    RoundedRectangle(cornerRadius: 8)
                          //.aspectRatio(1.0 , contentMode: .fit)
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
                          //.border(.blue)
                          .cornerRadius(8)
                
                Text(movie.title)
                    .font(.system(size: 15))
                    //.frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                
                if let year = movie.year {
                    Text(String(year))
                        .font(.system(size: 12))
                        //.frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
            }
            .frame(width: 145, height: 240, alignment: .center)

        }

    }
}

extension CardView {
    
    func formatSubheadline() -> String {
        
        var subheadline = "\(String(movie.year ?? 0000)) "
        
        if let rated = movie.rated {
            
            subheadline += "\u{2022} \(rated)"
        }
        
        if movie.genres.count > 0 {
            subheadline += "\u{2022} \(movie.genres[0])"
        }
        
        return subheadline
        
    }
}





