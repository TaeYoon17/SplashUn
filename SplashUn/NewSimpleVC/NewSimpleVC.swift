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
//    let sectionStore = AnyModelStore<Section>([.init(id: .main, itemsID: (0...30).map{$0}),
//                                               .init(id: .footer, itemsID: (31...50).map{$0})])
//    let itemStore = AnyModelStore<Item>((0...50).map{Item(id: $0)})
    let vm = NewSimpleVM()
    var subsription = Set<AnyCancellable>()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
        configureCollectionView()
        vm.$sectionStore.sink { [ weak self] val in
            Task{
                self?.reloadSnapshot(itemIDs: val.fetchByID(.main).itemsID)
            }
        }.store(in: &subsription)
    }
    var image = UIImage(systemName: "heart")
    func configureCollectionView(){
//        collectionView.prefetchDataSource = self
        collectionView.delegate = self
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell,Item.ID> {[weak self] cell, indexPath, itemIdentifier in
            guard let item = self?.vm.itemStore.fetchByID(itemIdentifier) else {return}
            var config = cell.defaultContentConfiguration()
            config.attributedText = .init(string: item.title, attributes: [
                NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .headline)
            ])
            Task{
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
        }
        dataSource = UICollectionViewDiffableDataSource<Section.ID,Item.ID>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
        dataSource.apply({
            var snapshot = NSDiffableDataSourceSnapshot<Section.ID,Item.ID>()
            snapshot.appendSections([.main])
            snapshot.appendItems(vm.sectionStore.fetchByID(.main).itemsID,toSection: .main)
            return snapshot
        }(),animatingDifferences: true)
    }
    @MainActor func reloadSnapshot(itemIDs: [Item.ID]){
        dataSource.apply({
            var snapshot = NSDiffableDataSourceSnapshot<Section.ID,Item.ID>()
            snapshot.appendSections([.main])
            snapshot.appendItems(itemIDs,toSection: .main)
            return snapshot
        }(),animatingDifferences: true)
    }
}

extension NewSimpleVC: UICollectionViewDataSourcePrefetching,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        //        indexPaths.forEach { indexPath in
        //            guard let data = self.dataSource.itemIdentifier(for: indexPath) else {return}
        //            setPostNeedsUpdate(data)
        //        }
        let datas = indexPaths.compactMap { indexPath in
            self.dataSource.itemIdentifier(for: indexPath)
        }
        setPostNeedsUpdate(itemIDs: datas)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    @MainActor private func setPostNeedsUpdate(_ id: Item.ID) {// id만 알아도 알아서 reconfigure이 가능하다.
        print(#function,"\(id)번째 미리 가져오기")
        var snapshot = self.dataSource.snapshot()
        snapshot.reconfigureItems([id])
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
    @MainActor private func setPostNeedsUpdate(itemIDs: [Item.ID]) {
        var snapshot = self.dataSource.snapshot()
        snapshot.reconfigureItems(itemIDs)
        self.dataSource.apply(snapshot,animatingDifferences: true)
    }
    
}

extension NewSimpleVC{
    static var Layout: UICollectionViewLayout{
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return layout
    }
}
