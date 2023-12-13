
// --- stubs ---

func sourceInt(_ label: String) -> Int { return 0 }
func sourceString(_ label: String) -> String { return "" }
func sourceUInt8(_ label: String) -> UInt8 { return 0 }
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

  ptr.pointee = sourceString("taintPointer")

  sink(arg: ptr.pointee) // $ tainted=taintPointer
  sink(arg: ptr)
}

func clearPointer2(ptr: UnsafeMutablePointer<String>) {
  sink(arg: ptr.pointee) // $ tainted=taintPointer
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

  sink(arg: ptr.pointee) // $ tainted=taintPointer
  sink(arg: ptr)

  clearPointer2(ptr: ptr)

  sink(arg: ptr.pointee) // $ SPURIOUS: tainted=taintPointer
  sink(arg: ptr)
}

// ---

func taintBuffer(buffer: UnsafeMutableBufferPointer<UInt8>) {
  sink(arg: buffer[0])
  sink(arg: buffer)

  buffer[0] = sourceUInt8("taintBuffer")

  sink(arg: buffer[0]) // $ tainted=taintBuffer
  sink(arg: buffer) // $ tainted=taintBuffer
}

func testMutatingBufferInCall(ptr: UnsafeMutablePointer<UInt8>) {
  let buffer = UnsafeMutableBufferPointer<UInt8>(start: ptr, count: 1000)

  sink(arg: buffer[0])
  sink(arg: buffer)

  taintBuffer(buffer: buffer) // mutates `buffer` contents with a tainted value

  sink(arg: buffer[0]) // $ tainted=taintBuffer
  sink(arg: buffer) // $ tainted=taintBuffer

}

// ---

typealias MyPointer = UnsafeMutablePointer<String>

func taintMyPointer(ptr: MyPointer) {
  sink(arg: ptr.pointee)
  sink(arg: ptr)

  ptr.pointee = sourceString("taintMyPointer")

  sink(arg: ptr.pointee) // $ tainted=taintMyPointer
  sink(arg: ptr)
}

func testMutatingMyPointerInCall(ptr: MyPointer) {
  sink(arg: ptr.pointee)
  sink(arg: ptr)

  taintMyPointer(ptr: ptr) // mutates `ptr` pointee with a tainted value

  sink(arg: ptr.pointee) // $ MISSING: tainted=taintMyPointer
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
  mpc.ptr.pointee = sourceString("writePointerContainer")
  sink(arg: mpc.ptr.pointee) // $ tainted=writePointerContainer
}

func writeGenericPointerContainer<T>(mgpc: MyGenericPointerContainer<T>) {
  mgpc.ptr.pointee = sourceString("writeGenericPointerContainer") as! T
  sink(arg: mgpc.ptr.pointee) // $ tainted=writeGenericPointerContainer
}

func testWritingPointerContainersInCalls(mpc: MyPointerContainer, mgpc: MyGenericPointerContainer<Int>) {
  writePointerContainer(mpc: mpc)
  sink(arg: mpc.ptr.pointee) // $ tainted=writePointerContainer

  writeGenericPointerContainer(mgpc: mgpc)
  sink(arg: mgpc.ptr.pointee) // $ tainted=writeGenericPointerContainer
}

// ---

