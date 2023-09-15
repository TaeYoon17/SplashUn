//
//  CalObservable.swift
//  SplashUn
//
//  Created by 김태윤 on 2023/09/13.
//

import Foundation
class Person{
    var listener:((String)->Void)?
    var name: String{
        didSet{
            print("사용자의 이름이 \(name)로 변경되었습니다.")
            listener?(name)
        }
    }
    init(_ name: String) {
        self.name = name
    }
    func introduce(sample:@escaping (String)->Void){
        print("저는 \(name)입니다.")
        sample(name)
        listener = sample
    }
}










//MARK: -- 구현 목표
class _Person{
    var luckyNumber: Int?
    var listener:(()->Void)?
    var name: String{
        didSet{
            print("사용자의 이름이 \(name)로 변경되었습니다. 행운의 숫자는 \(luckyNumber ?? 0)입니다.")
            listener?()
        }
    }
    init(_ name: String) {
        self.name = name
    }
    func introduce(_ number: Int,sample:@escaping ()->Void){
        print("저는 \(name)입니다 오늘의 행운 버거는 \(number)입니다.")
        sample()
        luckyNumber = number
        listener = sample
    }
}
