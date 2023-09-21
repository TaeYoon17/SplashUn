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
    private static let key = "wFP2oSo7S-Vg8ftxR2SV36MB1ib62AS8er23JwssgxQ"
    typealias Queries = [String:String]
    var baseURL:String {"https://www.naver.com" }
    case search(query: String),random,photo(id: String)
    var endPoint: String {
        return switch self{
        case .photo(let id): "photos/\(id)"
        case .random: "photos/random"
        case .search: "search/photos"
        }
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
        guard var url = URL(string: baseURL)?.appendingPathComponent(endPoint) else {
            throw CustomError.badRequest
        }
        var request = URLRequest(url: url)
        request.method = method
        request.headers = header
        //MARK: -- 쿼리를 url 영역에 넘기는 방법
        request = try URLEncodedFormParameterEncoder(destination: .methodDependent).encode(query, into: request)
        return request
    }
}
