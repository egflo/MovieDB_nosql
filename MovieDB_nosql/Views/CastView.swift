//
//  CastView.swift
//  MovieDB_nosql
//
//  Created by Emmanuel Flores on 12/21/22.
//

import SwiftUI

struct DropDownCast: View {
    @State var cast: CastDetail
    @State var expand = false
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, content: {
                HStack {
                    Text("Biography").font(.subheadline).bold()
                    
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
                VStack {
                    
                    if let bio = cast.bio {
                        Text(bio)
                    }
                    else {
                        Text("No Biography Found")
                    }
                    
                }.padding()
                    
            }
        }
        .frame(maxWidth: .infinity)
        .animation(.spring())
    }
}

struct CastView: View {
    @Environment(\.dismiss) var dismiss
        
    let cast: Cast
    
    @State var details: CastDetail?
    
    var body: some View {
        
        ScrollView {
            
            if let info = details {
                
                ZStack {
                    
                    Image("Placeholder")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        
                    
                    if let photo = info.photo {
                        
                        VStack {
                            AsyncImage(url: URL(string: photo)) { image in
                                  image
                                      .resizable()
                                      .aspectRatio(contentMode: .fill)
                                      //.frame(width: 150, height: 200)
                                      .frame(minWidth: 150, maxWidth: 250, minHeight: 200, maxHeight: 300)
                                      .cornerRadius(8)
                                      
                              } placeholder: {
                                  Image("Placeholder")
                                      .resizable()
                                      .aspectRatio(contentMode: .fill)
                                      .frame(minWidth: 150, maxWidth: 250, minHeight: 200, maxHeight: 300)
                                      .cornerRadius(8)

                              }
                            


                        }
                        

                    }
                    
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
                
                VStack {
                    Text(cast.name)
                        .font(.headline)
                        .bold()
                        .foregroundColor(.white)
                    
                    if let place = info.birthplace {
                        
                        Text(place)
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.white)
                    }
                }
            

                DropDownCast(cast: info)
                
                ResultsView(data: ResultData(title: nil, path: "/movie/cast/\(cast.id)", query: URLQueryItem(name: "sortBy", value: "revenue"), style: CardStyle.REGULAR, orientation: Orientation.HORIZONTAL))

                
            }
            else {
                ProgressView()
            }
            
        }
        .onAppear(perform: {
            loadQuery()
        })

    }
}

extension CastView {
    func loadQuery() {
  
        let params = [URLQueryItem]()
        let path = "/cast/\(cast.id)"
        NetworkManager.shared.getRequest(of: CastDetail.self, path: path, items: params) { (result) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    
                    details = response

                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

    }
}
