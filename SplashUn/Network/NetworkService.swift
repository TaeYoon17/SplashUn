//
//  NetworkService.swift
//  SplashUn
//
//  Created by 김태윤 on 2023/09/21.
//

import Foundation
import Alamofire
import Combine
class NetworkService {
    
    static let shared = NetworkService()
    
    
    private init() { }
    //MARK: -- 비동기 처리 Async Await으로 처리하기
    func searchPhoto(query: String) async throws -> Photo{
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(SplashUnRouter.search(query: query))
                .responseDecodable(of: Photo.self){ response in
                    switch response.result{
                    case .success(let data):
                        continuation.resume(returning: data)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
            }
        }
    }
    func request<T: Decodable>(type: T.Type, router: AFRoutable) async throws -> T{
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(router).responseDecodable(of: T.self,queue: .global()) { response in
                print(response.result)
                switch response.result{
                case .success(let data):
                    continuation.resume(returning: data)
                case .failure(_):
                    let statusCode = response.response?.statusCode ?? 500
                    print(response.response?.statusCode)
                    let error = CustomError(rawValue: statusCode) ?? .any
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
enum CustomError: Int, Error{
    case badRequest = 401
    case notFound = 404
    case any = 500
}
