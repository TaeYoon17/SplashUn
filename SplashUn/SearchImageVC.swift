//
//  SearchImageVC.swift
//  SplashUn
//
//  Created by 김태윤 on 2023/09/11.
//

import UIKit
class SearchImageVC: UIViewController{
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        searchTextField.placeholder = NSLocalizedString("nickname_placeholder", comment: "")
        searchTextField.placeholder = "nickname_placeholder".localized
        label.text = "age_result".localized(number: 10)
        
        // cmd ctrl e
        let bar = UISearchBar()
        bar.text = "hello world"
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}
