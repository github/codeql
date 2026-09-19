func source(_ s: String) -> String { return s }

@discardableResult
func sink(_ s: String) -> String { return "" }

class Box {
    var x: String = ""
}

class C {
    var x: String = ""
    var box = Box()

    func t1() {
        sink(self.x)  // no flow
        self.x = source("t1.1")
        sink(self.x)  // $ hasValueFlow=t1.1
    }

    func t2() {
        sink(x)  // no flow
        x = source("t2.1")
        sink(x)  // $ hasValueFlow=t2.1
    }

    func t3() {
        sink(self.x)  // no flow
        x = source("t3.1")
        sink(self.x)  // $ hasValueFlow=t3.1
    }

    func t4() {
        sink(x)  // no flow
        self.x = source("t4.1")
        sink(x)  // $ hasValueFlow=t4.1
    }

    func t5() {
        sink(self.box.x)  // no flow
        self.box.x = source("t5.1")
        sink(self.box.x)  // $ hasValueFlow=t5.1
    }

    func t6() {
        sink(box.x)  // no flow
        box.x = source("t6.1")
        sink(box.x)  // $ hasValueFlow=t6.1
    }

    func t7() {
        sink(self.box.x)  // no flow
        box.x = source("t7.1")
        sink(self.box.x)  // $ hasValueFlow=t7.1
    }

    func t8() {
        sink(box.x)  // no flow
        self.box.x = source("t8.1")
        sink(box.x)  // $ hasValueFlow=t8.1
    }

    func t9() {
        x = "safe"
        x += sink(x) + source("t9.1")
        sink(x)  // $ hasTaintFlow=t9.1
        sink(self.x)  // $ hasTaintFlow=t9.1
    }

    func t10() {
        x = "safe"
        self.x += sink(x) + source("t10.1")
        sink(x)  // $ hasTaintFlow=t10.1
        sink(self.x)  // $ hasTaintFlow=t10.1
    }

    func t11() {
        self.x = "safe"
        x += sink(x) + source("t11.1")
        sink(x)  // $ hasTaintFlow=t11.1
        sink(self.x)  // $ hasTaintFlow=t11.1
    }

    func t12() {
        self.x = "safe"
        self.x += sink(x) + source("t12.1")
        sink(x)  // $ hasTaintFlow=t12.1
        sink(self.x)  // $ hasTaintFlow=t12.1
    }
}
