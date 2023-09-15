//
//  SaMpleVM.swift
//  SplashUn
//
//  Created by 김태윤 on 2023/09/12.
//

import Foundation
struct User{
    var name:String
    var age: Int
    var introduce: String{ "\(name) \(age)살" }
}
struct SmapleModel {
    var list = [User(name: "Hue", age: 23),User(name: "Jack", age: 21),User(name: "Bran", age: 20),User(name: "KkJong", age: 20)]
}
class SampleVM{
    private var sampleModel = SmapleModel()
    lazy var numberOfRowsInSection:Observable = Observable(sampleModel.list.count)
    
    func tableView(cellForRowAt indexPath: IndexPath) -> User{
        sampleModel.list[indexPath.row]
    }
}
