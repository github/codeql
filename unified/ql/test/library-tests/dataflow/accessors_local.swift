func source(_ s: String) -> String { return s }

@discardableResult
func sink(_ s: Any) -> String { return "" }

func t1() {
    var x: String { source("t1.1") }
    sink(x)  // $ hasValueFlow=t1.1
}

func t2() {
    // Note: swift-format will try to remove the explicit 'get' below
    // swift-format-ignore
    var x: String {
        get { source("t2.1") }
    }
    sink(x)  // $ hasValueFlow=t2.1
}

func t3() {
    var x: String {
        get { source("t3.1") }
        set {}
    }
    sink(x)  // $ hasValueFlow=t3.1
}

func t4() {
    var x: String {
        get {}
        set { sink(newValue) }  // $ hasValueFlow=t4.1
    }
    x = source("t4.1")
}

func t5() {
    var x: String {
        get { source("t5.1") }
        set { sink(newValue) }  // $ hasValueFlow=t5.1
    }
    x = x
}

func t6() {
    var y: String = source("t6.1")
    var x: String { y }
    sink(x)  // $ hasValueFlow=t6.1
}

func t7() {
    var y: String = "safe"
    var x: String { y }
    sink(x)  // no flow
    y = source("t7.1")
    sink(x)  // $ hasValueFlow=t7.1
}

func t8() {
    var x: String { source("t8.1") }
    let closure = {
        sink(x)  // $ hasValueFlow=t8.1
    }
    closure()
}

func t9() {
    var y: String = "safe"
    var x: String { y }
    let closure = {
        sink(x)  // $ hasValueFlow=t9.1
    }
    y = source("t9.1")
    closure()
}
