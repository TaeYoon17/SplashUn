//
//  PhotoVM.swift
//  SplashUn
//
//  Created by 김태윤 on 2023/09/18.
//

import Foundation
class PhotoVM{
    var data = Observable(Array<PhotoResult>())
    @Published var searchText = ""
    func searchPhoto(query: String){
        NetworkService.shared.searchPhoto(query: query){[weak self] val in
            guard let val,let self, let result = val.results else {return}
            data.value = result
        }
    }
    var numberOfRowsInSection:Int{
        data.value?.count ?? 0
    }
    func cellForRowAt(indexPath:IndexPath) -> PhotoResult{
        data.value![indexPath.row]
    }
    func inputText(text: String?){
        guard let text, !text.isEmpty else {
            searchText = "글자가 없어용~"
            searchPhoto(query: "")
            return
        }
        guard text.count < 100 else{
            searchText = "글자 수 선넘넹..."
            return
        }
        searchText = text
        print(text)
        searchPhoto(query: text)
    }
}
