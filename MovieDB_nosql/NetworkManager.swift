//
//  NetworkManager.swift
//  MovieDB_nosql
//
//

import Foundation
import Alamofire
import Firebase
import Combine


class API {
    static let scheme = "http"
    static let host = "192.168.18.12"
    static let port: Int = 8080
}


enum NetworkError: Error {
    case invalidAuthorization
    case invalidJSON
    case invalidJSONResponse
    case invalidResponeCode(code:Int)
    case invalidURL
    case invalidCredentials
    case notFound
}


extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidAuthorization:
            return NSLocalizedString("Unauthorized Access", comment: "Invalid Authentication")
        case .invalidJSON:
            return NSLocalizedString("Unable to Encode Data Model", comment: "Invalid JSON")
        case .invalidJSONResponse:
            return NSLocalizedString("Invalid JSON From Recieved", comment: "Invalid JSON")
        case .invalidResponeCode(let code):
            return NSLocalizedString("Invalid Respone Code \(code)", comment: "Non 200 Status Code")
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "Bad URL")
        case .invalidCredentials:
            return NSLocalizedString("Incorrect Email/Password", comment: "Bad Username/Password")
        case .notFound:
            return NSLocalizedString("Resource Not Found", comment: "Selected Resource was not found.")

        }
    }
}

class NetworkManager {
    
    static let shared: NetworkManager = {
        return NetworkManager()
    }()
    
    let session: Session
    
    init() {
        self.session = Session()
        
        //var components = URLComponents()
        //components.scheme = API.scheme
        //components.host = API.host
        //components.port = API.port
       // self.components = components
    }
    
    func token(_ completion: @escaping (Result<String,Error>) -> ()) {
                guard let user = Auth.auth().currentUser else {
                    completion(.failure(NetworkError.invalidCredentials))
                    return
                }
        
                user.getIDToken(completion: { (res, err) in
                    if err != nil {
                        //print("*** TOKEN() ERROR: \(err)")
                        completion(.failure(err!))
                    } else {
                        //print("*** TOKEN() SUCCESS: \(res)")
                        completion(.success(res!))
                    }
                })
            }
    
