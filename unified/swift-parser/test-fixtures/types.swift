typealias Handler = (Int, String?) throws -> Void
struct Box<T: Equatable>: CustomStringConvertible {
    var value: T
    var history: [String: [T]] = [:]
    var callback: (@escaping (T) -> Void)?
    var description: String { return "box" }
    mutating func update(_ next: T) -> T {
        value = next
        return value
    }
}
enum Choice {
    case none, some(Int)
}
protocol Object: class {
    var name: String { get set }
}
