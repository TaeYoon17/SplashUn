//
//  LottoView.swift
//  SplashUn
//
//  Created by 김태윤 on 2023/09/14.
//

import SnapKit
import UIKit

class LottoView: UIView{
    let label = {
        let v = UILabel()
        v.font = .preferredFont(forTextStyle: .title1)
    }()
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) {
        fatalError("Should not use storyboard")
    }
}
