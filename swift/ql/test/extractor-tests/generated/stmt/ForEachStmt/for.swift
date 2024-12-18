struct S {}

func test_sequence(_ ints: [Int], _ elements: [S]) {
    for x in ints where x != 0 {
        print(x)
    }
    for s in elements {
      print(s)
    }
}

func test_variadic_pack<each T>(_ array: repeat [each T]) -> Bool {
    for x in repeat each array {
        if !x.isEmpty {
            return false
        }
    }
    return true
}
