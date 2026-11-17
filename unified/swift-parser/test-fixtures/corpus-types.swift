protocol Container<Element, Index> {
    associatedtype Element
    associatedtype Index
}
let fn: (@MainActor () -> Void)?
let function = { @MainActor in print("hello") }
func packs<each T>(_ values: repeat each T) -> (repeat each T) {}
func defaultValue(_ iv: Data?=nil) {}
func constants(a: _const Int, b c: _const Int) {}
let constantCallback: (_const Int) -> Void
func ownershipNames(a: borrowing, b: consuming, c: borrowing consuming, d: consuming borrowing) {}
func ownershipTuples(a: (borrowing, consuming) -> (), b: (borrowing consuming, consuming borrowing) -> ()) {}
