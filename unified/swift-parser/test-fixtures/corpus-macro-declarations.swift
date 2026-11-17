@attached(extension, conformances: Encodable, Decodable)
public macro Codable() = #externalMacro(module: "Macros", type: "CodableMacro")
@freestanding(expression)
macro stringify<T>(_ value: T) -> (T, String) = #externalMacro(module: "Macros", type: "StringifyMacro")
@attached(member, names: named(deinit), named(subscript(unchecked:)))
macro specialNames() = #externalMacro(module: "Macros", type: "SpecialNames")
struct Declarations {
    #error("unsupported platform")
    #makeMembers()
    static #staticMembers
    public #publicMembers()
    private(set) #settableMembers
    prefix #prefixMembers
}
@_specialize(where T == Int)
@_specialize(exported: true, kind: full, where T == UInt)
func specialized<T>(_ value: T) {}
prefix operator ~
prefix func ~<T>(value: T) -> T { value }
prefix func <<<T>(value: T) -> T { value }
func <<(lhs: Int, rhs: Int) -> Int { lhs }
prefix public func ~~~(x: Bool) {}
postfix public func ^^(x: inout Bool) { x = true }
struct Generic {
    init?<T>(value: T) {}
    init!<T>(forced: T) {}
}
@attached(extension conformances: Sendable) macro extensionRole()
@attached(extension conformances: () -> Element) macro functionRole<Element>()
@attached(extension conformances: repeat each Element) macro packRole<each Element>()
