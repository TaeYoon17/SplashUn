//
//  String+Extension.swift
//  SplashUn
//
//  Created by 김태윤 on 2023/09/11.
//

import Foundation

extension String{
    
    var localized: String{ NSLocalizedString(self, comment: "") }

    func localized(number:Int) -> String{
        String(format:self.localized,number)
    }
}
