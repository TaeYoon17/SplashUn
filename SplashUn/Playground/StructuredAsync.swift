//
//  StructuredAsync.swift
//  SplashUn
//
//  Created by 김태윤 on 2023/09/15.
//

import Foundation
import UIKit
func fetchOneThumbnail(withID: String) async throws -> UIImage{
    UIImage(systemName: "heart")!
}
 
func fetchThumbnails(for ids: [String]) async throws -> [String: UIImage] {
    var thumbnails: [String: UIImage] = [:]
    try await withThrowingTaskGroup(of: (String, UIImage).self) { group in
        for id in ids {
// Legacy...
//            group.async {
//                return (id, try await fetchOneThumbnail(withID: id))
//            }
            // Task 그룹에 해야할 작업들을 추가시킨다.
            group.addTask {
                return (id, try await fetchOneThumbnail(withID: id))
            }
        }
        // Obtain results from the child tasks, sequentially, in order of completion.
        for try await (id, thumbnail) in group {
            thumbnails[id] = thumbnail
        }
    }
    return thumbnails
}
