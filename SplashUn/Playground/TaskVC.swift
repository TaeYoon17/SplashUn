//
//  TaskVC.swift
//  SplashUn
//
//  Created by 김태윤 on 2023/09/15.
//

import UIKit
import SnapKit
import CoreLocation
enum ImageError: Error{
    case url
    case prepared
}
typealias LocationContinuation = CheckedContinuation<[CLLocation],Error>
class TaskVC: UIViewController{
    let urlStr = "https://images.unsplash.com/photo-1682687220247-9f786e34d472?ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1965&q=80"
    let imageView = UIImageView()
    
    private var locationContinuation: LocationContinuation?
    let locationManager = CLLocationManager()
    func sharedPostsFromPeer() async throws -> []{
        try await withCheckedThrowingContinuation({ continuation in
            self.locationContinuation = continuation
            self.locationManager.
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(100)
        }
        Task{[weak self] in
            print("123456")
            Task{[weak self] in
                guard let self else {return}
                do{
                    imageView.image = try await fetchThumbnail(for: urlStr)
                }catch{
                    print(error)
                }
            }
        }
    }
    
    @MainActor func fetchThumbnail(for id: String) async throws -> UIImage{
        guard let url = URL(string: urlStr) else {
            throw ImageError.url
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {throw ImageError.url}
        let image = UIImage(data: data)
        guard let preparedImage = await image?.byPreparingForDisplay(),
              let thumbnail = await preparedImage.thumbnail else{
            throw ImageError.prepared
        }
        return thumbnail
    }
}

extension TaskVC: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    
}
extension CLLocationManager{
    func _locationManager(_ manager: CLLocationManager) async throws -> [CLLocation]{

//        return try await withCheckedContinuation<LocationContinuation>{ continuation in
//
//        }
    }
}
