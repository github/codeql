
struct AutoreleasingUnsafeMutablePointer<Pointee> {
}

class MyClass {
	init() {
		val = 0
	}

	var val: Int
}

func test() {
	var p1: UnsafePointer<Int>
	var p2: UnsafeMutablePointer<UInt8>
	var p3: UnsafeBufferPointer<String>
	var p4: UnsafeMutableBufferPointer<MyClass>
	var p5: UnsafeRawPointer
	var p6: UnsafeMutableRawPointer
	var p7: UnsafeRawBufferPointer
	var p8: UnsafeMutableRawBufferPointer

	var op: OpaquePointer // C-interop
	var aump: AutoreleasingUnsafeMutablePointer<UInt8> // ObjC-interop
	var um: Unmanaged<MyClass> // C-interop
	var cvlp: CVaListPointer // varargs list pointer

	var mbp: ManagedBufferPointer<Int, MyClass>
}
