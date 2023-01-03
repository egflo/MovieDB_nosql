//
//  Decode.swift
//  MovieDB_nosql
//
//  Created by Emmanuel Flores on 12/20/22.
//

import Foundation
import Firebase

@MainActor
class Alert: ObservableObject {
    @Published var toast: Toast? = nil
}

@MainActor
class UserObject: ObservableObject {
    @Published var user: User? = nil
}

// MARK: - Pagabable
struct Sentiment: Codable {
    let userId: String
    let objectId: String
    let created: String
    let isLiked: Bool
}


// MARK: - Movie
struct Movie: Codable, Equatable, Hashable, Identifiable, Comparable {
    let id, title: String
    let year: Int?
    let rated, runtime: String?
    var genres: [String] = [String]()
    let director: String?
    let writer, boxOffice, production: String?
    let plot, language, country, awards: String?
    let poster, background: String?
    let cast: [Cast]?
    let ratings: Ratings?
    let movieId: String
    //let popularity: Double?
    //let revenue: Int?
    let keywords: [Keyword]

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id < rhs.id
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.year = try container.decodeIfPresent(Int.self, forKey: .year)
        self.rated = try container.decodeIfPresent(String.self, forKey: .rated)
        self.runtime = try container.decodeIfPresent(String.self, forKey: .runtime)
        self.genres = try container.decode([String].self, forKey: .genres)
        self.director = try container.decodeIfPresent(String.self, forKey: .director)
        self.writer = try container.decodeIfPresent(String.self, forKey: .writer)
        self.boxOffice = try container.decodeIfPresent(String.self, forKey: .boxOffice)
        self.production = try container.decodeIfPresent(String.self, forKey: .production)
        self.plot = try container.decodeIfPresent(String.self, forKey: .plot)
        self.language = try container.decodeIfPresent(String.self, forKey: .language)
        self.country = try container.decodeIfPresent(String.self, forKey: .country)
        self.awards = try container.decodeIfPresent(String.self, forKey: .awards)
        self.poster = try container.decodeIfPresent(String.self, forKey: .poster)
        self.background = try container.decodeIfPresent(String.self, forKey: .background)
        self.cast = try container.decode([Cast].self, forKey: .cast)
        self.ratings = try container.decodeIfPresent(Ratings.self, forKey: .ratings)
        self.movieId = try container.decode(String.self, forKey: .movieId)
        self.keywords = try container.decode([Keyword].self, forKey: .keywords)
    }
    
    //enum CodingKeys: String, CodingKey {
       // case id, title, year, rated, runtime, genres, director, writer, boxOffice, production, plot, language, country, awards, poster, background, cast, ratings
       // case movieID = "movieId"
        //case popularity, revenue, keywords
   // }
}

// MARK: - Review
struct Review: Codable, Equatable, Hashable, Identifiable {
    let id, movieID: String
    let rating: Int
    let sentiment, title, text: String
    let user: UserDetail
    let date: String

    enum CodingKeys: String, CodingKey {
        case id
        case movieID = "movieId"
        case rating, sentiment, title, text, user, date
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: Review, rhs: Review) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - User
struct UserDetail: Codable {
    let id: Int
    let firstname, lastname, email: String
}


// MARK: - Cast
struct Cast: Codable {
    let id, name: String
    let category: String?
    let characters: [String]
    let photo: String?

    enum CodingKeys: String, CodingKey {
        case id = "castId"
        case name, category, characters, photo
    }
}


struct CastDetail: Codable {
    let id, name: String
    let bio: String?
    let dob: String?
    let dod: String?
    let photo: String?
    let birthplace: String?
    let castId: String

    enum CodingKeys: String, CodingKey {
        case castId = "castId"
        case name, photo, dob, dod, birthplace, bio, id
    }
}

// MARK: - Keyword
struct Keyword: Codable, Hashable {
    let id: Int
    let name: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "tagId"
        case name
    }
}

// MARK: - Ratings
struct Ratings: Codable {
    let rating: Double
    let numOfVotes, metacritic: Double
    let imdb: Double
    let rottenTomatoes, rottenTomatoesAudience: Double
    let rottenTomatoesAudienceStatus, rottenTomatoesStatus: String?
}

// MARK: - Bookmark
struct Bookmark: Codable, Hashable, Identifiable{
    let id: String
    let userId: String
    let movie: Movie
    let created: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: Bookmark, rhs: Bookmark) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: Bookmark, rhs: Bookmark) -> Bool {
        return lhs.id < rhs.id
    }
}

// MARK: - Pagabable
struct Page<T: Codable>: Codable {
    var content: [T]
    var pageable: Pagable
    var totalPages: Int
    var totalElements: Int
    var last: Bool
    var size: Int
    var number: Int
    var sort: Sort
    var numberOfElements: Int
    var first: Bool
    var empty: Bool
}


struct Pagable:Codable {
    var sort: Sort
    var offset: Int
    var pageNumber: Int
    var pageSize: Int
    var paged: Bool
    var unpaged: Bool
}

struct Sort:Codable {
    var unsorted: Bool
    var sorted: Bool
    var empty: Bool
}


struct Response<T: Codable>: Codable {
    let status: String
    let success: Bool
    let message: String
    let data: T?
}
