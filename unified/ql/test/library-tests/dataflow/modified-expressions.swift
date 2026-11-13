func testBorrow() {
    let original = source("borrow")
    let borrowed = borrow original
    sink(borrowed)  // $ MISSING: hasValueFlow=borrow
}

func testConsume() {
    let original = source("consume")
    let consumed = consume original
    sink(consumed)  // $ MISSING: hasValueFlow=consume
}

func testCopy() {
    let original = source("copy")
    let copied = copy original
    sink(copied)  // $ MISSING: hasValueFlow=copy
}

func testUnsafe() {
    let original = source("unsafe")
    let unchecked = unsafe original
    sink(unchecked)  // $ MISSING: hasValueFlow=unsafe
}
