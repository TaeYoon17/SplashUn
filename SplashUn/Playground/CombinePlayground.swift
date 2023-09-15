//
//  CombinePlayground.swift
//  SplashUn
//
//  Created by 김태윤 on 2023/09/15.
//

import Foundation
import Combine
//MARK: --  자신의 Output이 Data 구조체인 AnyPublisher만이 이 함수를 사용할 수 있다.
// 데이터 타입을 지닌 AnyPublisher를 다른 타입을 지닌 AnyPublisher로 바꾸어 주는 메서드
extension AnyPublisher where Output == Data{
    func receive<T>(type: T.Type) -> AnyPublisher<T?,Error> where T: Codable {
        let res: AnyPublisher<T?,Error> = self
                    .tryMap({ data -> T?  in
                        try JSONDecoder().decode(type, from: data )
                    })
                    .eraseToAnyPublisher()
        return res
    }
}
