//
//  PhotoVC.swift
//  SplashUn
//
//  Created by 김태윤 on 2023/09/12.
//

import UIKit



class PhotoVM{
    var data = Observable(Array<PhotoResult>())
    func searchPhoto(query: String){
        NetworkService.shared.searchPhoto(query: "sky"){[weak self] val in
            guard let val,let self, let result = val.results else {return}
            data.value?.append(contentsOf: result)
        }
    }
    var numberOfRowsInSection:Int{
        data.value?.count ?? 0
    }
    func cellForRowAt(indexPath:IndexPath) -> PhotoResult{
        data.value![indexPath.row]
    }
}

class PhotoVC: UIViewController{
    @IBOutlet var tableView: UITableView!
    let vm = PhotoVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        vm.data.bind {[weak self] _ in
            Task{ @MainActor [weak self] in
                self?.tableView.reloadData()
            }
        }
        vm.searchPhoto(query: "하이욤")
    }

}
extension PhotoVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vm.data.value?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let data = vm.cellForRowAt(indexPath: indexPath)
        cell.textLabel?.text = data.id
        return cell
    }
}
