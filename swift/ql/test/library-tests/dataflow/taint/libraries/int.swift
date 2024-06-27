
// --- stubs ---

// --- tests ---

func source(_ label: String) -> UInt8 { return 0; }
func source2() -> Int { return 0; }
func sink(arg: Any) {}

func taintThroughClosurePointer() {
  var myArray1: [UInt8] = [1, 2, 3, 4]

  myArray1[0] = source("myArray1")
  sink(arg: myArray1) // $ tainted=myArray1
  sink(arg: myArray1[0]) // $ tainted=myArray1
  let return1 = myArray1.withUnsafeBytes({
    ptr1 in
    sink(arg: ptr1) // $ tainted=myArray1
    sink(arg: ptr1[0]) // $ tainted=myArray1
    return source("return1")
  })
  sink(arg: return1) // $ tainted=return1

  // ---

  var myArray2: [UInt8] = [1, 2, 3, 4]

  myArray2[0] = source("myArray2")
  sink(arg: myArray2) // $ tainted=myArray2
  sink(arg: myArray2[0]) // $ tainted=myArray2
  let return2 = myArray2.withUnsafeBufferPointer({
    ptr2 in
    sink(arg: ptr2) // $ tainted=myArray2
    sink(arg: ptr2[0]) // $ tainted=myArray2
    return source("return2")
  })
  sink(arg: return2) // $ tainted=return2
}

func taintThroughMutablePointer() {
  var myArray1: [UInt8] = [1, 2, 3, 4]

  sink(arg: myArray1)
  sink(arg: myArray1[0])
  let return1 = myArray1.withUnsafeMutableBufferPointer({
    buffer in
    buffer.update(repeating: source("array1write"))
    sink(arg: buffer) // $ tainted=array1write
    sink(arg: buffer[0]) // $ tainted=array1write
    sink(arg: buffer.baseAddress!.pointee) // $ MISSING: tainted=array1write
    return source("return1")
  })
  sink(arg: return1) // $ tainted=return1
  sink(arg: myArray1) // $ tainted=array1write
  sink(arg: myArray1[0]) // $ tainted=array1write

  // ---

  var myArray2: [UInt8] = [1, 2, 3, 4]

  sink(arg: myArray2)
  sink(arg: myArray2[0])
  let return2 = myArray2.withUnsafeMutableBufferPointer({
    buffer in
    buffer.baseAddress!.pointee = source("array2write")
    sink(arg: buffer)
    sink(arg: buffer[0]) // $ MISSING: tainted=array2write
    sink(arg: buffer.baseAddress!.pointee) // $ MISSING: tainted=array2write
    return source("return2")
  })
  sink(arg: return2) // $ tainted=return2
  sink(arg: myArray2)
  sink(arg: myArray2[0]) // $ MISSING: tainted=array2write

  // ---

  var myArray3: [UInt8] = [1, 2, 3, 4]

  sink(arg: myArray3)
  sink(arg: myArray3[0])
  let return3 = myArray3.withContiguousMutableStorageIfAvailable({
    ptr in
    ptr.update(repeating: source("array3write"))
    sink(arg: ptr) // $ tainted=array3write
    sink(arg: ptr[0]) // $ tainted=array3write
    return source("return3")
  })
  sink(arg: return3!) // $ tainted=return3
  sink(arg: myArray3) // $ tainted=array3write
  sink(arg: myArray3[0]) // $ tainted=array3write

  // ---

  var myArray4: [UInt8] = [1, 2, 3, 4]
  var myArray5: [UInt8] = [5, 6, 7, 8]

  myArray5[0] = source("array5write")
  sink(arg: myArray4)
  sink(arg: myArray4[0])
  sink(arg: myArray5) // $ tainted=array5write
  sink(arg: myArray5[0]) // $ tainted=array5write
  let return4 = myArray4.withUnsafeMutableBytes({
    ptr4 in
    let return5 = myArray5.withUnsafeBytes({
      ptr5 in
      sink(arg: ptr5) // $ tainted=array5write
      sink(arg: ptr5[0]) // $ tainted=array5write
      ptr4.copyBytes(from: ptr5)
      sink(arg: ptr4) // $ tainted=array5write
      sink(arg: ptr4[0]) // $ tainted=array5write
      return source("return5")
    })
    sink(arg: return5) // $ tainted=return5
    return source("return4")
  })
  sink(arg: return4) // $ tainted=return4
  sink(arg: myArray4)
  sink(arg: myArray4[0]) // $ MISSING: tainted=array5write
  sink(arg: myArray5) // $ tainted=array5write
  sink(arg: myArray5[0]) // $ tainted=array5write

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
    return source("return6")
  })
  sink(arg: return6!) // $ tainted=return6
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
    sink(arg: array) // $ tainted=142
    sink(arg: array[0]) // $ tainted=142
  })

  contiguousArray[0] = source2()
  sink(arg: contiguousArray) // $ tainted=153
  sink(arg: contiguousArray[0]) // $ tainted=153
  contiguousArray.withContiguousStorageIfAvailable({
    buffer in
    sink(arg: buffer) // $ tainted=153
    sink(arg: buffer[0]) // $ tainted=153
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