func testManualMemoryManagement() {
  let i1 = sourceInt("i1")
  let r1 = withUnsafePointer(to: i1, {
    ptr in
    sink(arg: ptr) // $ tainted=i1
    sink(arg: ptr[0]) // $ tainted=i1
    sink(arg: ptr.pointee) // $ MISSING: tainted=i1
    return sourceInt("r1")
  })
  sink(arg: r1) // $ tainted=r1

  var i2 = sourceInt("i2")
  let r2 = withUnsafeMutablePointer(to: &i2, {
    ptr in
    sink(arg: ptr) // $ tainted=i2
    sink(arg: ptr[0]) // $ tainted=i2
    sink(arg: ptr.pointee) // $ MISSING: tainted=i2
    ptr.pointee = sourceInt("i2_overwrite")
    sink(arg: ptr) // $ SPURIOUS: tainted=i2
    sink(arg: ptr[0]) // $ MISSING: tainted=i2_overwrite SPURIOUS: tainted=i2
    sink(arg: ptr.pointee) // $ tainted=i2_overwrite
    return sourceInt("r2")
  })
  sink(arg: r2) // $ tainted=r2
  sink(arg: i2) // $ MISSING: tainted=i2_overwrite SPURIOUS: tainted=i2

  let i3 = sourceInt("i3")
  let r3 = withUnsafeBytes(of: i3, {
    ptr in
    sink(arg: ptr) // $ tainted=i3
    sink(arg: ptr[0]) // $ tainted=i3
    ptr.withMemoryRebound(to: Int.self, {
      buffer in
      sink(arg: buffer) // $ tainted=i3
      sink(arg: buffer[0]) // $ tainted=i3
    })
    let buffer2 = ptr.bindMemory(to: Int.self)
    sink(arg: buffer2) // $ tainted=i3
    sink(arg: buffer2[0]) // $ tainted=i3
    return sourceInt("r3")
  })
  sink(arg: r3) // $ tainted=r3

  var i4 = sourceInt("i4")
  let r4 = withUnsafeMutableBytes(of: &i4, {
    ptr in
    sink(arg: ptr) // $ tainted=i4
    sink(arg: ptr[0]) // $ tainted=i4
    ptr[0] = sourceUInt8("i4_partialwrite")
    sink(arg: ptr) // $ tainted=i4_partialwrite tainted=i4
    sink(arg: ptr[0]) // $ tainted=i4_partialwrite SPURIOUS: tainted=i4
    return sourceInt("r4")
  })
  sink(arg: r4) // $ tainted=r4
  sink(arg: i4) // $ tainted=i4 tainted=i4_partialwrite

  let r5 = withUnsafeTemporaryAllocation(of: Int.self, capacity: 10, {
    buffer in
    sink(arg: buffer)
    sink(arg: buffer[0])
    buffer[0] = sourceInt("buffer5")
    sink(arg: buffer) // $ tainted=buffer5
    sink(arg: buffer[0]) // $ tainted=buffer5
    return sourceInt("r5")
  })
  sink(arg: r5) // $ tainted=r5

  let r6 = withExtendedLifetime(sourceInt("i6"), {
    return sourceInt("r6")
  })
  sink(arg: r6) // $ tainted=r6
}

// ---

func testUnsafePointers() {
  let ptr1 = UnsafeMutablePointer<Int>.allocate(capacity: 1024)
  ptr1.initialize(repeating: 0, count: 1024)
  sink(arg: ptr1[0])
  ptr1.initialize(repeating: sourceInt("ptr1"), count: 1024)
  sink(arg: ptr1[0]) // $ tainted=ptr1

  let ptr2 = UnsafeMutablePointer<Int>.allocate(capacity: 1)
  ptr2.initialize(to: 0)
  sink(arg: ptr2.pointee)
  ptr2.initialize(to: sourceInt("ptr2"))
  sink(arg: ptr2.pointee) // $ MISSING: tainted=ptr2
  sink(arg: ptr2.move()) // $ tainted=ptr2

  let ptr3 = UnsafeMutablePointer<Int>.allocate(capacity: 1024)
  ptr3.initialize(repeating: 0, count: 1024)
  sink(arg: ptr3[0])
  ptr3.assign(repeating: sourceInt("ptr3"), count: 1024)
  sink(arg: ptr3[0]) // $ tainted=ptr3

  let ptr4 = UnsafeMutablePointer<Int>.allocate(capacity: 1024)
  ptr4.initialize(repeating: 0, count: 1024)
  ptr4.update(from: ptr1, count: 512)
  sink(arg: ptr4[0]) // $ tainted=ptr1
}

