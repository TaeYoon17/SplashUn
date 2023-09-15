//
//  ObserverPattern.swift
//  SplashUn
//
//  Created by 김태윤 on 2023/09/12.
//

import Foundation

protocol Subject:AnyObject{
    associatedtype T where T: Observer
    var items:[T] {get set}
    func register(item: T)
    func unregister(item: T)
    func notifyObservers()
    func getUpdate(item: T) -> Any
}
extension Subject{
    func register(item: T) {
        if !items.contains(where: { $0.id == item.id }){
            items.append(item)
        }
    }
    func unregister(item: T){
        items.removeAll { $0.id == item.id }
    }
    func notifyObservers(){
        items.forEach({$0.update()})
    }
}
protocol Observer: Identifiable,AnyObject{
    var id:UUID {get set}
    func update()
}
class TopicSubscriber:Observer{
    var id: UUID = UUID()
    func update() {
        print("update")
    }
}
class Topic: Subject{
    var items: [TopicSubscriber] = []
    var message:String = ""
    func getUpdate(item: TopicSubscriber) -> Any {
        message
    }
}
