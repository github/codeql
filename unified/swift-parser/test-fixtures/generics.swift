typealias Nested = Box<Box<Int>>
let instance = Box<Int>(value: 1)
extension Box where T: Equatable {
    func compare<U>(_ value: U) -> Bool where U == T {
        return value == self.value
    }
}
let object = value as? ProtocolA & ProtocolB
