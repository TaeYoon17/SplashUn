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
    
    private let key = "wFP2oSo7S-Vg8ftxR2SV36MB1ib62AS8er23JwssgxQ"
    private init() { }
    
    func searchPhoto(query: String, completion: @escaping (Photo?) -> Void ) {
    
        guard let url = URL(string: "https://api.unsplash.com/search/photos?query=\(query)&client_id=\(key)") else { return }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                print(error)
                return
            }
            guard let response = response as? HTTPURLResponse, (200...500).contains(response.statusCode) else {
                return
            }
            do {
                let result = try JSONDecoder().decode(Photo.self, from: data!)
                completion(result)
                
            } catch {
                print(error)
            }
        }.resume()
        
    }
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
    func request<T: Decodable>(type: T.Type, router: SplashUnRouter) async throws -> T{
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(router).responseDecodable(of: T.self,queue: .global()) { response in
                switch response.result{
                case .success(let data):
                    continuation.resume(returning: data)
                case .failure(_):
                    let statusCode = response.response?.statusCode ?? 500
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
