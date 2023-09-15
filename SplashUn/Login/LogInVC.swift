//
//  LogInVC.swift
//  SplashUn
//
//  Created by 김태윤 on 2023/09/12.
//

import UIKit

final class LogInVC: UIViewController{
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var logInBtn: UIButton!
    var vm = LogInVM()
    
    lazy var action: UIAction = .init(handler: {[weak self] _ in
        print("로그인에 성공했기 때문에 얼럿 띄우기")
    })
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.id.value = "b@b.com"
        vm.id.bind {[weak self] text in
            guard let self, (idTextField.text != text) else {return}
            idTextField.text = text
        }
        vm.pw.bind { [weak self] text in
            guard let self,(pwTextField.text != text) else {return}
            pwTextField.text = text
        }
        vm.isValidate.bind { valid in
            self.logInBtn.isEnabled = valid ?? false
        }
        logInBtn.addAction(action, for: .touchUpInside)
        
        idTextField.addAction(.init(handler: { [weak self] _ in
            guard let self, let text = idTextField.text else {return}
            vm.id.value = text
            vm.checkValid()
        }), for: .valueChanged)
        pwTextField.addAction(.init(handler: {[weak self] _ in
            guard let self, let text = pwTextField.text else {return}
            vm.pw.value = text
            vm.checkValid()
        }), for: .valueChanged)
    }
}
