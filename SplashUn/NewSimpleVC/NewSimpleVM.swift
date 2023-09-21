//
//  NewSimpleVM.swift
//  SplashUn
//
//  Created by 김태윤 on 2023/09/18.
//

import Foundation
import Combine
class NewSimpleVM{
    @Published var sectionStore = aModelStore<Section>([.init(id: .main, itemsID: (0...100).map{$0}),.init(id: .footer, itemsID: (101...151).map{$0})])
    @Published var itemStore = aModelStore<Item>((0...151).map{Item(id: $0)})
    init(){
        Task.detached{ [weak self] in
            guard let self else {return}
            try await Task.sleep(for: .seconds(2))
            print("작업 시작")
            itemStore.insertModel(item: .init(id: 200))
            var section = sectionStore.fetchByID(.main)
            section.itemsID.append(200)
            sectionStore.insertModel(item: section)
            print("이거 실행 됨!!")
            print(sectionStore)
        }
    }
}
struct aModelStore<Model: Identifiable>: ModelStore {
    private var models = [Model.ID: Model]()
    init(_ models: [Model]) {
        // 모델의 배열을 [모델 아이디 : 모델] 형식의 Dictionary로 바꿔준다.
        // => 고유한 값에 고유한 데이터만 존재
        self.models = models.groupingByUniqueID()
    }
    
    // 모델의 id를 통해서 저장소에서 Model을 가져온다
    func fetchByID(_ id: Model.ID) -> Model {
        return self.models[id]!
    }
    mutating func insertModel(item: Model){
        models[item.id] = item
    }
    func temp(){
        // Swift 신 기능이 뭘까요..?!
        var isRoot = true; var count = 0; var willExpand = false; var maxDepth = -1
        let bullet =
            if isRoot && (count == 0 || !willExpand) { "" }
            else if count == 0 { "- " }
            else if maxDepth <= 0 { "▹ " }
            else { "▿ " }
    }
}
