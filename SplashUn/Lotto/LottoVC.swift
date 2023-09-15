//
//  LottoVC.swift
//  SplashUn
//
//  Created by 김태윤 on 2023/09/14.
//

import SnapKit
import UIKit

final class LottoVC: UIViewController{
    let mainView = LottoView()
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
    }
    func setNavigation(){
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "\(0)회차 로또 번호"
    }
}
