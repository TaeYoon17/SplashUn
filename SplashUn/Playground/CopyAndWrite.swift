//
//  CoW.swift
//  SplashUn
//
//  Created by 김태윤 on 2023/09/15.
//

import UIKit

class CopyAndWriteVC: UIViewController{
    var arr = (0..<100).map{"\($0) 번째"}
    override func viewDidLoad() {
        super.viewDidLoad()
        var nickname = "SeSAC"
        var newNickname = nickname
        var newNickname2 = nickname
        var newNickname3 = nickname
        // 여기까진 모든 변수가 같은 메모리를 공유함
        newNickname3 = "Seoul"
        // 여기 부턴 newNickname3만 따로 논다.
//        print(address(of: &nickname))
        print(address(of: &nickname))
        print(address(of: &arr))
        var arr2 = arr
        print(address(of: arr2))
        arr2[1] = "굳굳굳"
        print(address(of: arr2))
    }
    
    func address(of object: UnsafeRawPointer) -> String{
        let address = Int(bitPattern: object)
        return String(format: "%p", address)
    }
}
/// Copy on Write -> Collection Type에서 주로 활용
