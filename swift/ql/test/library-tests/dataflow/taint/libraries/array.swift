
// --- stubs ---

// --- tests ---

func source(_ label: String) -> Int { return 0 }
func sink(arg: Any) {}

// ---

func testArray() {
  let arrClean = Array<Int>()

  var arr1 = Array<Int>()
  arr1.append(1)
  sink(arg: arr1[arr1.endIndex - 1])
  arr1.append(source("int1"))
  sink(arg: arr1[arr1.endIndex - 1]) // $ tainted=int1

  var arr2 = Array<Int>()
  arr2.append(contentsOf: arrClean)
  sink(arg: arr2[arr2.endIndex - 1])
  arr2.append(contentsOf: arr1)
  sink(arg: arr2[arr2.endIndex - 1]) // $ tainted=int1

  var arr3 = Array<Int>()
  arr3.insert(1, at: 0)
  sink(arg: arr3[0])
  arr3.insert(source("int3"), at: 0)
  sink(arg: arr3[0]) // $ tainted=int3

  var arr4 = Array<Int>()
  arr4.insert(contentsOf: arrClean, at: 0)
  sink(arg: arr4[0])
  arr4.insert(contentsOf: arr3, at: 0)
  sink(arg: arr4[0]) // $ tainted=int3

  var arr5 = Array<Int>()
  arr5.insert(contentsOf: 1...10, at: 0)
  sink(arg: arr5[arr5.endIndex - 1])
  arr5.insert(contentsOf: 1...source("int5"), at: 0)
  sink(arg: arr5[arr5.endIndex - 1]) // $ MISSING: tainted=int5
}
