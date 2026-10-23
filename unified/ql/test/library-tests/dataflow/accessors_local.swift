func source(_ s: String) -> String { return s }

@discardableResult
func sink(_ s: Any) -> String { return "" }

func t1() {
    var x: String { source("t1.1") }
    sink(x)  // $ MISSING: hasValueFlow=t1.1
}

func t2() {
    // Note: swift-format will try to remove the explicit 'get' below
    // swift-format-ignore
    var x: String {
        get { source("t2.1") }
    }
    sink(x)  // $ MISSING: hasValueFlow=t2.1
}

func t3() {
    var x: String {
        get { source("t3.1") }
        set {}
    }
    sink(x)  // $ MISSING: hasValueFlow=t3.1
}

func t4() {
    var x: String {
        get {}
        set { sink(newValue) }  // $ MISSING: hasValueFlow=t4.1
    }
    x = source("t4.1")
}

func t5() {
    var x: String {
        get { source("t5.1") }
        set { sink(newValue) }  // $ MISSING: hasValueFlow=t5.1
    }
    x = x
}

func t6() {
    var y: String = source("t6.1")
    var x: String { y }
    sink(x)  // $ MISSING: hasValueFlow=t6.1
}

func t7() {
    var y: String = "safe"
    var x: String { y }
    sink(x)  // no flow
    y = source("t7.1")
    sink(x)  // $ MISSING: hasValueFlow=t7.1
}
