
// --- stubs ---

// --- tests ---

func source() -> UInt8 { return 0; }
func source2() -> Int { return 0; }
func sink(arg: Any) {}

func taintThroughClosurePointer() {
  var myArray1: [UInt8] = [1, 2, 3, 4]

  myArray1[0] = source()
  sink(arg: myArray1) // $ tainted=13
  sink(arg: myArray1[0]) // $ tainted=13
  let return1 = myArray1.withUnsafeBytes({
    ptr1 in
    sink(arg: ptr1) // $ tainted=13
    sink(arg: ptr1[0]) // $ tainted=13
    return source()
  })
  sink(arg: return1) // $ tainted=20

  // ---

  var myArray2: [UInt8] = [1, 2, 3, 4]

  myArray2[0] = source()
  sink(arg: myArray2) // $ tainted=28
  sink(arg: myArray2[0]) // $ tainted=28
  let return2 = myArray2.withUnsafeBufferPointer({
    ptr2 in
    sink(arg: ptr2) // $ tainted=28
    sink(arg: ptr2[0]) // $ tainted=28
    return source()
  })
  sink(arg: return2) // $ tainted=35
}

func taintThroughMutablePointer() {
  var myArray1: [UInt8] = [1, 2, 3, 4]

  sink(arg: myArray1)
  sink(arg: myArray1[0])
  let return1 = myArray1.withUnsafeMutableBufferPointer({
    buffer in
    buffer.update(repeating: source())
    sink(arg: buffer) // $ tainted=47
    sink(arg: buffer[0]) // $ tainted=47
    sink(arg: buffer.baseAddress!.pointee) // $ MISSING: tainted=47
    return source()
  })
  sink(arg: return1) // $ tainted=51
  sink(arg: myArray1) // $ tainted=47
  sink(arg: myArray1[0]) // $ tainted=47

  // ---

  var myArray2: [UInt8] = [1, 2, 3, 4]

  sink(arg: myArray2)
  sink(arg: myArray2[0])
  let return2 = myArray2.withUnsafeMutableBufferPointer({
    buffer in
    buffer.baseAddress!.pointee = source()
    sink(arg: buffer)
    sink(arg: buffer[0]) // $ MISSING: tainted=65
    sink(arg: buffer.baseAddress!.pointee) // $ MISSING: tainted=65
    return source()
  })
  sink(arg: return2) // $ tainted=69
  sink(arg: myArray2)
  sink(arg: myArray2[0]) // $ MISSING: tainted=65

  // ---

  var myArray3: [UInt8] = [1, 2, 3, 4]

  sink(arg: myArray3)
  sink(arg: myArray3[0])
  let return3 = myArray3.withContiguousMutableStorageIfAvailable({
    ptr in
    ptr.update(repeating: source())
    sink(arg: ptr) // $ tainted=83
    sink(arg: ptr[0]) // $ tainted=83
    return source()
  })
  sink(arg: return3!) // $ tainted=86
  sink(arg: myArray3) // $ tainted=83
  sink(arg: myArray3[0]) // $ tainted=83

  // ---

  var myArray4: [UInt8] = [1, 2, 3, 4]
  var myArray5: [UInt8] = [5, 6, 7, 8]

  myArray5[0] = source()
  sink(arg: myArray4)
  sink(arg: myArray4[0])
  sink(arg: myArray5) // $ tainted=97
  sink(arg: myArray5[0]) // $ tainted=97
  let return4 = myArray4.withUnsafeMutableBytes({
    ptr4 in
    let return5 = myArray5.withUnsafeBytes({
      ptr5 in
      sink(arg: ptr5)
      sink(arg: ptr5[0]) // $ MISSING: tainted=97
      ptr4.copyBytes(from: ptr5)
      sink(arg: ptr4)
      sink(arg: ptr4[0]) // $ MISSING: tainted=97
      return source()
    })
    sink(arg: return5) // $ tainted=111
    return source()
  })
  sink(arg: return4) // $ tainted=114
  sink(arg: myArray4)
  sink(arg: myArray4[0]) // $ MISSING: tainted=97
  sink(arg: myArray5) // $ tainted=97
  sink(arg: myArray5[0]) // $ tainted=97

  // ---

  var myMutableBuffer = UnsafeMutableBufferPointer<Int>.allocate(capacity: 1)
  myMutableBuffer.initialize(repeating: 1)

  sink(arg: myMutableBuffer)
  sink(arg: myMutableBuffer[0])
  let return6 = myMutableBuffer.withContiguousMutableStorageIfAvailable({
    ptr in
    ptr.update(repeating: source2())
    sink(arg: ptr) // $ tainted=131
    sink(arg: ptr[0]) // $ tainted=131
    return source()
  })
  sink(arg: return6!) // $ tainted=134
  sink(arg: myMutableBuffer) // $ tainted=131
  sink(arg: myMutableBuffer[0]) // $ tainted=131
}

func taintCollections(array: inout Array<Int>, contiguousArray: inout ContiguousArray<Int>, dictionary: inout Dictionary<Int, Int>) {
  array[0] = source2()
  sink(arg: array) // $ tainted=142
  sink(arg: array[0]) // $ tainted=142
  array.withContiguousStorageIfAvailable({
    buffer in
    sink(arg: buffer) // $ tainted=142
    sink(arg: buffer[0]) // $ tainted=142
    sink(arg: array)
    sink(arg: array[0]) // $ MISSING: tainted=142
  })

  contiguousArray[0] = source2()
  sink(arg: contiguousArray)
  sink(arg: contiguousArray[0]) // $ MISSING: tainted=153
  contiguousArray.withContiguousStorageIfAvailable({
    buffer in
    sink(arg: buffer)
    sink(arg: buffer[0]) // $ MISSING: tainted=153
  })

  dictionary[0] = source2()
  sink(arg: dictionary)
  sink(arg: dictionary[0]!) // $ tainted=162
  dictionary.withContiguousStorageIfAvailable({
    buffer in
    sink(arg: buffer)
    sink(arg: buffer[0]) // $ MISSING: tainted=162
  })
}
