//
//  SplashVC.swift
//  SplashUn
//
//  Created by 김태윤 on 2023/09/21.
//

import UIKit
import SnapKit

class SplashVC: UIViewController{
    lazy var collectionView = UICollectionView(frame: .zero,collectionViewLayout: {
        let config = UICollectionLayoutListConfiguration.init(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return layout
    }())
    var dataSource: UICollectionViewDiffableDataSource<String,String>!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHiearachy()
        configureView()
        configureCollectionView()
    }
    func configureView(){
        
    }
    func configureHiearachy(){
        view.addSubview(collectionView)
    }
    func configureLayout(){
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
extension SplashVC: UICollectionViewDelegate,UIScrollViewDelegate{
    func configureCollectionView(){
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell,String> { cell, indexPath, itemIdentifier in
            var config = cell.defaultContentConfiguration()
            config.text = itemIdentifier
            cell.contentConfiguration = config
        }
        dataSource = UICollectionViewDiffableDataSource<String,String>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        })
    }
}
