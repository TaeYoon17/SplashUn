//
//  PunkVC.swift
//  SplashUn
//
//  Created by 김태윤 on 2023/09/21.
//

import SnapKit
import Combine
import UIKit
import Kingfisher
final class PunkVC: UIViewController{
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    enum Section{ case main }
    var dataSource: UICollectionViewDiffableDataSource<Section,PunkResponse>!
    let prevBtn = {
        let btn = UIButton()
        btn.configuration = UIButton.moveBtnConfig(title: "prev" .uppercased())
        return btn
    }()
    let nextBtn = {
        let btn = UIButton()
        btn.configuration = UIButton.moveBtnConfig(title: "next".uppercased())
        return btn
    }()
    
    let vm = PunkVM()
    var subscription = Set<AnyCancellable>()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setNavigation()
        configureHierachy()
        configureLayout()
        configureView()
        configureCollectionView()
    }
    func setNavigation(){
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "오늘의 추천 맥주"
    }
    func configureHierachy(){
        [collectionView,prevBtn,nextBtn].forEach{view.addSubview($0)}
    }
    func configureLayout(){
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(prevBtn.snp.top).offset(-20)
        }
        prevBtn.snp.makeConstraints { make in
            make.leading.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(60)
            make.width.equalTo(nextBtn)
            make.trailing.equalTo(nextBtn.snp.leading).offset(-20)
        }
        nextBtn.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(prevBtn)
            make.width.equalTo(prevBtn)
        }
    }
    func configureView(){
        vm.$data.receive(on: DispatchQueue.main).sink {[weak self] response in
            print(response.count)
            var snapshot = NSDiffableDataSourceSnapshot<Section,PunkResponse>()
            snapshot.appendSections([.main])
            snapshot.appendItems(response, toSection: .main)
            self?.dataSource?.apply(snapshot,animatingDifferences: true)
        }.store(in: &subscription)
        prevBtn.addAction(.init(handler: { [weak self] _ in
            print("이전 버튼 클릭!!")
        }), for: .touchUpInside)
        nextBtn.addAction(.init(handler: { [weak self] _ in
            print("이후 버튼 클릭!!")
        }), for: .touchUpInside)
    }
}
extension PunkVC:UICollectionViewDelegate,UICollectionViewDataSourcePrefetching{

    
    func configureCollectionView(){
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        collectionView.backgroundColor = .systemBackground
        collectionView.alwaysBounceVertical = false
        let registration = UICollectionView.CellRegistration<PunkCell,PunkResponse> { cell, indexPath, itemIdentifier in
            cell.descriptionLabel.text = itemIdentifier.description
            cell.titleLabel.text = itemIdentifier.name
            cell.imageView.kf.setImage(with: URL( string: itemIdentifier.imageURL)!)
        }
        dataSource = UICollectionViewDiffableDataSource<Section,PunkResponse>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: itemIdentifier)
        })
    }
    var layout: UICollectionViewCompositionalLayout{
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [ item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if let lastIndex = indexPaths.last?.row{
            if lastIndex == (vm.number * 5) - 6{
                Task{ await vm.requestDatas() }
            }
        }
    }
}

fileprivate extension UIButton{
    static func moveBtnConfig(title:String) -> UIButton.Configuration{
        var config = UIButton.Configuration.filled()
        config.attributedTitle = AttributedString(title.uppercased(), attributes: .init([
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 28, weight: .bold)
        ]))
        return config
    }
}
