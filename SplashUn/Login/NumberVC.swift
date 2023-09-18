//
//  NumberVC.swift
//  SplashUn
//
//  Created by 김태윤 on 2023/09/18.
//

import UIKit
import SnapKit
import Combine
class NumberVC: UIViewController{
    var numberTextField = UITextField()
    var resultLabel = UILabel()
    let vm = NumberVM()
    var subscription = Set<AnyCancellable>()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(numberTextField)
        numberTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(66)
        }
        view.addSubview(resultLabel)
        resultLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        resultLabel.text = "입력하세요"
        numberTextField.placeholder = "안녕하세요"
        numberTextField.addAction(.init(handler: {[weak self] _ in
            guard let self else {return}
            vm.convertNumber(numberText: numberTextField.text)
        }), for: .editingChanged)
        
        vm.convertedNumber.sink {[weak self] data in
            self?.resultLabel.text = data.formatToDecimal ?? "" + "원"
        }.store(in: &subscription)
        vm.$labelText.sink { [weak self] text in
            self?.resultLabel.text = text
        }.store(in: &subscription)
    }
}
class NumberVM{
    var convertedNumber = PassthroughSubject<Int,Never>()
    @Published var labelText = "하이"
    private var originNumber = 0{
        didSet{
            guard originNumber != oldValue else {return}
            _convertNumber()
        }
    }
    private var exchangeRate = 1327{
        didSet{
            guard exchangeRate != oldValue else {return}
            _convertNumber()
        }
    }
    func convertNumber(numberText: String?){
        guard let text = numberText, !text.isEmpty else {
            labelText = "값을 입력하세요"
            return
        }
        guard let textToNumber = Int(text) else {
            labelText = "100만원 이하의 숫자를 입력하세요"
            return
        }
        guard textToNumber > 0, textToNumber <= 100000 else{
            labelText = "환전 범주는 100만원 이하입니다."
            return
        }
        originNumber = textToNumber
    }
    func _convertNumber(){
        convertedNumber.send(originNumber * exchangeRate)
    }
}
extension Int{
    var formatToDecimal:String?{
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(for: self)
    }
}
