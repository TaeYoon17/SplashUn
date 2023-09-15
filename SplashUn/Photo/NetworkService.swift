//
//  NetworkService.swift
//  SplashUn
//
//  Created by 김태윤 on 2023/09/12.
//

import Foundation
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
    
}
