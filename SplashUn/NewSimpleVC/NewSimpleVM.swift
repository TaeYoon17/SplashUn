//
//  NewSimpleVM.swift
//  SplashUn
//
//  Created by 김태윤 on 2023/09/18.
//

import Foundation
import Combine
class NewSimpleVM{
    var sectionStore = AnyModelStore<Section>([.init(id: .main, itemsID: (0...30).map{$0}),.init(id: .footer, itemsID: (31...50).map{$0})])
    @Published var itemStore = AnyModelStore<Item>((0...50).map{Item(id: $0)})
    init(){
        Task{ [weak self] in
            guard let self else {return}
            try await Task.sleep(for: .seconds(2))
            print("작업 시작")
            itemStore.insertModel(item: .init(id: 51))
            var section = sectionStore.fetchByID(.main)
            section.itemsID.append(51)
            print("이거 실행 됨!!")
            print(sectionStore)
        }
    }
}
class SectionStore: AnyModelStore<Section>{
    var sectionPassthrough = PassthroughSubject<Section,Never>()
}
