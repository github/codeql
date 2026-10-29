func source(_ s: String) -> String { return s }

@discardableResult
func sink(_ s: Any) -> String { return "" }

func t1() {
    class C {
        static var x: String { source("t1.1") }
    }
    sink(C.x)  // $ hasValueFlow=t1.1
}

func t2() {
    // Note: swift-format will try to remove the explicit 'get' below
    // swift-format-ignore
    class C {
        static var x: String {
            get { source("t2.1") }
        }
    }
    sink(C.x)  // $ hasValueFlow=t2.1
}

func t3() {
    class C {
        static var x: String {
            get { source("t3.1") }
            set {}
        }
    }
    sink(C.x)  // $ hasValueFlow=t3.1
}

func t4() {
    class C {
        static var x: String {
            get {}
            set { sink(newValue) }  // $ hasValueFlow=t4.1
        }
    }
    C.x = source("t4.1")
}

func t5() {
    class C {
        static var x: String {
            get { source("t5.1") }
            set { sink(newValue) }  // $ hasValueFlow=t5.1
        }
    }
    C.x = C.x
}

func t6() {
    class C {
        static var x: String { source("t6.1") }

        func method() {
            sink(Self.x)  // $ hasValueFlow=t6.1
        }

        static func staticMethod() {
            sink(Self.x)  // $ hasValueFlow=t6.1
            sink(x)  // $ hasValueFlow=t6.1
        }
    }
}
