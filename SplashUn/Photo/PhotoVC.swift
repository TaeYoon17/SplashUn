//
//  PhotoVC.swift
//  SplashUn
//
//  Created by 김태윤 on 2023/09/12.
//

import UIKit
class PhotoVC: UIViewController{
//    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    enum Section{ case main }
    var datasource: UICollectionViewDiffableDataSource<Section,PhotoResult>!
    let vm = PhotoVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        self.view.backgroundColor = .secondarySystemBackground
        setNavigationBar()
        vm.data.bind {[weak self] _ in
            print("bind called")
            self?.applyDataSource()
        }
    }
    func setNavigationBar(){
        let searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "검색어를 입력하세요."
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "최신 트렌드"
        searchController.searchBar.searchTextField
            .addAction(.init(handler: { [weak self] _ in
            self?.vm.inputText(text: searchController.searchBar.text)
            }), for: .editingChanged)
    }
}

extension PhotoVC: UISearchBarDelegate,UISearchControllerDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
}
extension PhotoVC: UICollectionViewDelegate{
    func configureCollectionView(){
        self.collectionView.delegate = self
        self.collectionView.collectionViewLayout = collectionViewLayout
        let registration = UICollectionView.CellRegistration<UICollectionViewListCell,PhotoResult> { cell, indexPath, itemIdentifier in
            var content = UIListContentConfiguration.valueCell()
            content.text = itemIdentifier.resId
            Task{@MainActor [weak self] in
                do{
                    content.image = try await self?.getPhoto(urlStr: itemIdentifier.urls.thumb)
                }catch{
                    print("이미지 가져오기 실패")
                }
                cell.contentConfiguration = content
            }
            
        }
        self.datasource = UICollectionViewDiffableDataSource<Section,PhotoResult>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: itemIdentifier)
        })
    }
    var collectionViewLayout: UICollectionViewLayout{
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config.showsSeparators = false
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return layout
    }
    func applyDataSource(){
        guard let datas = vm.data.value else {return}
        var snapshot = NSDiffableDataSourceSnapshot<Section,PhotoResult>()
        snapshot.appendSections([.main])
        snapshot.appendItems(datas,toSection: .main)
        datasource?.apply(snapshot,animatingDifferences: true)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension PhotoVC{
    func getPhoto(urlStr: String) async throws -> UIImage{
        let errorImage = UIImage(systemName: "heart")!
        guard let url = URL(string: urlStr) else {return errorImage}
        let (data,response) = try await URLSession.shared.data(from: url)
        guard let res = response as? HTTPURLResponse,(200..<300).contains(res.statusCode) else {return errorImage}
        guard let rawImage = UIImage(data: data),
              let image = await rawImage.byPreparingThumbnail(ofSize: .init(width: 60, height: 60))
        else {return errorImage}
        return image
    }
}
