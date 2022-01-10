//
//  Transaction.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 10.01.2022.
//

import Foundation

struct Transaction {
    let queue: DispatchQueue

    func read<T>(_ value: @autoclosure () -> T) -> T {
        return read(block: value)
    }

    func read<T>(block: () -> T) -> T {
        return queue.sync {
            block()
        }
    }
    
    func write(block: @escaping () -> Void) {
        queue.async(flags: .barrier) {
            block()
        }
    }
}

/// Usage example
/*
 class Counter {
     private static let queue = DispatchQueue(label: "counter", qos: .background)
     private var count = 0
     
     var tx: Transaction {
         return Transaction(queue: Counter.queue)
     }
     
     func increment() {
         tx.write {
             self.count += 1
         }
     }
     
     var currentValue: Int {
         return tx.read(count)
     }
 }
 */
