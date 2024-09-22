//
//  LRU.swift
//  Test_for_command
//
//  Created by 윤우상 on 8/22/24.
//

import Foundation

protocol LinkedListProtocol {
    func addNode(_ value: String)
    func removeFirstNode()
    func removeNode(_ value: String)
    func checkContain(_ value: String) -> Bool
}

class Node {
    var value: String
    var next: Node?
    
    init(_ value: String, _ next: Node? = nil) {
        self.value = value
        self.next = next
    }
}

class LinkedList: LinkedListProtocol{
    
    var head = Node("Head")
    var checker = Set<String>()
    var size = 0
    var maxSize: Int
    
    init(_ maxSize: Int) {
        self.maxSize = maxSize
    }
    
    func addNode(_ value: String) {
        var current = head
        let newNode = Node(value)
        
        while current.next != nil {
            current = current.next!
        }
        
        current.next = newNode
        self.size += 1
        self.checker.insert(value)
        
    }
    
    func removeFirstNode() {
        if head.next == nil {
            return
        }
        
        let firstNodeValue = head.next!.value
        head.next = head.next?.next
        checker.remove(firstNodeValue)
        size -= 1
        
    }
    
    func removeNode(_ value: String) {
        if head.next == nil {
            return
        }
        
        var current = head
        
        while current.next != nil {
            
            if current.next!.value == value {
                current.next = current.next?.next
                size -= 1
                checker.remove(value)
                return
            }
            current = current.next!
        }
    }
    
    func checkContain(_ value: String) -> Bool{
        return checker.contains(value)
    }
    
    func printList() {
        var current = head
        var arr = [String]()
        
        while current.next != nil {
            arr.append(current.value)
            current = current.next!
        }
        arr.append(current.value)
        print(arr)
    }
    
    func checkSize() -> Bool {
        return self.size < self.maxSize
    }
    
    func isEmpty() -> Bool {
        return self.size == 0
    }
}

func LRU(_ cacheSize: Int, _ cities: [String]) -> Int {
    // 캐시 크기가 0일 때는 모든 요청이 miss로 처리
    if cacheSize == 0 {
        return cities.count * 5
    }
    
    let linkedList = LinkedList(cacheSize)
    
    var hitCount = 0
    var missCount = 0
    
    for city in cities {
        let cityName = city.lowercased()
        // miss의 경우
        if !linkedList.checkContain(cityName) {
            missCount += 5
            
            // linkedList의 크기가 maxsize에 도달
            // 가장 오랫동안 사용하지 않은 노드를 제거하고 새로 추가
            if !linkedList.checkSize() {
                linkedList.removeFirstNode()
            }
            
            linkedList.addNode(cityName)
            
        } else { // hit인 경우
            hitCount += 1
            
            linkedList.removeNode(cityName)
            linkedList.addNode(cityName)
          }
    }
    return hitCount + missCount
}


