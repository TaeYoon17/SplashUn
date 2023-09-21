//
//  PunkRouter.swift
//  SplashUn
//
//  Created by 김태윤 on 2023/09/21.
//

import Alamofire
import Foundation

enum PunkRouter: AFRoutable{
    var baseURL: String{ "https://api.punkapi.com/v2/" }
    case random,single(beerId: Int),multi(page:Int,per:Int)
    var endPoint: String{
        switch self{
        case .multi: "beers"
        case .random: "random"
        case .single: "beers"
        }
    }
    
    var header: HTTPHeaders{ .init() }
    var method: HTTPMethod{ .get }
    var query: Query{
        switch self{
        case .multi(page: let page, per: let per):
            ["page":"\(page)",
             "per_page":"\(per)"]
        default: [:]
        }
    }
    private var paths:[String]{
        switch self{
        case .multi:[]
        case .random:[]
        case .single(let id): ["\(id)"] 
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        guard var url = URL(string: baseURL)?.appendingPathComponent(endPoint) else {
            throw URLError(.badURL)
        }
        url = paths.reduce(url) { $0.appendingPathComponent($1) }
        print(url)
        var request = URLRequest(url: url)
        request.method = method
        request.headers = header
        request = try URLEncodedFormParameterEncoder(destination: .methodDependent).encode(query, into: request)
        return request
    }
    
}
