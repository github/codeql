func source(_ s: String) -> String { return s }

@discardableResult
func sink(_ s: String) -> String { return "" }

func t1() {
    func target(_ x: String) {
        sink(x)  // $ hasValueFlow=t1.1
    }
    target(source("t1.1"))
}

func t2() {
    func target() -> String {
        return source("t2.1")
    }
    sink(target())  // $ hasValueFlow=t2.1
}

func t3() {
    func target(x: String) {
        sink(x)  // $ hasValueFlow=t3.1
    }
    target(x: source("t3.1"))
}

func t4() {
    func target(_ x: String) -> String {
        return x + "foo"
    }
    sink(target(source("t4.1")))  // $ hasTaintFlow=t4.1
    sink(target(source("t4.2")))  // $ hasTaintFlow=t4.2
    sink(target("safe"))
}

func t5() {
    func target1(name x: String) {
        sink(x)  // $ hasValueFlow=t5.1
    }
    target1(name: source("t5.1"))

    func target2(name: String) {
        sink(name)  // $ hasValueFlow=t5.2
    }
    target2(name: source("t5.2"))
}

func t6() {
    func target(_ x: String, _ y: String) {
        sink(x)  // $ hasValueFlow=t6.1
        sink(y)  // $ hasValueFlow=t6.2
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
    sink(b.field)  // $ hasValueFlow=t7.1
}

func t8() {
    class C {
        var field: String = ""

        func store() {
            field = source("t8.1")
        }

        func read1() {
            sink(field)  // no flow
            store()
            sink(field)  // $ hasValueFlow=t8.1
        }

        func read2() {
            sink(field)  // no flow
            store()
            sink(self.field)  // $ hasValueFlow=t8.1
        }

        func read3() {
            sink(field)  // no flow
            self.store()
            sink(field)  // $ MISSING: hasValueFlow=t8.1 // self.store() not yet resolved by call graph
        }

        func read4() {
            sink(field)  // no flow
            self.store()
            sink(self.field)  // $ MISSING: hasValueFlow=t8.1 // self.store() not yet resolved by call graph
        }

        func read5() {
            sink(self.field)  // no flow
            store()
            sink(field)  // $ hasValueFlow=t8.1
        }

        func read6() {
            sink(self.field)  // no flow
            store()
            sink(self.field)  // $ hasValueFlow=t8.1
        }

        func read7() {
            sink(self.field)  // no flow
            self.store()
            sink(field)  // $ MISSING: hasValueFlow=t8.1 // self.store() not yet resolved by call graph
        }

        func read8() {
            sink(self.field)  // no flow
            self.store()
            sink(self.field)  // $ MISSING: hasValueFlow=t8.1 // self.store() not yet resolved by call graph
        }
    }
}
