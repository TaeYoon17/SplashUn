//
//  CaculateVC.swift
//  SplashUn
//
//  Created by 김태윤 on 2023/09/13.
//

import UIKit
import Combine
class CaculateVC: UIViewController{
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    let vm = CaculateVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        firstTextField.text = vm.num1.value
        secondTextField.text = vm.num2.value
        firstTextField.addAction(.init(handler: { [weak self] _ in
            self?.vm.num1.value = self?.firstTextField.text
            self?.vm.checkValidate()
        }), for: .editingChanged)
        secondTextField.addAction(.init(handler: { [weak self] _ in
            self?.vm.num2.value = self?.secondTextField.text
            self?.vm.checkValidate()
        }), for: .editingChanged)
        vm.num1.bind {[weak self] number in
            guard let self else {return}
            firstTextField.text = number
        }
        vm.num2.bind {[weak self] number in
            guard let self else { return }
            secondTextField.text = number
        }
        
    }
}
//struct Wow:Subscriber{
//    typealias Input = <#type#>
//
//    typealias Failure = <#type#>
//
//    var combineIdentifier: CombineIdentifier
//
//    func receive(subscription: Subscription) {
//
//    }
//
//
//}
