import Foundation

struct Counter {
    var value: Int = 0

    mutating func increment(by amount: Int = 1) {
        value += amount
    }
}

let counter = Counter()
