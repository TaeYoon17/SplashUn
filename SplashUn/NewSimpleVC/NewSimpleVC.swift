//
//  NewSimpleVC.swift
//  SplashUn
//
//  Created by 김태윤 on 2023/09/14.
//

import SnapKit
import UIKit
import Combine
struct Section:Identifiable{
    enum Identifier:String, CaseIterable{
        case main, footer
    }
    var id: Identifier
    var itemsID:[Int]
}
struct Item:Identifiable{
    var id:Int
    var title: String
    
    init(id: Int) {
        self.id = id
        self.title = "\(id) 번"
    }
}
class NewSimpleVC: UIViewController{
    var dataSource: UICollectionViewDiffableDataSource<Section.ID,Item.ID>!
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: Layout)
    let sectionStore = AnyModelStore<Section>([.init(id: .main, itemsID: (0...30).map{$0}),
                                               .init(id: .footer, itemsID: (31...50).map{$0})])
    let itemStore = AnyModelStore<Item>((0...50).map{Item(id: $0)})
    var subsription = Set<AnyCancellable>()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        configureCollectionView()
        Task.detached(priority: .background){ [weak self] in
            guard let self else {return}
            try await Task.sleep(for: .seconds(2))
            print("작업 시작")
            itemStore.insertModel(item: .init(id: 31))
            var section = sectionStore.fetchByID(.main)
            section.itemsID.append(31)
            sectionStore.insertModel(item: section)
            print("이거 실행 됨!!")
            // 함수 자체를 mainActor로 지정해서 Task 내부는 background thread지만 이 함수는 main thread에서 실행된다.
            await self.reloadSnapshot()
        }
    }
    var image = UIImage(systemName: "heart")
    func configureCollectionView(){
        collectionView.prefetchDataSource = self
        collectionView.delegate = self
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell,Item.ID> {[weak self] cell, indexPath, itemIdentifier in
            guard let item = self?.itemStore.fetchByID(itemIdentifier) else {return}
            var config = cell.defaultContentConfiguration()
            config.attributedText = .init(string: item.title, attributes: [
                NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .headline)
            ])
            
            var accessoryConfig = UICellAccessory.CustomViewConfiguration(customView: {
                var isLike = true
               let button = UIButton()
                button.tintColor = .systemRed
                button.setImage(.init(systemName: isLike ? "heart.fill" : "heart"), for: .normal)
                button.addAction(.init(handler: {[weak self] _ in
                    isLike.toggle()
                    button.setImage(.init(systemName: isLike ? "heart.fill" : "heart"), for: .normal)
                }), for: .touchUpInside)
                
            return button
            }(), placement: .leading())
            let accessory: UICellAccessory = .customView(configuration: accessoryConfig)
            cell.accessories = [accessory]
            cell.contentConfiguration = config
        }
        dataSource = UICollectionViewDiffableDataSource<Section.ID,Item.ID>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
        dataSource.apply({
            var snapshot = NSDiffableDataSourceSnapshot<Section.ID,Item.ID>()
            snapshot.appendSections([.main])
            snapshot.appendItems(sectionStore.fetchByID(.main).itemsID,toSection: .main)
            return snapshot
        }(),animatingDifferences: true)
    }
    @MainActor func reloadSnapshot(){
        dataSource.apply({
            var snapshot = NSDiffableDataSourceSnapshot<Section.ID,Item.ID>()
            snapshot.appendSections([.main])
            snapshot.appendItems(sectionStore.fetchByID(.main).itemsID,toSection: .main)
            return snapshot
        }(),animatingDifferences: true)
    }
}

extension NewSimpleVC: UICollectionViewDataSourcePrefetching,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            guard let data = self.dataSource.itemIdentifier(for: indexPath) else {return}
            setPostNeedsUpdate(data)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    private func setPostNeedsUpdate(_ id: Item.ID) {// id만 알아도 알아서 reconfigure이 가능하다.
        print(#function,"\(id)번째 미리 가져오기")
        var snapshot = self.dataSource.snapshot()
        snapshot.reconfigureItems([id])
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}

extension NewSimpleVC{
    static var Layout: UICollectionViewLayout{
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return layout
    }
}
