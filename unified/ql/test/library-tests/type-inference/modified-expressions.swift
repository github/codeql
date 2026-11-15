func testBorrowTypeInference() {
  let value = 42
  let borrowed = borrow value  // $ MISSING: type=borrowed:Int
  let original = Generic(v: "borrow")  // $ target=Generic.init
  let generic = borrow original  // $ MISSING: type=generic@Generic<T>:String
  let result = generic.getValue()  // $ MISSING: type=result:String target=Generic.getValue
}

func testConsumeTypeInference() {
  let value = 42
  let consumed = consume value  // $ MISSING: type=consumed:Int
  let original = Generic(v: "consume")  // $ target=Generic.init
  let generic = consume original  // $ MISSING: type=generic@Generic<T>:String
  let result = generic.getValue()  // $ MISSING: type=result:String target=Generic.getValue
}

func testCopyTypeInference() {
  let value = 42
  let copied = copy value  // $ MISSING: type=copied:Int
  let original = Generic(v: "copy")  // $ target=Generic.init
  let generic = copy original  // $ MISSING: type=generic@Generic<T>:String
  let result = generic.getValue()  // $ MISSING: type=result:String target=Generic.getValue
}

func testUnsafeTypeInference() {
  let value = 42
  let unchecked = unsafe value  // $ MISSING: type=unchecked:Int
  let original = Generic(v: "unsafe")  // $ target=Generic.init
  let generic = unsafe original  // $ MISSING: type=generic@Generic<T>:String
  let result = generic.getValue()  // $ MISSING: type=result:String target=Generic.getValue
}
