func source(_ s: String) -> String { return s }

@discardableResult
func sink(_ s: String) -> String { return "" }

func s1() {
    class C {
        subscript(i: Int) -> String { source("s1.1") }
    }
    sink(C()[0])  // $ hasValueFlow=s1.1
}

func s2() {
    class C {
        subscript(key: String) -> String {
            get { key }
            set { sink(newValue) }  // $ hasValueFlow=s2.2
        }
    }
    let c = C()
    sink(c[source("s2.1")])  // $ hasValueFlow=s2.1
    c["safe"] = source("s2.2")
}

func s3() {
    class C {
        subscript(key: String) -> String {
            get { "safe" }
            set(v) { sink(key); sink(v) }  // $ hasValueFlow=s3.1 hasValueFlow=s3.2
        }
    }
    let c = C()
    c[source("s3.1")] = source("s3.2")
}

func s4() {
    class C {
        var field: String = "safe"
        subscript(at i: Int, _ j: Int) -> String {
            get { field }
            set { field = newValue }
        }
    }
    let c = C()
    c[at: 0, 1] = source("s4.1")
    sink(c[at: 1, 2])  // $ hasValueFlow=s4.1
    sink(c.field)  // $ hasValueFlow=s4.1
}

func s5() {
    class C {
        subscript(i: Int) -> String {
            get { source("s5.1") }
            set { sink(newValue) }  // $ hasTaintFlow=s5.1
        }
    }
    let c = C()
    c[0] += "x"
}

func s6() {
    struct S {
        var field: String = "safe"
    }
    class C {
        subscript(i: Int) -> S {
            get { S() }
            set { sink(newValue.field) }  // $ hasValueFlow=s6.1
        }
    }
    let c = C()
    // `S` has value type, so this calls the subscript getter followed by the setter
    c[0].field = source("s6.1")
}

func s7() {
    class C {
        var field: String = "safe"
        subscript(i: Int) -> String {
            get { field }
            set { field = newValue }
        }

        func method() {
            self[0] = source("s7.1")
            sink(self[1])  // $ hasValueFlow=s7.1
        }
    }
}

func s8() {
    struct S {
        var field: String = "safe"
        subscript(i: Int) -> String {
            get { field }
            set { field = newValue }
        }
    }
    class C {
        var s: S {
            get { S() }
            set { sink(newValue.field) }  // $ hasValueFlow=s8.1
        }
    }
    let c = C()
    // `S` has value type, so this writes back to `s` via its setter
    c.s[0] = source("s8.1")
}

func s9() {
    struct S {
        var field: String = "safe"
        subscript(i: Int) -> String {
            get { field }
            set { field = newValue }
        }
    }
    var s = S()
    s[0] = source("s9.1")
    sink(s[0])  // $ hasValueFlow=s9.1
}

func s10() {
    class C {
        static subscript(i: Int) -> String {
            get { source("s10.1") }
            set { sink(newValue) }  // $ hasValueFlow=s10.2
        }
    }
    C[0] = source("s10.2")
    sink(C[0])  // $ hasValueFlow=s10.1
}

func s11(t: TestType) {
    sink(t[testKey: source("s11.1")])  // $ hasValueFlow=s11.1
    t[testKey: source("s11.2")] = "safe"
}

func s12() {
    struct S {
        var field: String = "safe"
    }
    class C {
        subscript(i: Int) -> S {
            get { S() }
            set { sink(newValue.field) }  // $ hasValueFlow=s12.1
        }
    }
    func update(_ s: inout S) { s.field = source("s12.1") }
    let c = C()
    update(&c[0])
}
