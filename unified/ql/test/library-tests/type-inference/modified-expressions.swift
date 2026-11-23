func testBorrowTypeInference() {
  let value = 42
  let borrowed = borrow value  // $ type=borrowed:Int
  let original = Generic(v: "borrow")  // $ target=Generic.init
  let generic = borrow original  // $ type=generic@Generic<T>:String
  let result = generic.getValue()  // $ type=result:String target=Generic.getValue
}

func testConsumeTypeInference() {
  let value = 42
  let consumed = consume value  // $ type=consumed:Int
  let original = Generic(v: "consume")  // $ target=Generic.init
  let generic = consume original  // $ type=generic@Generic<T>:String
  let result = generic.getValue()  // $ type=result:String target=Generic.getValue
}

func testCopyTypeInference() {
  let value = 42
  let copied = copy value  // $ type=copied:Int
  let original = Generic(v: "copy")  // $ target=Generic.init
  let generic = copy original  // $ type=generic@Generic<T>:String
  let result = generic.getValue()  // $ type=result:String target=Generic.getValue
}

func testUnsafeTypeInference() {
  let value = 42
  let unchecked = unsafe value  // $ type=unchecked:Int
  let original = Generic(v: "unsafe")  // $ target=Generic.init
  let generic = unsafe original  // $ type=generic@Generic<T>:String
  let result = generic.getValue()  // $ type=result:String target=Generic.getValue
}
