
func freeFunction() {}

protocol Protocol1 {
	associatedtype Associated = Int
	func foo() -> Int
}
extension Protocol1 {
	func foo() -> Int { return 1 /* default */ }
}

class Class1: Protocol1 {
	init() {}
	deinit {}

	let constantField: Int = 42
	var mutableField: Int? = nil
	static let staticConstantField: Int = 42
	static var staticMutableField: Int? = nil

	class var gettableClassField: Int {
		return 42 /* get-Accessor */
	}
	var observableField: Int = 1 {
		willSet { /* willSet-Accessor */ }
		didSet { /* didSet-Accessor */ }
	}

	subscript(_ index: Int) -> Int {
		get {
			return mutableField ?? 0 /* get-Accessor */
		}
		set(value) {
			mutableField = index + value /* set-Accessor */
		}
	}

	func instanceMethod() {}
	static func staticMethod() {}
	class func classMethod() {}

	// Type members:

	typealias Associated = Int

	// Nominal types:

	class NestedClass: Protocol1 {
		func foo() -> Int { 2 }
	}
	struct NestedStruct: Protocol1 {
		func foo() -> Int { 3 }
	}
	enum NestedEnum: Protocol1 {
		case case1
		case case2
		func foo() -> Int { 4 }
	}
}