    func getRequest<T: Decodable>(of type: T.Type = T.self, path: String, items: [URLQueryItem] = [], token: String? = nil, completion: @escaping (Result<T,Error>) -> Void) {
        
        var components = URLComponents()
        components.scheme = API.scheme
        components.host = API.host
        components.port = API.port
        components.path = path
        components.queryItems = items
        
        var headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        if let token = token {
            
            headers = [
                "Authorization": "Bearer \(token)",
                "Content-Type": "application/json",
                "Accept": "application/json"
            ]
            
        }

        session.request(components.url!,
                        method: .get,
                        parameters: nil,
                        encoding: URLEncoding.default,
                        headers: headers
        )
        
        .validate(statusCode: 200..<500)
        .response(completionHandler: { (response) in
            switch response.result {
            case .success(let data):
                switch response.response?.statusCode {
                case 200:
                    do {
                        let content = try JSONDecoder().decode(T.self, from:  data!)
                        completion(.success(content))
                        
                    }
                     catch let DecodingError.dataCorrupted(context) {
                        print(context)
                        //completion(.failure(error))

                    } catch let DecodingError.keyNotFound(key, context) {
                        print("Key '\(key)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                        //completion(.failure(error))

                    } catch let DecodingError.valueNotFound(value, context) {
                        print("Value '\(value)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                        //completion(.failure(error))

                    } catch let DecodingError.typeMismatch(type, context)  {
                        print("Type '\(type)' mismatch:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                        //completion(.failure(error))

                    } catch {
                        completion(.failure(error))
                    }
                    
                case 404:
                    completion(.failure(NetworkError.notFound))
                    
                default:
                    print(response.response?.statusCode)
                    let code = response.response?.statusCode ?? 404
                    completion(.failure(NetworkError.invalidResponeCode(code: code)))
                    
                }
            case .failure(let error):
                completion(.failure(error))
                
            }
        })
        
    }
    
    func postRequest<T: Decodable>(of type: T.Type = T.self, path: String, parameters: Parameters, completion: @escaping (Result<T,Error>) -> Void) {
        
        // Prepare URL
        let path = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    
        guard let url = URL(string: path!) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var components = URLComponents()
        components.scheme = API.scheme
        components.host = API.host
        components.port = API.port
        components.path = url.absoluteString
        
        
        self.token(){(result) in
            switch result {
            case .success(let res):
                DispatchQueue.main.async {
                    
                    let headers: HTTPHeaders = [
                        "Accept": "application/json",
                        "Content-Type": "application/json",
                        "Authorization": "Bearer \(res)"
                    ]
                    
                    
                    self.session.request(components.url!,
                               method: .post,
                               parameters: parameters,
                               encoding: JSONEncoding.default,
                               headers: headers
                        )
                    
                        .validate(statusCode: 200..<500)
                        .response(completionHandler: { (response) in
                            switch response.result {
                                case .success(let data):
                                switch response.response?.statusCode {
                                case 200:
                                    do {
                                        let content = try JSONDecoder().decode(T.self, from:  data!)
                                        completion(.success(content))
                                        
                                    } catch let error {
                                        completion(.failure(error))
                                    }

                                default:
                                    let code = response.response?.statusCode ?? 404
                                    completion(.failure(NetworkError.invalidResponeCode(code: code)))

                            }
                            case .failure(let error):
                                completion(.failure(error))

                            }
                        })
                    
                }
            case .failure(let error):
                completion(.failure(error))

            }
        }
                
    }
    
    func deleteRequest<T: Decodable>(of type: T.Type = T.self, path: String, completion: @escaping (Result<T,Error>) -> Void) {
        
        // Prepare URL
        let path = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    
        guard let url = URL(string: path!) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var components = URLComponents()
        components.scheme = API.scheme
        components.host = API.host
        components.port = API.port
        components.path = url.absoluteString
        
        
        self.token(){(result) in
            switch result {
            case .success(let res):
                DispatchQueue.main.async {
                    
                    print("*** TOKEN() SUCCESS: \(res)")
                    var headers: HTTPHeaders = [
                        "Accept": "application/json",
                        "Content-Type": "application/json",
                        "Authorization": "Bearer \(res)"
                    ]
                    
                    
                    self.session.request(components.url!,
                               method: .delete,
                               encoding: JSONEncoding.default,
                               headers: headers
                        )
                    
                        .validate(statusCode: 200..<500)
                        .response(completionHandler: { (response) in
                            switch response.result {
                                case .success(let data):
                                switch response.response?.statusCode {
                                case 200:
                                    do {
                                        let content = try JSONDecoder().decode(T.self, from:  data!)
                                        completion(.success(content))
                                        
                                    } catch let error {
                                        completion(.failure(error))
                                    }

                                default:
                                    let code = response.response?.statusCode ?? 404
                                    completion(.failure(NetworkError.invalidResponeCode(code: code)))

                            }
                            case .failure(let error):
                                completion(.failure(error))

                            }
                        })
                    
                }
            case .failure(let error):
                print("*** TOKEN() ERROR: \(error)")
                completion(.failure(error))

            }
        }
                
    }
}

enum ContentError: Error {
    case serverError
    case noData
}

class ContentLoader<T: Codable & Equatable>: ObservableObject {
    @Published private(set) var data: [T] = []
    
    private let urlSession = URLSession(configuration: .default)
    private let limit = 10
    private var offset = 0
    private var page = 0
    private var path = ""
    
    init(offset: Int = 0, page: Int = 0, path: String = "") {
        self.offset = offset
        self.page = page
        self.path = path
    }
    
    func restartPagination() {
        offset = 0
        page = 0
    }
    
    
    private func getContent() async throws -> [T] {
        
        var components = URLComponents()
        components.scheme = API.scheme
        components.host = API.host
        components.port = API.port
        components.path = path
        
        let items = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "limit", value: String(limit))
        ]
        
        components.queryItems = items


        print(components.url!)
        
        let (data, response) = try await URLSession.shared.data(from: components.url!)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200
        else { throw ContentError.serverError }
        
        guard let decoded = try? JSONDecoder().decode(Page<T>.self, from: data)
        else { throw ContentError.noData }
        
        self.offset += self.limit
        self.page += 1
        
        return decoded.content
    }
    
    @MainActor func load(restart: Bool = false) async {
        if restart {
            restartPagination()
            data.removeAll()
        }
        
        do {
            data += try await getContent()
        } catch {
            print("error: ",error)
        }
    }
}

class ContentDataSourceTest<T: Codable & Equatable>: ObservableObject {
    @Published var items = [T]()
    @Published var isLoadingPage = false
    @Published var endOfList = false
    
    private var canLoadMorePages = true
    private var currentPage = 0
    private let pageSize = 25
    
    var cancellable: Set<AnyCancellable> = Set()
    
    private var accessToken: String

    init(token: String) {
        self.accessToken = token
    }
    
    func reset() {
        items.removeAll()
        currentPage = 0
        canLoadMorePages = true
        isLoadingPage = false
        endOfList = false
    }
    
    
    func shouldLoadMore(item : T) -> Bool{
        if let last = items.last
        {
            if item == last{
                return true
            }
            else{
                return false
            }
        }
        return false
    }
    
    func fetch(path: String) {
        guard canLoadMorePages else {
            return
        }
        
        isLoadingPage = true
        
        let url = "\(API.host)/\(path)?limit=\(pageSize)&page=\(currentPage)"
        let encoded_url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        var request = URLRequest(url: URL(string: encoded_url!)!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: Page<T>.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { response in
                self.canLoadMorePages = !response.last
                self.isLoadingPage = false
                self.currentPage += 1
                self.endOfList = response.content.isEmpty
            })
            .sink(receiveCompletion: { completion in
            }) { item in
                self.items.append(contentsOf: item.content)
            }
            .store(in: &cancellable)
    }
}
