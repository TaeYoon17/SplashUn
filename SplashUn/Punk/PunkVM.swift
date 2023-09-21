//
//  PunkVM.swift
//  SplashUn
//
//  Created by 김태윤 on 2023/09/21.
//

import Foundation
import Combine
class PunkVM{
    @Published var data: [PunkResponse] = []
    var number = 1
    init() {
        Task{ await requestDatas() }
    }
    func requestDatas() async {
        do{
            let responses : [PunkResponse] = try await NetworkService.shared.request(type: [PunkResponse].self, router: PunkRouter.multi(page: number, per: 5))
            number += 1
            data.append(contentsOf:responses)
        }catch{
            print(error)
        }
    }
}
