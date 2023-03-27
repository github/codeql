
// --- stubs ---

func sourceString() -> String { return "" }
func sourceUInt8() -> UInt8 { return 0 }
func sink(arg: Any) {}

// --- tests ---

func clearPointer1(ptr: UnsafeMutablePointer<String>) {
  ptr.pointee = "abc"

  sink(arg: ptr.pointee)
  sink(arg: ptr)
}

func taintPointer(ptr: UnsafeMutablePointer<String>) {
  sink(arg: ptr.pointee)
  sink(arg: ptr)

  ptr.pointee = sourceString()

  sink(arg: ptr.pointee) // $ tainted=21
  sink(arg: ptr)
}

func clearPointer2(ptr: UnsafeMutablePointer<String>) {
  sink(arg: ptr.pointee) // $ tainted=21
  sink(arg: ptr)

  ptr.pointee = "abc"

  sink(arg: ptr.pointee)
  sink(arg: ptr)
}

func testMutatingPointerInCall(ptr: UnsafeMutablePointer<String>) {
  clearPointer1(ptr: ptr)

  sink(arg: ptr.pointee)
  sink(arg: ptr)

  taintPointer(ptr: ptr) // mutates `ptr` pointee with a tainted value

  sink(arg: ptr.pointee) // $ tainted=21
  sink(arg: ptr)

  clearPointer2(ptr: ptr)

  sink(arg: ptr.pointee) // $ SPURIOUS: tainted=21
  sink(arg: ptr)
}

// ---

func taintBuffer(buffer: UnsafeMutableBufferPointer<UInt8>) {
  sink(arg: buffer[0])
  sink(arg: buffer)

  buffer[0] = sourceUInt8()

  sink(arg: buffer[0]) // $ MISSING: tainted=60
  sink(arg: buffer)
}

func testMutatingBufferInCall(ptr: UnsafeMutablePointer<UInt8>) {
  let buffer = UnsafeMutableBufferPointer<UInt8>(start: ptr, count: 1000)

  sink(arg: buffer[0])
  sink(arg: buffer)

  taintBuffer(buffer: buffer) // mutates `buffer` contents with a tainted value

  sink(arg: buffer[0]) // $ MISSING: tainted=60
  sink(arg: buffer)

}

// ---

typealias MyPointer = UnsafeMutablePointer<String>

func taintMyPointer(ptr: MyPointer) {
  sink(arg: ptr.pointee)
  sink(arg: ptr)

  ptr.pointee = sourceString()

  sink(arg: ptr.pointee) // $ tainted=87
  sink(arg: ptr)
}

func testMutatingMyPointerInCall(ptr: MyPointer) {
  sink(arg: ptr.pointee)
  sink(arg: ptr)

  taintMyPointer(ptr: ptr) // mutates `ptr` pointee with a tainted value

  sink(arg: ptr.pointee) // $ MISSING: tainted=87
  sink(arg: ptr)
}

// ---

struct MyPointerContainer {
  var ptr: UnsafeMutablePointer<String>
}

struct MyGenericPointerContainer<T> {
  var ptr: UnsafeMutablePointer<T>
}

func writePointerContainer(mpc: MyPointerContainer) {
  mpc.ptr.pointee = sourceString()
  sink(arg: mpc.ptr.pointee) // $ tainted=114
}

func writeGenericPointerContainer<T>(mgpc: MyGenericPointerContainer<T>) {
  mgpc.ptr.pointee = sourceString() as! T
  sink(arg: mgpc.ptr.pointee) // $ tainted=119
}

func testWritingPointerContainersInCalls(mpc: MyPointerContainer, mgpc: MyGenericPointerContainer<Int>) {
  writePointerContainer(mpc: mpc)
  sink(arg: mpc.ptr.pointee) // $ tainted=114

  writeGenericPointerContainer(mgpc: mgpc)
  sink(arg: mgpc.ptr.pointee) // $ tainted=119
}
