//
//  SampleVC.swift
//  SplashUn
//
//  Created by 김태윤 on 2023/09/12.
//

import UIKit

class SmapleVC: UIViewController{
    @IBOutlet weak var tableView: UITableView!
    let vm = SampleVM()
    var rows = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        vm.numberOfRowsInSection.bind {[weak self] val in
            self?.rows = val ?? 0
            self?.tableView.reloadData()
        }
//        vm.numberOfRowsInSection = 10
    }
}
extension SmapleVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { rows }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "sampleCell")!
        var config = cell.defaultContentConfiguration()
        config.text = "하이욤"
        cell.contentConfiguration = config
        return cell
    }
    
    
}
