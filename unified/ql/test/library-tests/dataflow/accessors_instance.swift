func source(_ s: String) -> String { return s }

@discardableResult
func sink(_ s: Any) -> String { return "" }

func t1() {
    class C {
        var x: String { source("t1.1") }
    }
    sink(C().x)  // $ hasValueFlow=t1.1
}

func t2() {
    // Note: swift-format will try to remove the explicit 'get' below
    // swift-format-ignore
    class C {
        var x: String {
            get { source("t2.1") }
        }
    }
    sink(C().x)  // $ hasValueFlow=t2.1
}

func t3() {
    class C {
        var x: String {
            get { source("t3.1") }
            set {}
        }
    }
    sink(C().x)  // $ hasValueFlow=t3.1
}

func t4() {
    class C {
        var x: String {
            get {}
            set { sink(newValue) }  // $ hasValueFlow=t4.1
        }
    }
    C().x = source("t4.1")
}

func t5() {
    class C {
        var x: String {
            get { source("t5.1") }
            set { sink(newValue) }  // $ hasValueFlow=t5.1
        }
    }
    let c = C()
    c.x = c.x
}

func t6() {
    class C {
        var x: String { source("t6.1") }

        func method() {
            sink(self.x)  // $ hasValueFlow=t6.1
            sink(x)  // $ hasValueFlow=t6.1
        }
    }
}

func t7() {
    class C {
        var field: String = "safe"
        var x: String { self.field }
    }
    var c = C()
    sink(c.x)  // no flow
    c.field = source("t7.1")
    sink(c.x)  // $ hasValueFlow=t7.1
}

func t8() {
    class C {
        var field: String = "safe"
        var otherField: String = "safe"
        var x: String {
            get {}
            set { otherField = field + newValue }
        }
    }
    var c = C()
    c.field = source("t8.1")
    c.x = "safe"  // trigger the setter
    sink(c.otherField)  // $ MISSING: hasTaintFlow=t8.1
}
