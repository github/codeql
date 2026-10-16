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

func t7() {
    let x = source("t7.1")
    func local(_: Int) {
        sink(x)  // $ hasValueFlow=t7.1
    }
    local(123)
}

func t8() {
    var x = "safe"
    func local(arg: Int) {
        x = source("t8.1")
    }
    sink(x)  // no flow
    local(arg: 123)
    sink(x)  // $ hasValueFlow=t8.1
}

func t9() {
    // Use of a local function before its declaration
    let x = source("t9.1")
    let y = local()
    sink(y)  // $ hasValueFlow=t9.1

    func local() -> String {
        sink(x)  // $ hasValueFlow=t9.1
        return x
    }
}

func t10() {
    let x = source("t10.1")
    let closure1 = { [x1 = x] in
        sink(x1)  // $ hasValueFlow=t10.1
    }
    let closure2 = { [x] in
        sink(x)  // $ hasValueFlow=t10.1
    }
    closure1()
    closure2()
}

func t11() {
    let x = source("t11.1")
    let closure = { [x = x, blah = x] in
        sink(x)  // $ hasValueFlow=t11.1
        sink(blah)  // $ hasValueFlow=t11.1
    }
    closure()
}

func t12() {
    class Box {
        var value: String
        init(_ x: String) { self.value = x }
    }
    let x = Box(source("t12.1"))
    let closure = { [weak x] in
        guard let x else { return }
        sink(x.value)  // $ MISSING: hasValueFlow=t12.1
    }
    closure()
}

func t13() {
    var x = "safe"
    let closure1 = { [x] in
        sink(x)  // no flow
    }
    let closure2 = {
        sink(x)  // $ hasValueFlow=t13.1
    }
    closure1()
    closure2()
    x = source("t13.1")
    closure1()
    closure2()
}

class C {
    var x: String

    func capture_self_by_ref() {
        x = source("C.1")
        let closure = {
            sink(self.x)  // $ hasValueFlow=C.1
        }
        closure()
    }

    func capture_self() {
        x = source("C.2")
        let closure = { [self] in
            sink(self.x)  // $ hasValueFlow=C.2
            sink(x)  // $ hasValueFlow=C.2
        }
        closure()
    }

    func capture_weak_self() {
        x = source("C.3")
        let closure = { [weak self] in
            guard let self else { return }
            sink(self.x)  // $ hasValueFlow=C.3
            sink(x)  // $ hasValueFlow=C.3
        }
        closure()
    }

    func capture_unowned_self() {
        x = source("C.4")
        let closure = { [unowned self] in
            sink(self.x)  // $ hasValueFlow=C.4
            sink(x)  // $ hasValueFlow=C.4
        }
        closure()
    }
}
