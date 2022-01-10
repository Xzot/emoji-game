//
//  ThreadSafe.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 10.01.2022.
//

import Foundation

@propertyWrapper
final class ThreadSafe<Value> {
    private let queue: DispatchQueue
    private var value: Value

    init(wrappedValue: Value, queue: DispatchQueue) {
        self.queue = queue
        self.value = wrappedValue
    }

    var wrappedValue: Value {
        get { queue.sync { value } }
        set { queue.async(flags: .barrier) { self.value = newValue } }
    }

    func mutate(_ mutation: (inout Value) -> Void) {
        return queue.sync {
            mutation(&value)
        }
    }
}

/// Usage example
/*
 class Counter {
     private static let queue = DispatchQueue(label: "counter", qos: .background)

     @ThreadSafe(wrappedValue: 0, queue: Counter.queue)
     private(set) var count

     func increment() {
         _count.mutate { $0 += 1 }
     }
 }
 */
