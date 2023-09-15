//
//  CaculateVM.swift
//  SplashUn
//
//  Created by 김태윤 on 2023/09/13.
//

import Foundation
import UIKit
enum OperandType{
    case binary
    case unary
}
class CaculateVM{
    var num1 = Observable("-1")
//    var num1:String{
//        get{ String(_num1.value) }
//        set{ _num1.value = Int(newValue)! }
//    }
    var num2 = Observable("-1")
    var isValidate = Observable(false)
    var outputNum = Observable("")
    
    func checkValidate(){
        isValidate.value = Int(num1.value ?? "") != nil && Int(num2.value ?? "") != nil
    }
    
    func caculate(){
        guard let first = num1.value, let convertFirst = Int(first) else {return}
        guard let second = num2.value, let convertSecond = Int(second) else {return}
        outputNum.value = "결과는 \(convertFirst + convertSecond) 입니다."
    }
}
