func source(_ s: String) -> String { return s }

@discardableResult
func sink(_ s: String) -> String {
    print(s)
    return ""
}

func t1() {
    let x = source("t1.1")
    let closure = { (_: Int) in
        sink(x)  // $ hasValueFlow=t1.1
    }
    closure(123)
}

func t2() {
    var x = "safe"
    let closure = { (arg: Int) in
        x = source("t2.1")
    }
    sink(x)  // no flow
    closure(123)
    sink(x)  // $ hasValueFlow=t2.1
}

func t3() {
    let x = source("t3.1")
    var y1 = "safe"
    var y2 = "safe"
    let closure = { (arg: Int) in
        y1 = x
        y2 = x + "blah"
    }
    sink(y1)  // no flow
    sink(y2)  // no flow
    closure(123)
    sink(y1)  // $ hasValueFlow=t3.1
    sink(y2)  // $ hasTaintFlow=t3.1
}

func t4() {
    let x = source("t4.1")
    var y = "safe"
    let closure = { (arg: String) in
        y = arg
    }
    sink(y)  // no flow
    closure(x)
    sink(y)  // $ hasValueFlow=t4.1
}

func t5() {
    let x = source("t5.1")
    var y = ("safe", "safe")
    let closure = { (arg: String) in
        y.0 = arg
    }
    sink(y.0)  // no flow
    closure(x)
    sink(y.0)  // $ hasValueFlow=t5.1
}

func t6() {
    var x = "safe"
    let closure = { (_: Int) in
        sink(x)  // $ hasValueFlow=t6.1
    }
    x = source("t6.1")
    closure(123)
}
