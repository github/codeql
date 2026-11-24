func testShorthandParameters() {
    let closure = {  // implicit-param0=first implicit-param1=second
        print($0)  // $ access=first
        print($0)  // $ access=first
        print($1)  // $ access=second
    }
    closure(1, 2)  // $ access=closure
}

func testNestedShorthandParameters() {
    let outer = {  // implicit-param0=outer
        print($0)  // $ access=outer
        let inner = {  // implicit-param0=inner0 implicit-param1=inner1
            print($1)  // $ access=inner1
            print($0)  // $ access=inner0
        }
        inner(2, 3)  // $ access=inner
        print($0)  // $ access=outer
    }
    outer(1)  // $ access=outer
}

func testSkippedShorthandParameter() {
    let closure: (Int, Int) -> Void = {  // implicit-param1=second
        print($1)  // $ access=second
    }
    closure(1, 2)  // $ access=closure
}
