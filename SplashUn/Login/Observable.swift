//
//  Observable.swift
//  SplashUn
//
//  Created by 김태윤 on 2023/09/12.
//

import Foundation
class Observable<T>{
    private var listener: ((T?) -> Void)? = { nickname in
        print(nickname)
    }
    var value: T?{
        didSet{
            print("didSet",value)
            listener?(value)
        }
    }
    init(_ value: T) {
        self.value = value
    }
    func bind(_ closure:@escaping (T?) -> Void){
        print(#function)
        closure(value)
        listener = closure
    }
}
