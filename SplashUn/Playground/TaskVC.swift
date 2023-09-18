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
//    func sharedPostsFromPeer() async throws -> []{
//        try await withCheckedThrowingContinuation({ continuation in
//            self.locationContinuation = continuation
//            self.locationManager.
//        })
//    }
    // 간단하게 AsyncSecquence 만드는 방법 (js 제네레이터와 비슷함)
    let digits = AsyncStream<Int> { continuation in
        continuation.onTermination = { termination in
            switch termination{
            case .cancelled: print("cancelled")
            case .finished: print("finished")
            @unknown default:
                fatalError("추가 된 케이스 등장")
            }
        }
        for digit in 1...10{
            continuation.yield(digit)
        }
        continuation.finish()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(100)
        }
        let numLoader = PicturesLoader(nums: [1,2,3,4,5,6])
//        print("Num Loader 시작")
        Task{
            do{
                //                for try await num in numLoader{
                //                    print(num)
                //                }
                //                 이미 에러를 던져서 작동하지 않음
                //                try await numLoader.next()
                var nums = try await asyncNumber(loader: numLoader)
//                print(nums)
            }catch{
                print("This is Error")
                print(error)
            }
        }
        linkedListAsyncStream()
    }
    func asyncNumber(loader:PicturesLoader) async throws -> [Int] {
        var nums:[Int] = []
 
        for try await num in loader{
            nums.append(num)
        }
        let num = try await loader.next()
        print(num)
        return nums
    }
    
    func fetchUsingAsync(){
        Task{[weak self] in guard let self else {return}
            do{
                imageView.image = try await fetchThumbnail(for: urlStr)
            }catch{
                print(error)
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

extension TaskVC{
    //MARK: -- 외부에서 값을 받아서 AsyncStream 만들기
    func numsToDigitArray(nums: [Int],check:(Int)->Bool,failureHandler: (()->Void))->AsyncStream<Int>{
        return AsyncStream { continuation in
            for v in nums{
                if check(v){ continuation.yield(v) }
                else {failureHandler()}
            }
        }
    }
    //MARK: -- 연결 리스트 AsyncStream으로 구현하기, 한번에 전송하고 싶은 list의 계수를 설정할 수 있다.
    func linkedListAsyncStream(singleListCount: Int = 2){
        print(#function)
        // enum을 재귀적으로 관리하기 위한 키워드 indirect
        indirect enum LinkedListNode<T>{
            case value(element: T, next: LinkedListNode<T>)
            case end
        }
        let lists = ["A","B","C","D","E","F","G"].reversed().map{$0}.mapWithPrev { str, prev in
            LinkedListNode.value(element: str, next: prev ?? .end)
        }
        var generator = AsyncStream<[String]>{[weak self] continuation in
            var iter = lists.last!
            var num = 0
            var datas: [String] = []
            while true{
                switch iter{
                case .end:
                    if !datas.isEmpty{ continuation.yield(datas) }
                    continuation.finish()
                    return
                case .value(element: let val, next: let next):
                    if datas.count > singleListCount {
                        continuation.yield(datas)
                        num = 0
                        datas.removeAll()
                    }else{
                        num += 1
                        datas.append(val)
                        iter = next
                    }
                }
            }
        }
        var iter = generator.makeAsyncIterator()
        Task{
            while let val = await iter.next(){
                print(val)
            }
        }
    }
    // Legacy...
    //        let sixth = LinkedListNode.value(element: "G", next: .end)
    //        let fifth = LinkedListNode.value(element: "F", next: sixth)
    //        let fourth = LinkedListNode.value(element: "E", next: fifth)
    //        let third = LinkedListNode.value(element: "D", next: fourth)
    //        let second = LinkedListNode.value(element: "C", next: third)
    //        let first = LinkedListNode.value(element: "B", next: second)
    //        let head = LinkedListNode.value(element: "A", next: first)
}


/// Build your own AsyncSequence
/// 1. Callbacks
/// 2. Some Delegates
//MARK: -- AsyncSequence 만들기
enum AsyncError: Error{
    case next
}
class PicturesLoader: AsyncSequence, AsyncIteratorProtocol{
    typealias AsyncIterator = PicturesLoader
    typealias Element = Int
    var nums: [Int] = []
    init(nums:[Int]){
        self.nums = nums
    }
    func makeAsyncIterator() -> PicturesLoader { self }
    
    func next() async throws -> Int? {
        nums.popLast()
    }
}
extension Array{
    func mapWithPrev<U>(hanlder:(Element,U?)->U) -> [U]{
        var newList:[U] = []
        var flag = false
        var prev:U? = nil
        self.forEach { element in
            let now = hanlder(element,prev)
            newList.append(now)
            prev = now
        }
        return newList
    }
}
