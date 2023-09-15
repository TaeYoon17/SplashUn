//
//  TapAnimationView.swift
//  SplashUn
//
//  Created by 김태윤 on 2023/09/13.
//

import UIKit
class TapAnimationView: UIView{
    @MainActor override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        Task{
            self.alpha = 1.0
            UIView.animate(withDuration: 0.4,delay: 0,options: .curveLinear) {
                self.alpha = 0.5
            }
        }
    }
    @MainActor override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        Task{
            self.alpha = 0.5
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveLinear) {
                self.alpha = 1.0
            }
        }
    }
    @MainActor override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        Task{
            self.alpha = 0.5
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveLinear) {
                self.alpha = 1.0
            }

        }
    }
}
