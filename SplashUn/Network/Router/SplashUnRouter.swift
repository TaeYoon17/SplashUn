//
//  SplashRouter.swift
//  SplashUn
//
//  Created by 김태윤 on 2023/09/21.
//

import Foundation
import Alamofire
enum SplashUnRouter: URLRequestConvertible,Routable{
    typealias Query = [String:String]
    private static let key = "key"
    typealias Queries = [String:String]
    var baseURL:String {"https://www.naver.com" }
    case search(query: String),random,photo(id: String)
    var endPoint: URL{
        let str = switch self{
        case .photo(let id): baseURL + "photos/\(id)"
        case .random: baseURL + "photos/random"
        case .search: baseURL + "search/photos"
        }
        return URL(string: str)!
    }
    var header: HTTPHeaders{
        return ["Authorization" : "Client-ID \(Self.key)" ]
    }
    var method: HTTPMethod{
        return .get
    }
    var query:Query{
        return switch self{
        case .search(let query) : ["query" : query ]
        case .random,.photo: [:]
        }
    }
    func asURLRequest() throws -> URLRequest {
        var request = URLRequest(url: endPoint)
        request.method = method
        request.headers = header
        return request
    }
}
