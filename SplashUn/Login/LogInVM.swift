//
//  LogInVM.swift
//  SplashUn
//
//  Created by 김태윤 on 2023/09/12.
//

import Foundation

class LogInVM{
    var id = Observable("a@a.com")
    var pw = Observable("1234")
    var isValidate = Observable(false)
    
    func checkValid(){
        if id.value?.count ?? -1 >= 6 && pw.value == "1234"{
            isValidate.value = true
        }else{
            isValidate.value = false
        }
    }
}