func testRawPointers() {
  let raw1 = UnsafeMutableRawPointer.allocate(byteCount: 1024, alignment: 4)
  raw1.initializeMemory(as: Int.self, repeating: 0, count: 1024)
  sink(arg: raw1.load(fromByteOffset: 0, as: Int.self))
  raw1.initializeMemory(as: Int.self, repeating: sourceInt("raw1"), count: 1024)
  sink(arg: raw1.load(fromByteOffset: 0, as: Int.self)) // $ tainted=raw1

  let raw2 = UnsafeMutableRawPointer.allocate(byteCount: 1024, alignment: 4)
  raw2.initializeMemory(as: Int.self, repeating: 0, count: 1024)
  //raw2.storeBytes(of: 0, toByteOffset: 0, as: Int.self) --- this line fails on Linux
  sink(arg: raw2.load(fromByteOffset: 0, as: Int.self))
  //raw2.storeBytes(of: sourceInt("raw2"), toByteOffset: 0, as: Int.self) --- this line fails on Linux
  sink(arg: raw2.load(fromByteOffset: 0, as: Int.self)) // $ MISSING: tainted=raw2

  let raw3 = UnsafeRawPointer(raw1)
  sink(arg: raw3.load(fromByteOffset: 0, as: Int.self)) // $ tainted=raw1
  let raw4 = UnsafeRawBufferPointer(start: raw3, count: MemoryLayout<Int>.size)
  sink(arg: raw4[0]) // $ tainted=raw1
}

func testRawPointerConversion() {
  let i1 = sourceInt("i1")
  withUnsafeBytes(of: i1, {
    ptr in // UnsafeRawBufferPointer
    sink(arg: ptr[0]) // $ tainted=i1

    let ptr2 = UnsafeRawBufferPointer(ptr)
    sink(arg: ptr2[0]) // $ tainted=i1

    let ptr3 = UnsafeMutableRawBufferPointer(mutating: ptr)
    sink(arg: ptr3[0]) // $ tainted=i1

    let ptr4 = UnsafeMutableRawBufferPointer.allocate(byteCount: 8, alignment: 0)
    ptr4.copyBytes(from: ptr)
    sink(arg: ptr4[0]) // $ tainted=i1

    let ptr5 = UnsafeMutableRawBufferPointer.allocate(byteCount: 8, alignment: 0)
    ptr5.copyMemory(from: ptr)
    sink(arg: ptr5[0]) // $ tainted=i1

    let i = ptr.load(fromByteOffset: 0, as: Int.self)
    sink(arg: i) // $ tainted=i1
  })

  var i2 = sourceInt("i2")
  withUnsafeMutableBytes(of: &i2, {
    ptr in // UnsafeMutableRawBufferPointer
    sink(arg: ptr[0]) // $ tainted=i2

    let ptr2 = UnsafeRawBufferPointer(ptr)
    sink(arg: ptr2[0]) // $ tainted=i2

    let ptr3 = UnsafeMutableRawBufferPointer(ptr)
    sink(arg: ptr3[0]) // $ tainted=i2
  })
}

func testSlice() {
  let buffer = UnsafeMutableBufferPointer<Int>.allocate(capacity: 1024)
  buffer.initialize(repeating: 0)
  sink(arg: buffer[0])
  buffer[0] = sourceInt("buffer")
  sink(arg: buffer[0]) // $ tainted=buffer

  let slice = Slice(base: buffer, bounds: 0 ..< 10)
  sink(arg: slice[0]) // $ tainted=buffer
  sink(arg: slice.base[0]) // $ MISSING: tainted=buffer

  let buffer2 = UnsafeMutableBufferPointer(rebasing: slice)
  sink(arg: buffer2[0]) // $ tainted=buffer

  let buffer3 = UnsafeMutableBufferPointer<Int>.allocate(capacity: 1024)
  buffer3.initialize(repeating: 0)
  sink(arg: buffer3[0])
  buffer3[10 ..< 20] = buffer[0 ..< 10]
  sink(arg: buffer3[0]) // $ tainted=buffer
}
