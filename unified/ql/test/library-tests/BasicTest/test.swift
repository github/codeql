import Foundation

// Generic struct with type constraint
struct Container<T: Equatable> {
    var items: [T] = []

    mutating func add(_ item: T) {
        items.append(item)
    }

    func contains(_ item: T) -> Bool {
        return items.contains(item)
    }
}

// Protocol with associated type
protocol DataSource {
    associatedtype Element
    var count: Int { get }
    func item(at index: Int) -> Element?
}

// Generic function with where clause
func merge<T: Collection>(_ first: T, _ second: T) -> [T.Element] where T.Element: Equatable {
    var result = Array(first)
    for item in second {
        if !result.contains(item) {
            result.append(item)
        }
    }
    return result
}

// Class with inheritance and computed properties
class DataManager<T>: DataSource {
    typealias Element = T
    private var data: [T] = []

    var count: Int {
        return data.count
    }

    var isEmpty: Bool {
        data.isEmpty
    }

    func item(at index: Int) -> T? {
        guard index >= 0 && index < data.count else { return nil }
        return data[index]
    }

    func add(_ item: T) {
        data.append(item)
    }
}

// Enum with associated values
enum Result<Success, Failure: Error> {
    case success(Success)
    case failure(Failure)

    func map<U>(_ transform: (Success) -> U) -> Result<U, Failure> {
        switch self {
        case .success(let value):
            return .success(transform(value))
        case .failure(let error):
            return .failure(error)
        }
    }
}

// Extension with generic constraints
extension Array where Element: Comparable {
    func isSorted() -> Bool {
        for i in 0..<(count - 1) {
            if self[i] > self[i + 1] {
                return false
            }
        }
        return true
    }
}

// Higher-order function
func combine<T>(_ values: [T], transform: (T, T) -> T) -> T? {
    guard !values.isEmpty else { return nil }
    return values.dropFirst().reduce(values[0], transform)
}
