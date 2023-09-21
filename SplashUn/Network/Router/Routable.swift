//
//  Routable.swift
//  SplashUn
//
//  Created by 김태윤 on 2023/09/21.
//

import Foundation
import Alamofire
protocol Routable{
    typealias Query = [String: String]
    var baseURL: String { get }
    var endPoint: URL { get }
    var header: HTTPHeaders{ get }
    var method: HTTPMethod { get }
    var query: Query { get }
}
