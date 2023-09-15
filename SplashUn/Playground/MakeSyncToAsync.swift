//
//  MakeSyncToAsync.swift
//  SplashUn
//
//  Created by 김태윤 on 2023/09/15.
//

import UIKit
import Foundation

extension UIImage{
    var thumbnail: UIImage?{
        get async{
            let size = CGSize(width: 44, height: 44)
            return await self.byPreparingThumbnail(ofSize: size)
        }
    }
}
