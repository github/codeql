func source(_ s: String) -> String { return s }

@discardableResult
func sink(_ s: String) -> String { return "" }

func t1() {
    func target(_ x: String) {
        sink(x)  // $ MISSING: hasValueFlow=t1.1
    }
    target(source("t1.1"))
}

func t2() {
    func target() -> String {
        return source("t2.1")
    }
    sink(target())  // $ MISSING: hasValueFlow=t2.1
}

func t3() {
    func target(x: String) {
        sink(x)  // $ MISSING: hasValueFlow=t3.1
    }
    target(x: source("t3.1"))
}

func t4() {
    func target(_ x: String) -> String {
        return x + "foo"
    }
    sink(target(source("t4.1")))  // $ MISSING: hasTaintFlow=t4.1
    sink(target(source("t4.2")))  // $ MISSING: hasTaintFlow=t4.2
    sink(target("safe"))
}

func t5() {
    func target1(name x: String) {
        sink(x)  // $ MISSING: hasValueFlow=t5.1
    }
    target1(name: source("t5.1"))

    func target2(name: String) {
        sink(name)  // $ MISSING: hasValueFlow=t5.2
    }
    target2(name: source("t5.2"))
}

func t6() {
    func target(_ x: String, _ y: String) {
        sink(x)  // $ MISSING: hasValueFlow=t6.1
        sink(y)  // $ MISSING: hasValueFlow=t6.2
    }
    target(source("t6.1"), source("t6.2"))
}

class Box {
    var field: String = ""
}

func t7() {
    func target(_ x: Box) {
        x.field = source("t7.1")
    }
    let b = Box()
    sink(b.field)  // no flow
    target(b)
    sink(b.field)  // $ MISSING: hasValueFlow=t7.1
}
